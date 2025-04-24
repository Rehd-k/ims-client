import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../helpers/financial_string_formart.dart';

class ProductGrid extends StatelessWidget {
  final bool smallScreen;
  final Function(String) addToCart;
  final FocusNode searchFocusNode;
  final TextEditingController searchController;
  final Function(String?) searchProducts;
  final dynamic state;
  final dynamic fetchNextPage;
  final Function reset;

  const ProductGrid(
      {super.key,
      required this.smallScreen,
      required this.addToCart,
      required this.searchFocusNode,
      required this.searchController,
      required this.searchProducts,
      required this.state,
      required this.fetchNextPage,
      required this.reset});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: smallScreen ? 1 : 3,
        child: Column(children: [
          // Search bar row
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${0} Products',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: smallScreen
                      ? searchFocusNode.hasFocus
                          ? 200
                          : 100
                      : searchFocusNode.hasFocus
                          ? 500
                          : 300,
                  height: 30,
                  child: TextField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    onChanged: (value) {
                      searchProducts(value);
                    },
                    decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            searchController.clear();
                            searchProducts('');
                            reset();
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 0)),
                  ),
                )
              ],
            ),
          ),
          // Grid view
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(smallScreen ? 2 : 16.0),
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => fetchNextPage(),
                    ),
                    child: PagedAlignedGridView.count(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      crossAxisCount: smallScreen ? 2 : 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      // childAspectRatio: 1.2,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, res, index) =>
                            productItem(res, context, index),
                      ),
                    ),
                  ))
              // isLoading
              //     ? const Center(
              //         child: CircularProgressIndicator(),
              //       )
              //     :

              )

          // GridView.count(
          //   crossAxisSpacing: 16,
          //   mainAxisSpacing: 16,
          //   crossAxisCount: smallScreen ? 2 : 4,
          //   childAspectRatio: 1.2,
          //   children: filteredProducts
          //       .map((res) =>
          // Material(
          //             color: Color((Random().nextDouble() * 0xFFFFFF)
          //                     .toInt())
          //                 .withValues(alpha: 1.0),
          //             borderRadius: BorderRadius.circular(10),
          //             child: InkWell(
          //               borderRadius: BorderRadius.circular(8),
          //               onTap: () => addToCart(res['_id']),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Column(
          //                   mainAxisAlignment:
          //                       MainAxisAlignment.center,
          //                   children: [
          //                     Text(
          //                       res['title'].toString(),
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .titleMedium,
          //                       textAlign: TextAlign.center,
          //                       overflow: TextOverflow.ellipsis,
          //                     ),
          //                     const SizedBox(height: 8),
          //                     Text(
          //                       res['quantity']
          //                           .toString()
          //                           .formatToFinancial(),
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .bodyLarge,
          //                     ),
          //                     const SizedBox(height: 4),
          //                     Text(
          //                       res['price']
          //                           .toString()
          //                           .formatToFinancial(
          //                               isMoneySymbol: true),
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .titleLarge,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           )
          //           )
          //       .toList(),
          // ),

          //         ),
        ]));
  }

  Material productItem(dynamic res, BuildContext context, index) {
    return Material(
      color: (res['quantity'] == 0)
          ? Colors.red
          : (index % 2 == 0)
              ? Colors.green
              : (index % 5 == 0)
                  ? Colors.yellow
                  : Colors.pink,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => addToCart(res['_id'].toString()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                res!['title'].toString(),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                res['quantity'].toString().formatToFinancial(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                res['price'].toString().formatToFinancial(isMoneySymbol: true),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
