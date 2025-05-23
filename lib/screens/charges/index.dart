import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../helpers/providers/theme_notifier.dart';
import '../../helpers/providers/token_provider.dart';
import '../../services/api.service.dart';
import 'addcharge.dart';
import 'viewcharges.dart';

@RoutePage()
class ChargesScreen extends StatefulWidget {
  const ChargesScreen({super.key});

  @override
  ChargesScreenState createState() => ChargesScreenState();
}

class ChargesScreenState extends State<ChargesScreen> {
  final apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final amountController = TextEditingController();

  doShowToast(String toastMessage, ToastificationType type) {
    toastification.show(
      title: Text(toastMessage),
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 2),
    );
  }

  Future<void> handleSubmit() async {
    doShowToast('Creating charge...', ToastificationType.info);
    try {
      final dynamic response = await apiService.postRequest('/charges', {
        'title': titleController.text,
        'description': descriptionController.text,
        'amount': amountController.text
      });

      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        getChargesList();
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  List filteredCharges = [];
  late List charges = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String searchQuery = "";
  String sortBy = "title";
  bool ascending = true;

  void filterCharges(String query) {
    setState(() {
      searchQuery = query;
      filteredCharges = charges.where((charge) {
        return charge.values.any((value) =>
            value.toString().toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  Future getChargesList() async {
    // doShowToast('Updating charges...', ToastificationType.info);
    setState(() {
      isLoading = true;
    });
    var dbcharges = await apiService.getRequest(
      'charges?skip=${charges.length}',
    );
    doShowToast('Done', ToastificationType.success);
    setState(() {
      charges.addAll(dbcharges.data);
      filteredCharges = List.from(charges);
      isLoading = false;
    });
  }

  List getFilteredAndSortedRows() {
    List filteredCategories = charges.where((product) {
      return product.values.any((value) =>
          value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    filteredCategories.sort((a, b) {
      if (ascending) {
        return a[sortBy].toString().compareTo(b[sortBy].toString());
      } else {
        return b[sortBy].toString().compareTo(a[sortBy].toString());
      }
    });

    return filteredCategories;
  }

  @override
  void initState() {
    super.initState();
    getChargesList();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool smallScreen = width <= 1200;
    return Consumer2<ThemeNotifier, TokenNotifier>(
        builder: (context, themeNotifier, tokenNotifier, child) {
      return Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Addcharge(
                    formKey: _formKey,
                    titleController: titleController,
                    descriptionController: descriptionController,
                    amountController: amountController,
                    handleSubmit: handleSubmit,
                  ),
                );
              },
              child: Icon(Icons.add_outlined)),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                smallScreen
                    ? SizedBox.shrink()
                    : Expanded(
                        flex: 1,
                        child: Addcharge(
                          formKey: _formKey,
                          titleController: titleController,
                          descriptionController: descriptionController,
                          amountController: amountController,
                          handleSubmit: handleSubmit,
                        ),
                      ),
                SizedBox(width: smallScreen ? 0 : 20),
                Expanded(
                  flex: 2,
                  child: Viewcharges(
                    filteredCharges: filteredCharges,
                    searchController: searchController,
                    isLoading: isLoading,
                    sortBy: sortBy,
                    ascending: ascending,
                    filterCharges: filterCharges,
                    getFilteredAndSortedRows: getFilteredAndSortedRows,
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
