import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:invease/globals/actions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../globals/sidebar.dart';

import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';
import '../../services/api.service.dart';
import 'cart_section.dart';
import 'product_grid.dart';

@RoutePage()
class MakeSaleIndex extends StatefulWidget {
  final Function()? onResult;
  const MakeSaleIndex({super.key, this.onResult});

  @override
  MakeSaleIndexState createState() => MakeSaleIndexState();
}

class MakeSaleIndexState extends State<MakeSaleIndex> {
  ApiService apiService = ApiService();
  final PageController _pageController = PageController();
  PagingState<int, dynamic> _state = PagingState();
  final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();

  bool isloading = false;
  late List<dynamic> products = [];
  List filteredProducts = [];
  bool isLoading = true;
  int numberOfProducts = 0;
  static int pageCount = 20;
  List savedCarts = [];

  List<Map<String, dynamic>> cart = [];

  updateFilteredProductsCount(id, product) {
    int filteredIndex =
        filteredProducts.indexWhere((p) => p['_id'] == product['_id']);
    if (filteredIndex != -1) {
      filteredProducts[filteredIndex]['quantity']--;
    }
  }

  void addToCart(productId) {
    var product = filteredProducts
        .firstWhere((product) => product['_id'] == productId, orElse: () => {});
    if (product['quantity'] > 0) {
      setState(() {
        int existingIndex = cart.indexWhere((item) => item['_id'] == productId);
        if (existingIndex != -1) {
          if (cart[existingIndex]['quantity'] <
              cart[existingIndex]['maxQuantity']) {
            cart[existingIndex]['quantity']++;
            cart[existingIndex]['total'] =
                cart[existingIndex]['quantity'] * cart[existingIndex]['price'];
            updateFilteredProductsCount(product['_id'], product);
          }
        } else {
          // Add new product to cart

          cart.add({
            '_id': product['_id'],
            'title': product['title'],
            'price': product['price'],
            'quantity': 1,
            'total': product['price'],
            'cost': product['cost'],
            'maxQuantity': product['quantity']
          });
          updateFilteredProductsCount(product['_id'], product);
        }
      });
    }
  }

  void removeFromCart(String productId) {
    setState(() {
      // Find the removed product in products list and restore its quantity
      int productIndex =
          filteredProducts.indexWhere((p) => p['_id'] == productId);
      if (productIndex != -1) {
        // Get the quantity that was in cart before removal
        int cartQuantity = cart.firstWhere((item) => item['_id'] == productId,
            orElse: () => {'quantity': 0})['quantity'];
        filteredProducts[productIndex]['quantity'] += cartQuantity;
      }
      cart.removeWhere((item) => item['_id'] == productId);
    });
  }

  void decrementCartQuantity(String productId) {
    setState(() {
      int cartIndex = cart.indexWhere((item) => item['_id'] == productId);
      if (cartIndex != -1) {
        if (cart[cartIndex]['quantity'] > 1) {
          cart[cartIndex]['quantity']--;
          cart[cartIndex]['total'] =
              cart[cartIndex]['quantity'] * cart[cartIndex]['price'];

          // Increment product quantity in products list
          int productIndex =
              filteredProducts.indexWhere((p) => p['_id'] == productId);
          if (productIndex != -1) {
            filteredProducts[productIndex]['quantity']++;
          }
        } else {
          removeFromCart(productId);
        }
      }
    });
  }

  void incrementCartQuantity(String productId) {
    setState(() {
      int cartIndex = cart.indexWhere((item) => item['_id'] == productId);
      if (cartIndex != -1) {
        if (cart[cartIndex]['quantity'] < cart[cartIndex]['maxQuantity']) {
          cart[cartIndex]['quantity']++;
          cart[cartIndex]['total'] =
              cart[cartIndex]['quantity'] * cart[cartIndex]['price'];

          // Increment product quantity in products list
          int productIndex =
              filteredProducts.indexWhere((p) => p['_id'] == productId);
          if (productIndex != -1) {
            filteredProducts[productIndex]['quantity']--;
          }
        }
      }
    });
  }

  void updateCartItemQuantity(String productId, int newQuantity) {
    setState(() {
      int index = cart.indexWhere((item) => item['_id'] == productId);
      if (index != -1) {
        // Ensure quantity doesn't exceed available stock
        newQuantity = min(newQuantity, cart[index]['maxQuantity']);
        // Ensure quantity is at least 1
        newQuantity = max(1, newQuantity);

        cart[index]['quantity'] = newQuantity;
        cart[index]['total'] = cart[index]['quantity'] * cart[index]['price'];
      }
    });
  }

  double getCartTotal() {
    return cart.fold(0, (sum, item) => sum + item['total']);
  }

  Future getProductsList() async {
    if (_state.isLoading) return;
    setState(() {
      // set loading to true and remove any previous error
      _state = _state.copyWith(isLoading: true, error: null);
    });

    try {
      final newKey = (_state.keys?.last ?? 0) + 1;
      final newItems = await apiService.getRequest(
          'products?filter={"isAvailable" : true}&sort={"title": 1}&limit=20&skip=$numberOfProducts&select=" title price quantity isAvailable "');
      final isLastPage = newItems.data.length < pageCount;

      setState(() {
        numberOfProducts = newItems.data.length;
        filteredProducts.addAll(newItems.data);
        _state = _state.copyWith(
          pages: [...?_state.pages, newItems.data],
          keys: [...?_state.keys, newKey],
          hasNextPage: !isLastPage,
          isLoading: false,
        );
      });
    } catch (error) {
      setState(() {
        _state = _state.copyWith(
          error: error,
          isLoading: false,
        );
      });
    }
  }

