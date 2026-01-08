import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/book.dart';
import '../../const/constants.dart';
import '../../services/enrollment_service.dart';
import '../../services/api_service.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final EnrollmentService _enrollmentService = EnrollmentService();
  final ApiService _apiService = ApiService();
  
  bool _isSaved = false;
  bool _isLoading = true;
  String? _fullDescription;

  @override
  void initState() {
    super.initState();
    _checkSavedStatus();
    _fetchFullDetails();
  }

  Future<void> _checkSavedStatus() async {
    final status = await _enrollmentService.isEnrolled(widget.book.id);
    if (mounted) {
      setState(() {
        _isSaved = status;
        _isLoading = false;
      });
    }
  }
  Future<void> _fetchFullDetails() async {
    if (widget.book.description.length > 20) {
      return;
    }
    
    var fullBook = await _apiService.getBookById(widget.book.id);
    if (mounted && fullBook != null) {
      setState(() {
        _fullDescription = fullBook.description;
      });
    }
  }

  Future<void> _toggleSave() async {
    setState(() => _isLoading = true);
    
    bool success = false;
    String message = '';
    
    if (_isSaved) {
       success = await _enrollmentService.unenroll(widget.book.id);
       message = success ? 'Book Removed.' : 'Failed to remove book.';
    } else {
       success = await _enrollmentService.enroll(widget.book.id);
       message = success ? 'Book Added to Library!' : 'Failed to save book. Check Firestore setup.';
    }

    await _checkSavedStatus();
    
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? null : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayDesc = _fullDescription ?? widget.book.description;
    if (displayDesc.isEmpty || displayDesc == 'No description available.') {
      displayDesc = 'Fetching description from Open Library...';
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.book.title, style: const TextStyle(fontSize: 12, color: Colors.white, shadows: [Shadow(blurRadius: 10, color: Colors.black)])),
              background: Hero(
                tag: widget.book.id,
                child: CachedNetworkImage(
                  imageUrl: widget.book.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                         label: Text('${widget.book.firstPublishYear}', style: const TextStyle(color: Colors.white)),
                         backgroundColor: Colors.teal,
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      const Text(
                        '4.5', // Mock rating
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.book.title,
                    style: textStyles.titleStyle.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${widget.book.author}',
                    style: textStyles.descriptionStyle.copyWith(fontSize: 16),
                  ),
                   const SizedBox(height: 16),
  
                  const SizedBox(height: 24),
                  const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    displayDesc,
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _toggleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSaved ? Colors.grey : Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(
                            _isSaved ? 'Saved in Library' : 'Add to My Books',
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
