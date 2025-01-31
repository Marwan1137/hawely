/* -------------------------------------------------------------------------- */
/*                         Currency Viewmodel Class                           */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:hawely/Features/Auth/viewmodel/auth_viewmodel.dart';
import 'package:hawely/Features/HomeScreen/model/currency_model.dart';
import 'package:hawely/core/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyViewmodel extends ChangeNotifier {
  final ApiService _apiService; // API service for fetching currency data
  List<CurrencyModel> _allCurrencies = []; // List of all available currencies
  List<CurrencyModel> _selectedCurrencies =
      []; // List of user-selected currencies
  String _baseCurrency = 'USD'; // Default base currency
  bool _isLoading = false; // Loading state for async operations
  String? _error; // Error message if an error occurs
  double _amount = 1.0; // Default currency amount
  final SharedPreferences _prefs; // Shared preferences for storing user data
  AuthViewModel _authVM; // Auth viewmodel for user authentication state

  /* -------------------------------------------------------------------------- */
  /*                               Getters                                      */
  /* -------------------------------------------------------------------------- */
  List<CurrencyModel> get allCurrencies => _allCurrencies;
  List<CurrencyModel> get selectedCurrencies => _selectedCurrencies;
  String get baseCurrencyCode => _baseCurrency;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get amount => _amount;

  // Unique user key based on authentication state
  String get _userKey {
    if (_authVM.currentUser == null) return 'default_user'; // Fallback key
    return 'user_${_authVM.currentUser!.uid}';
  }

  /* -------------------------------------------------------------------------- */
  /*                         Constructor and Initialization                    */
  /* -------------------------------------------------------------------------- */
  CurrencyViewmodel({
    required ApiService apiService,
    required SharedPreferences prefs,
    required AuthViewModel authVM,
  })  : _apiService = apiService,
        _prefs = prefs,
        _authVM = authVM {
    _authVM.addListener(_onAuthChanged); // Listen to auth state changes
    _onAuthChanged(); // Initialize based on current auth state
  }

  /* -------------------------------------------------------------------------- */
  /*                         Add Currency to Selection                         */
  /* -------------------------------------------------------------------------- */
  void addCurrency(CurrencyModel currency) {
    if (!_selectedCurrencies.any((c) => c.code == currency.code)) {
      _selectedCurrencies.add(currency);
      _saveUserData(); // Save updated data to preferences
      notifyListeners(); // Notify UI about changes
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                  Handle Authentication State Changes                      */
  /* -------------------------------------------------------------------------- */
  void _onAuthChanged() {
    if (_authVM.currentUser != null) {
      // Load user-specific data when logged in
      _loadUserData(_authVM.currentUser!.uid);
    } else {
      // Clear data when logged out
      _selectedCurrencies.clear();
      _baseCurrency = 'USD';
      _amount = 1.0;
      notifyListeners();
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                  Update Authentication Viewmodel                          */
  /* -------------------------------------------------------------------------- */
  void updateAuthVM(AuthViewModel newAuthVM) {
    _authVM = newAuthVM;
    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                  Load User Data from Shared Preferences                   */
  /* -------------------------------------------------------------------------- */
  void _loadUserData(String userId) {
    final savedCurrencies = _prefs.getStringList('${_userKey}_currencies');
    if (savedCurrencies != null) {
      _selectedCurrencies = savedCurrencies.map((code) {
        return _allCurrencies.firstWhere(
          (c) => c.code == code,
          orElse: () => CurrencyModel(code: code, rate: 1.0),
        );
      }).toList();
    }
    _baseCurrency = _prefs.getString('${_userKey}_base') ?? 'USD';
    _amount = _prefs.getDouble('${_userKey}_amount') ?? 1.0;
    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                  Save User Data to Shared Preferences                     */
  /* -------------------------------------------------------------------------- */
  void _saveUserData() {
    if (_authVM.currentUser == null) return;
    final currencyCodes = _selectedCurrencies.map((c) => c.code).toList();
    _prefs.setStringList('${_userKey}_currencies', currencyCodes);
    _prefs.setString('${_userKey}_base', _baseCurrency);
    _prefs.setDouble('${_userKey}_amount', _amount);
  }

  /* -------------------------------------------------------------------------- */
  /*                  Get Base Currency Details                                */
  /* -------------------------------------------------------------------------- */
  CurrencyModel getBaseCurrency() {
    return _allCurrencies.firstWhere(
      (c) => c.code == _baseCurrency,
      orElse: () => CurrencyModel(code: _baseCurrency, rate: 1.0),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                  Fetch Currency Data from API                             */
  /* -------------------------------------------------------------------------- */
  Future<void> fetchCurrencies({String? newBase}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final String targetBase = newBase ?? _baseCurrency;
      final rates =
          await _apiService.fetchCurrencyRates(baseCurrency: targetBase);
      _allCurrencies = rates;
      _baseCurrency = targetBase;
      _updateSelectedCurrencies(rates);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                  Update Selected Currencies                               */
  /* -------------------------------------------------------------------------- */
  void _updateSelectedCurrencies(List<CurrencyModel> latestRates) {
    _selectedCurrencies = _selectedCurrencies.map((selected) {
      return latestRates.firstWhere(
        (rate) => rate.code == selected.code,
        orElse: () => selected,
      );
    }).toList();
  }

  /* -------------------------------------------------------------------------- */
  /*                  Set Base Currency and Update Rates                       */
  /* -------------------------------------------------------------------------- */
  void setBaseCurrency(String newBase) {
    if (_baseCurrency != newBase) {
      final newBaseRate = _allCurrencies
          .firstWhere(
            (c) => c.code == newBase,
            orElse: () => CurrencyModel(code: newBase, rate: 1.0),
          )
          .rate;
      _amount = _amount * newBaseRate;
      _updateRatesOptimistically(newBase);
      _fetchAndUpdateRealRates(newBase);
      _saveUserData();
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                  Optimistically Update Currency Rates                     */
  /* -------------------------------------------------------------------------- */
  void _updateRatesOptimistically(String newBase) {
    final oldBaseRate = _allCurrencies
        .firstWhere(
          (c) => c.code == _baseCurrency,
          orElse: () => CurrencyModel(code: _baseCurrency, rate: 1.0),
        )
        .rate;
    final newBaseRate = _allCurrencies
        .firstWhere(
          (c) => c.code == newBase,
          orElse: () => CurrencyModel(code: newBase, rate: 1.0),
        )
        .rate;
    final conversionRate = oldBaseRate / newBaseRate;
    _allCurrencies = _allCurrencies.map((c) {
      return CurrencyModel(
        code: c.code,
        rate: c.rate * conversionRate,
      );
    }).toList();
    _baseCurrency = newBase;
    _updateSelectedCurrencies(_allCurrencies);
    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                  Fetch and Update Real Rates                              */
  /* -------------------------------------------------------------------------- */
  Future<void> _fetchAndUpdateRealRates(String newBase) async {
    try {
      final rates = await _apiService.fetchCurrencyRates(baseCurrency: newBase);
      _allCurrencies = rates;
      _updateSelectedCurrencies(rates);
      notifyListeners();
    } catch (e) {
      // Optional: Handle error or revert changes
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                  Set Currency Amount                                      */
  /* -------------------------------------------------------------------------- */
  void setAmount(double newAmount) {
    _amount = newAmount;
    _saveUserData();
    notifyListeners();
  }
}
