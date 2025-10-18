import 'package:flutter/material.dart';

class TemaProvedor with ChangeNotifier {
  ThemeMode _modo = ThemeMode.system;
  ThemeMode get modo => _modo;

  void alternarTema() {
    _modo = _modo == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
