import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawely/Features/HomeScreen/model/currency_model.dart';
import 'package:hawely/apptheme.dart';

class CurrencyListView extends StatefulWidget {
  final List<CurrencyModel> currencies;
  final CurrencyModel baseCurrency;
  final double amount;
  final Function(String) onBaseSelected;
  final Function(double) onAmountChanged;

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
  late TextEditingController _amountController;
  late FocusNode _amountFocusNode;

  @override
  void initState() {
    super.initState();
    _amountController =
        TextEditingController(text: widget.amount.toStringAsFixed(2));
    _amountFocusNode = FocusNode();
    _amountFocusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(CurrencyListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amount != oldWidget.amount && !_amountFocusNode.hasFocus) {
      _amountController.text = widget.amount.toStringAsFixed(2);
    }
  }

  void _handleFocusChange() {
    if (!_amountFocusNode.hasFocus) {
      final currentValue = double.tryParse(_amountController.text) ?? 0.0;
      widget.onAmountChanged(currentValue);
      _amountController.text = currentValue.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: widget.currencies.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 10, color: Colors.transparent),
            itemBuilder: (context, index) {
              final currency = widget.currencies[index];
              final convertedAmount = widget.amount * currency.rate;
              final isBase = currency.code == widget.baseCurrency.code;

              return _buildCurrencyCard(
                context,
                currencyCode: currency.code,
                amount: convertedAmount,
                exchangeRate: currency.rate,
                isBase: isBase,
                onTap: () => widget.onBaseSelected(currency.code),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyCard(
    BuildContext context, {
    required String currencyCode,
    required double amount,
    required double exchangeRate,
    required bool isBase,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(
          width: isBase ? 3 : 2,
          color: isBase ? Apptheme.blue : Apptheme.greycustom300!,
        ),
      ),
      color: Apptheme.white,
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 4),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        leading: _buildCurrencySymbol(currencyCode),
        title: isBase
            ? TextField(
                controller: _amountController,
                focusNode: _amountFocusNode,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter amount',
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                onChanged: (value) {
                  final newAmount = double.tryParse(value) ?? 0.0;
                  widget.onAmountChanged(newAmount);
                },
              )
            : Text(
                _formatCurrency(currencyCode, amount),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
        subtitle: Text(
          "1 ${widget.baseCurrency.code} = ${exchangeRate.toStringAsFixed(4)} $currencyCode",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Apptheme.black,
              ),
        ),
        trailing: Text(
          currencyCode,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Apptheme.black,
              ),
        ),
      ),
    );
  }

  Widget _buildCurrencySymbol(String code) {
    return CircleAvatar(
      backgroundColor: Apptheme.white,
      child: Text(
        code,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Apptheme.black),
      ),
    );
  }

  String _formatCurrency(String code, double amount) {
    return '${amount.toStringAsFixed(2)} $code';
  }
}
