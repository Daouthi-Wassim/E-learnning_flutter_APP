import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/book.dart';
import '../widgets/book_card.dart';
import '../widgets/category_chip.dart';
import '../../const/constants.dart';
import 'package:shimmer/shimmer.dart';
import '../data/notifiers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Book>> _booksFuture;
  
  final List<String> _categories = [
    'Programming',
    'Flutter',
    'Design',
    'Business',
    'Science',
    'Novel',
    'History'
  ];
  String _selectedCategory = 'Programming';

  @override
  void initState() {
    super.initState();
    _fetchBooks('programming');
  }

  void _fetchBooks(String query) {
    setState(() {
      _booksFuture = _apiService.searchBooks(query);
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _fetchBooks(category.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.menu_book, color: Colors.teal, size: 30),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('EduLibrary', style: textStyles.titleStyle.copyWith(fontSize: 24)),
                              const SizedBox(height: 2),
                              Text('Explore new worlds', style: textStyles.descriptionStyle.copyWith(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                           selectedIndexNotifier.value = 2; 
                        },
                        child: const CircleAvatar(
                           backgroundColor: Colors.teal,
                           radius: 20,
                           child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search books, authors...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white, size: 20),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _selectedCategory = 'Custom';
                      _booksFuture = _apiService.searchBooks(value);
                    });
                  }
                },
              ),
            ),
            
            // Categories List
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return CategoryChip(
                    label: category,
                    isSelected: category == _selectedCategory,
                    onTap: () => _onCategorySelected(category),
                  );
                },
              ),
            ),

            Expanded(
              child: FutureBuilder<List<Book>>(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingShimmer();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No books found'));
                  }

                  final books = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: SizedBox(
                          height: 160,
                          child: BookCard(book: books[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }
}
