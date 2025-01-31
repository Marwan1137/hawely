/* -------------------------------------------------------------------------- */
/*                          CurrencyListView Widget                          */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawely/Features/HomeScreen/model/currency_model.dart';
import 'package:hawely/shared/widgets/apptheme.dart';

class CurrencyListView extends StatefulWidget {
  final List<CurrencyModel> currencies; // List of currencies to display
  final CurrencyModel baseCurrency; // Base currency for conversion
  final double amount; // Amount to convert
  final Function(String)
      onBaseSelected; // Callback when base currency is selected
  final Function(double) onAmountChanged; // Callback when amount is changed

  const CurrencyListView({
    super.key,
    required this.currencies,
    required this.baseCurrency,
    required this.amount,
    required this.onBaseSelected,
    required this.onAmountChanged,
  });

  @override
  State<CurrencyListView> createState() => _CurrencyListViewState();
}

class _CurrencyListViewState extends State<CurrencyListView> {
  late TextEditingController _amountController; // Controller for amount input
  late FocusNode _amountFocusNode; // Focus node for amount input field

  /* -------------------------------------------------------------------------- */
  /*                              Initialization                               */
  /* -------------------------------------------------------------------------- */
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.amount
            .toStringAsFixed(2)); // Initialize controller with current amount
    _amountFocusNode = FocusNode(); // Initialize focus node
    _amountFocusNode.addListener(_handleFocusChange); // Listen to focus changes
  }

  /* -------------------------------------------------------------------------- */
  /*                          Handle Widget Updates                            */
  /* -------------------------------------------------------------------------- */
  @override
  void didUpdateWidget(CurrencyListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text if amount changes and input field is not focused
    if (widget.amount != oldWidget.amount && !_amountFocusNode.hasFocus) {
      _amountController.text = widget.amount.toStringAsFixed(2);
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                          Handle Focus Change                              */
  /* -------------------------------------------------------------------------- */
  void _handleFocusChange() {
    // Update amount when input field loses focus
    if (!_amountFocusNode.hasFocus) {
      final currentValue = double.tryParse(_amountController.text) ?? 0.0;
      widget.onAmountChanged(currentValue); // Trigger callback with new amount
      _amountController.text = currentValue.toStringAsFixed(2); // Format amount
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                              Cleanup                                      */
  /* -------------------------------------------------------------------------- */
  @override
  void dispose() {
    _amountController.dispose(); // Dispose controller
    _amountFocusNode.dispose(); // Dispose focus node
    super.dispose();
  }

  /* -------------------------------------------------------------------------- */
  /*                              Build UI                                     */
  /* -------------------------------------------------------------------------- */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16), // Add spacing
        Expanded(
          child: ListView.separated(
            itemCount: widget.currencies.length, // Number of currencies
            separatorBuilder: (context, index) => const Divider(
                height: 10,
                color: Colors.transparent), // Add transparent divider
            itemBuilder: (context, index) {
              final currency = widget.currencies[index]; // Current currency
              final convertedAmount =
                  widget.amount * currency.rate; // Converted amount
              final isBase = currency.code ==
                  widget.baseCurrency.code; // Check if currency is base

              return _buildCurrencyCard(
                context,
                currencyCode: currency.code,
                amount: convertedAmount,
                exchangeRate: currency.rate,
                isBase: isBase,
                onTap: () => widget.onBaseSelected(
                    currency.code), // Callback for base currency selection
              );
            },
          ),
        ),
      ],
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Build Currency Card                              */
  /* -------------------------------------------------------------------------- */
  Widget _buildCurrencyCard(
    BuildContext context, {
    required String currencyCode, // Currency code (e.g., USD, EUR)
    required double amount, // Converted amount
    required double exchangeRate, // Exchange rate
    required bool isBase, // Whether this currency is the base currency
    required VoidCallback onTap, // Callback when card is tapped
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40), // Rounded corners
        side: BorderSide(
          width: isBase ? 3 : 2, // Thicker border for base currency
          color:
              isBase ? Apptheme.blue : Apptheme.greycustom300!, // Border color
        ),
      ),
      color: Apptheme.white, // Card background color
      margin: const EdgeInsets.symmetric(
          horizontal: 13, vertical: 4), // Card margins
      elevation: 2, // Card shadow
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8), // Padding inside the card
        onTap: onTap, // Handle tap event
        leading: _buildCurrencySymbol(currencyCode), // Currency symbol
        title: isBase
            ? TextField(
                controller:
                    _amountController, // Amount input field for base currency
                focusNode: _amountFocusNode, // Focus node for input field
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true), // Numeric keyboard
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(
                      r'^\d*\.?\d{0,2}')), // Allow only numbers and decimals
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none, // No border
                  hintText: 'Enter amount', // Hint text
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500, // Text style
                    ),
                onChanged: (value) {
                  final newAmount =
                      double.tryParse(value) ?? 0.0; // Parse new amount
                  widget.onAmountChanged(
                      newAmount); // Trigger callback with new amount
                },
              )
            : Text(
                _formatCurrency(
                    currencyCode, amount), // Display converted amount
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500, // Text style
                    ),
              ),
        subtitle: Text(
          "1 ${widget.baseCurrency.code} = ${exchangeRate.toStringAsFixed(4)} $currencyCode", // Exchange rate text
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Apptheme.black, // Text color
              ),
        ),
        trailing: Text(
          currencyCode, // Currency code
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold, // Bold text
                color: Apptheme.black, // Text color
              ),
        ),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Build Currency Symbol                            */
  /* -------------------------------------------------------------------------- */
  Widget _buildCurrencySymbol(String code) {
    return CircleAvatar(
      backgroundColor: Apptheme.white, // Background color
      child: Text(
        code, // Currency code
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Apptheme.black), // Text style
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                          Format Currency String                           */
  /* -------------------------------------------------------------------------- */
  String _formatCurrency(String code, double amount) {
    return '${amount.toStringAsFixed(2)} $code'; // Format amount with currency code
  }
}
