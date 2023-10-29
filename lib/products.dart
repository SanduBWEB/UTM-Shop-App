import 'dart:convert';
import 'package:http/http.dart' as http;


Future<List<Products>> fetchProducts() async {
  var url = Uri.parse('https://api-ebs-mobile.devebs.net/products');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Products.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}
class Products {
  final int id;
  final String title;
  final double price;
  final String image;
  final String categoryTitle;

  Products({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.categoryTitle,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(), // Убедитесь, что цена конвертируется в double
      image: json['image'],
      categoryTitle: json['category_title'],
    );
  }
}
