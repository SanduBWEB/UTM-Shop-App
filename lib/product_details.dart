import 'dart:convert';
import 'package:http/http.dart' as http;

Future<ProductDetails> fetchProductDetails(int id) async {
  final response = await http.get(Uri.parse('https://api-ebs-mobile.devebs.net/product/$id'));

  if (response.statusCode == 200) {
    return ProductDetails.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load product details');
  }
}

class ProductDetails {
  final int id;
  final String title;
  final double price;
  final String description;
  final Category category;
  final String mainImage;
  final List<Attribute> attributes;
  final List<String> images;
  final int totalReviews;
  final double reviewAverage;

  ProductDetails({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.mainImage,
    required this.attributes,
    required this.images,
    required this.totalReviews,
    required this.reviewAverage,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      title: json['title'],
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      mainImage: json['main_image'],
      attributes: (json['attributes'] as List).map((e) => Attribute.fromJson(e)).toList(),
      images: List<String>.from(json['images']),
      totalReviews: json['total_reviews'],
      reviewAverage: json['review_average'],
    );
  }
}

class Category {
  final int id;
  final String title;
  final String image;

  Category({required this.id, required this.title, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }
}

class Attribute {
  final int id;
  final String title;
  final List<String> values;

  Attribute({required this.id, required this.title, required this.values});

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      title: json['title'],
      values: List<String>.from(json['values']),
    );
  }
}
