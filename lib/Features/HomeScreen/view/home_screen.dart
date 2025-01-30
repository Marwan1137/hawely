import 'package:flutter/material.dart';
import 'package:hawely/Features/HomeScreen/view/components/currencylistview.dart';
import 'package:hawely/shared/widgets/custom_appbar.dart';
import 'package:hawely/shared/widgets/custom_bottom_appbar.dart';
import 'package:hawely/shared/widgets/apptheme.dart';
import 'package:hawely/Features/HomeScreen/viewmodel/currency_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateAmount);
    Future.delayed(Duration.zero, () {
      // ignore: use_build_context_synchronously
      Provider.of<CurrencyViewmodel>(context, listen: false)
        ..fetchCurrencies()
        ..setAmount(1.0);
    });
  }

  void _updateAmount() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    Provider.of<CurrencyViewmodel>(context, listen: false).setAmount(amount);
  }

  void _showCurrencyPicker(BuildContext context) {
    final viewModel = Provider.of<CurrencyViewmodel>(context, listen: false);
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredCurrencies =
                viewModel.allCurrencies.where((currency) {
              return currency.code
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();

            return AlertDialog(
              title: const Text('Select Currency'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search currencies...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) => setState(() => searchQuery = value),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredCurrencies.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(filteredCurrencies[index].code),
                          onTap: () {
                            viewModel.addCurrency(filteredCurrencies[index]);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title1: 'Hawely',
        title2: 'Currency Converter',
        colors: [Apptheme.blue, Apptheme.darkred],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const CustomBottomAppbar(),
      body: Consumer<CurrencyViewmodel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              viewModel.selectedCurrencies.isEmpty
                  ? Center(
                      child: Text(
                        'Tab "+ Add Currency" to add currencies',
                        style: TextStyle(
                          fontSize: 20,
                          color: Apptheme.white,
                        ),
                      ),
                    )
                  : Expanded(
                      child: CurrencyListView(
                        currencies: viewModel.selectedCurrencies,
                        baseCurrency: viewModel.getBaseCurrency(),
                        amount: viewModel.amount,
                        onAmountChanged: (newAmount) =>
                            viewModel.setAmount(newAmount),
                        onBaseSelected: (newBase) {
                          Provider.of<CurrencyViewmodel>(context, listen: false)
                              .setBaseCurrency(newBase);
                        },
                      ),
                    ),
            ],
          );
        },
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor: Apptheme.white,
            icon: Icon(
              Icons.add,
              color: Apptheme.black,
            ),
            label: Text(
              'Add Currency',
              style: TextStyle(fontSize: 20, color: Apptheme.black),
            ),
            onPressed: () => _showCurrencyPicker(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
