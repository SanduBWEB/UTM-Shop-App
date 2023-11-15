

// cart.dart
class Cart {
  // Singleton pattern
  Cart._privateConstructor();
  static final Cart _instance = Cart._privateConstructor();
  factory Cart() {
    return _instance;
  }

  // Мапа для хранения ID продуктов и их количества в корзине
  final Map<int, int> _items = {};

  // Метод добавления продукта в корзину
  void addToCart(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId] = _items[productId]! + 1;
    } else {
      _items[productId] = 1;
    }
  }



  void incrementQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId] = _items[productId]! + 1;
    }
  }

  void decrementQuantity(int productId) {
    if (_items.containsKey(productId) && _items[productId]! > 1) {
      _items[productId] = _items[productId]! - 1;
    } else {
      removeFromCart(productId); // Если количество равно 1, то удаляем товар из корзины
    }
  }

  void removeFromCart(int productId) {
    _items.remove(productId);
  }

  // Получение карты товаров
  Map<int, int> get items => Map.unmodifiable(_items);

  // Общее количество уникальных товаров в корзине
  int get itemCount => _items.length;

  // Общее количество всех товаров в корзине
  int get totalItemsCount => _items.values.fold(0, (sum, quantity) => sum + quantity);
}
