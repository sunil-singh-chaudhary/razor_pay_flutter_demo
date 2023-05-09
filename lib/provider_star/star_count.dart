import 'package:flutter/material.dart';

class StarCountProvider extends ChangeNotifier {
  int _star_count = 0;
  get getstarcount => _star_count;
  int _quantity = 1;
  get gettotalquantity => _quantity;

  void updateStarCount(int count) {
    _star_count = count;

    notifyListeners();
  }

  void addQuantity() {
    _quantity = _quantity + 1;
    notifyListeners();
  }

  void removeQuantity() {
    if (_quantity > 1) {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }
}
