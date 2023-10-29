import 'package:flutter/material.dart';
import 'package:utm_app/products.dart';

class ProductDetailsPage extends StatelessWidget {
  final Products product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),  // Название продукта в качестве заголовка
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(product.image),  // Изображение продукта
            const SizedBox(height: 16),
            // Вставка контейнеров для "Name" и "Price"
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Распределение пространства между элементами
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание текста по левому краю
                    children: <Widget>[
                      const Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Цвет текста
                        ),
                      ),
                      const SizedBox(height: 8), // Отступ между текстом и названием
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end, // Выравнивание текста по правому краю
                    children: <Widget>[
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Цвет текста
                        ),
                      ),
                      const SizedBox(height: 8), // Отступ между текстом и ценой
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ... добавьте больше деталей, которые вы хотите показать
          ],
        ),
      ),
    );
  }
}
