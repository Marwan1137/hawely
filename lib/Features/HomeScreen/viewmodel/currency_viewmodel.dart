import 'package:flutter/material.dart';
import 'package:hawely/Features/HomeScreen/model/currency_model.dart';
import 'package:hawely/core/services/api_service.dart';

class CurrencyViewmodel extends ChangeNotifier {
  final ApiService _apiService;
  List<CurrencyModel> _allCurrencies = [];
  List<CurrencyModel> _selectedCurrencies = [];
  String _baseCurrency = 'USD'; // Initial default
  bool _isLoading = false;
  String? _error;
  double _amount = 1.0;

  // Getters
  List<CurrencyModel> get allCurrencies => _allCurrencies;
  List<CurrencyModel> get selectedCurrencies => _selectedCurrencies;
  String get baseCurrencyCode => _baseCurrency;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get amount => _amount;

  CurrencyViewmodel({required ApiService apiService})
      : _apiService = apiService;

  void addCurrency(CurrencyModel currency) {
    if (!_selectedCurrencies.any((c) => c.code == currency.code)) {
      _selectedCurrencies.add(currency);
      notifyListeners();
    }
  }

  CurrencyModel getBaseCurrency() {
    return _allCurrencies.firstWhere(
      (c) => c.code == _baseCurrency,
      orElse: () => CurrencyModel(code: _baseCurrency, rate: 1.0),
    );
  }

  Future<void> fetchCurrencies({String? newBase}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch with new base or current base
      final String targetBase = newBase ?? _baseCurrency;
      final rates =
          await _apiService.fetchCurrencyRates(baseCurrency: targetBase);

      // Update state
      _allCurrencies = rates;
      _baseCurrency = targetBase;

      // Update selected currencies with new rates
      _updateSelectedCurrencies(rates);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateSelectedCurrencies(List<CurrencyModel> latestRates) {
    _selectedCurrencies = _selectedCurrencies.map((selected) {
      return latestRates.firstWhere(
        (rate) => rate.code == selected.code,
        orElse: () => selected, // Fallback if currency removed from API
      );
    }).toList();
  }

  void setBaseCurrency(String newBase) {
    if (_baseCurrency != newBase) {
      _baseCurrency = newBase; // Immediate update for UI feedback
      notifyListeners();
      fetchCurrencies(newBase: newBase);
    }
  }

  void setAmount(double newAmount) {
    _amount = newAmount;
    notifyListeners();
  }
}
