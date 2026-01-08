import 'package:flutter/material.dart';
import '../../services/enrollment_service.dart';
import '../../services/api_service.dart';
import '../../models/book.dart';
import '../widgets/book_card.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({super.key});

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  final ApiService _apiService = ApiService();
  
  List<Book>? _savedBooks;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSavedBooks();
  }

  Future<void> _fetchSavedBooks() async {
    final ids = await _enrollmentService.getEnrolledCourseIds();
    final List<Book> books = [];
    
    for (String id in ids) {
      final book = await _apiService.getBookById(id);
      if (book != null) {
        books.add(book);
      }
    }

    if (mounted) {
      setState(() {
        _savedBooks = books;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Saved Books')),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _savedBooks == null || _savedBooks!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No saved books yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Go to Home to find books',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _savedBooks!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: SizedBox(
                        height: 160,
                        child: BookCard(book: _savedBooks![index]),
                      ),
                    );
                  },
                ),
    );
  }
}
