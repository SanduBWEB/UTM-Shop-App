import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistProvider with ChangeNotifier {
  Set<int> _wishlist = {};

  Set<int> get wishlist => _wishlist;

  void add(int productId) {
    _wishlist.add(productId);
    notifyListeners(); // Уведомляет слушателей об изменении
  }

  void remove(int productId) {
    _wishlist.remove(productId);
    notifyListeners(); // Уведомляет слушателей об изменении
  }

  bool isInWishlist(int productId) => _wishlist.contains(productId);
}


