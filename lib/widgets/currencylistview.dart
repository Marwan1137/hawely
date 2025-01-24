import 'package:flutter/material.dart';
import 'package:hawely/Features/HomeScreen/model/currency_model.dart';
import 'package:hawely/apptheme.dart';

class CurrencyListView extends StatelessWidget {
  final List<CurrencyModel> currencies;
  final CurrencyModel baseCurrency;
  final double amount;
  final Function(String) onBaseSelected;

  const CurrencyListView({
    super.key,
    required this.currencies,
    required this.baseCurrency,
    required this.amount,
    required this.onBaseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: currencies.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 10, color: Colors.transparent),
            itemBuilder: (context, index) {
              final currency = currencies[index];
              final convertedAmount = amount * currency.rate;
              final isBase = currency.code == baseCurrency.code;

              return _buildCurrencyCard(
                context,
                currencyCode: currency.code,
                amount: convertedAmount,
                exchangeRate: currency.rate,
                isBase: isBase,
                onTap: () => onBaseSelected(currency.code),
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
        title: Text(
          _formatCurrency(currencyCode, amount),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        subtitle: Text(
          "1 ${baseCurrency.code} = ${exchangeRate.toStringAsFixed(4)} $currencyCode",
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
