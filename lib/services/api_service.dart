import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl = 'https://openlibrary.org';
  Future<List<Book>> searchBooks(String query) async {
    final url = Uri.parse('$baseUrl/search.json?q=$query&limit=20');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> docs = data['docs'];
        return docs.map((json) => Book.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }


  Future<Book?> getBookById(String id) async {
    final url = Uri.parse('$baseUrl$id.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        String imgUrl = 'https://via.placeholder.com/150';
        if (data['covers'] != null && (data['covers'] as List).isNotEmpty) {
           imgUrl = 'https://covers.openlibrary.org/b/id/${data['covers'][0]}-L.jpg';
        }

        String desc = 'No description available.';
        if (data['description'] != null) {
          if (data['description'] is String) {
            desc = data['description'];
          } else if (data['description'] is Map) {
            desc = data['description']['value'] ?? '';
          }
        }
        
        return Book(
          id: id,
          title: data['title'] ?? 'No Title',
          author: 'Unknown Author',
          imageUrl: imgUrl,
          description: desc,
        );
      }
      return null;
    } catch (e) {
       print('Error getting book details: $e');
      return null;
    }
  }
  Future<List<Book>> getBooksByCategory(String category) async {
    return searchBooks(category);
  }
}
