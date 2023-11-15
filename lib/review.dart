import 'dart:convert';
import 'package:http/http.dart' as http;

class Review {
  final int id;
  final String createdAt;
  final Author author;
  final int rate;
  final String text;
  final int productId;

  Review({
    required this.id,
    required this.createdAt,
    required this.author,
    required this.rate,
    required this.text,
    required this.productId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      createdAt: json['created_at'] ?? 'Unknown date',
      author: Author.fromJson(json['author']),
      rate: json['rate'],
      text: json['text'],
      productId: json['product_id'],
    );
  }
}

class Author {
  final int id;
  final String name;
  final String avatar;

  Author({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

Future<List<Review>> fetchReviews(int productId) async {
  final response = await http.get(Uri.parse('https://api-ebs-mobile.devebs.net/reviews/$productId'));


  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((review) => Review.fromJson(review)).toList();
  } else {
    throw Exception('Failed to load reviews');
  }

}