  void searchProducts(String? query) async {
    if (_state.isLoading) return;
    setState(() {
      // set loading to true and remove any previous error
      numberOfProducts = 0;
      _state = _state.copyWith(isLoading: true, error: null);
    });

    try {
      final newKey = (_state.keys?.last ?? 0) + 1;
      final newItems = await apiService.getRequest(
          'products?filter={"isAvailable" : true, "title": {"\$regex": "$query"}}&sort={"title": 1}&limit=20&skip=$numberOfProducts&select=" title price quantity isAvailable "');

      final isLastPage = newItems.data.length < pageCount;

      setState(() {
        numberOfProducts = newItems.data.length;
        _state = _state.copyWith(
          pages: [newItems.data],
          keys: [newKey],
          hasNextPage: !isLastPage,
          isLoading: false,
        );
        filteredProducts = newItems.data;
      });
    } catch (error) {
      setState(() {
        _state = _state.copyWith(
          error: error,
          isLoading: false,
        );
      });
    }
  }

  void resetData() async {
    setState(() {
      filteredProducts = [];
      numberOfProducts = 0;
    });
    getProductsList();
  }

  void saveCartToStorage() async {
    if (cart.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var savedCart = prefs.getString('cart') ?? '[]';
      List cartArray = jsonDecode(savedCart);
      setState(() {
        cartArray.add(cart);
        savedCarts = cartArray;
        cart = [];
      });
      String cartJson = jsonEncode(cartArray);
      await prefs.setString('cart', cartJson);
    }
  }

  void loadCartFromStorage(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var storageCart = savedCarts.elementAt(index);
    setState(() {
      cart = List<Map<String, dynamic>>.from(storageCart);
      savedCarts.removeAt(index);
      prefs.setString('cart', json.encode(savedCarts));
    });
  }

  void getCartsFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var carts = prefs.getString('cart');

    if (carts != null) {
      var cartsArray = jsonDecode(carts);
      setState(() {
        savedCarts = List.from(cartsArray);
      });
    } else {
      savedCarts = [];
    }
  }

  void removeCartFromStorage(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCarts.removeAt(index);
      prefs.setString('cart', json.encode(savedCarts));
    });
  }

  void emptycart() {
    setState(() {
      cart = [];
    });
  }

  void handleSubmited() async {
    emptycart();
    // await getProductsList();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCartsFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<TokenNotifier, ThemeNotifier>(
        builder: (context, tokenNotifier, themeNotifier, child) {
      return Scaffold(
          appBar: AppBar(
            actions: [
              ...savedCarts.asMap().entries.map((res) {
                int index = res.key; // Get the index
                // String value = res.value;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: savedCartsIcon(index),
                );
              }),
              ...actions(context, themeNotifier, tokenNotifier)
            ],
          ),
          drawer: smallScreen
              ? Drawer(
                  backgroundColor:
                      Theme.of(context).drawerTheme.backgroundColor,
                  child: SideBar(tokenNotifier: tokenNotifier))
              : null,
          floatingActionButton: smallScreen
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        // height: MediaQuery.of(context).size.height * 0.8,
                        padding: const EdgeInsets.all(8.0),
                        child: CartSection(
                          isSmallScreen: smallScreen,
                          saveCart: saveCartToStorage,
                          emptyCart: emptycart,
                          cart: cart,
                          cartTotal: getCartTotal(),
                          decrementCartQuantity: decrementCartQuantity,
                          incrementCartQuantity: incrementCartQuantity,
                          removeFromCart: removeFromCart,
                          handleComplete: handleSubmited,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.shopping_cart_outlined))
              : null,
          body: Padding(
            padding: EdgeInsets.only(top: 8.0, right: smallScreen ? 0 : 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProductGrid(
                  reset: resetData,
                  smallScreen: smallScreen,
                  addToCart: addToCart,
                  searchProducts: searchProducts,
                  searchFocusNode: _searchFocusNode,
                  searchController: _searchController,
                  state: _state,
                  fetchNextPage: getProductsList,
                ),
                SizedBox(width: 10),
                smallScreen
                    ? SizedBox.shrink()
                    : CartSection(
                        isSmallScreen: smallScreen,
                        cart: cart,
                        cartTotal: getCartTotal(),
                        decrementCartQuantity: decrementCartQuantity,
                        incrementCartQuantity: incrementCartQuantity,
                        removeFromCart: removeFromCart,
                        saveCart: saveCartToStorage,
                        emptyCart: emptycart,
                        handleComplete: handleSubmited,
                      ),
              ],
            ),
          ));
    });
  }

  InkWell savedCartsIcon(int index) {
    return InkWell(
      onTap: () {
        loadCartFromStorage(index);
      },
      child: Stack(
        clipBehavior: Clip.none, // Ensures the close icon is not clipped
        alignment: Alignment.topRight,
        children: [
          CircleAvatar(
            radius: 16, // Increased size for visibility

            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 16, // Adjust icon size
            ),
          ),
          Positioned(
            right: -4, // Adjust position
            top: -4, // Adjust position
            child: InkWell(
              onTap: () {
                removeCartFromStorage(index);
              },
              child: CircleAvatar(
                radius: 8, // Small red circle
                backgroundColor: Colors.red, // Red background
                child: Icon(
                  Icons.close,
                  size: 10, // Adjust size of X icon
                  color: Colors.white, // White color for X icon
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
