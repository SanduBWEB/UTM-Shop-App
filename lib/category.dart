import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List<Category>> fetchCategories() async {
  final response = await http.get(Uri.parse('https://api-ebs-mobile.devebs.net/categories'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Category.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}


class Category {
  final int id;
  final String title;
  final String image;

  Category({
    required this.id,
    required this.title,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }
}
