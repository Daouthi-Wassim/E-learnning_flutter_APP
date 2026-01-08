class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final double rating;
  final int firstPublishYear;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description = '',
    required this.imageUrl,
    this.rating = 4.5,
    this.firstPublishYear = 2023,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    String authorName = 'Unknown Author';
    if (json['author_name'] != null && (json['author_name'] as List).isNotEmpty) {
      authorName = json['author_name'][0];
    }

    String imgUrl = '';
    if (json['cover_i'] != null) {
      imgUrl = 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg';
    }

    String key = json['key'] ?? '';

    return Book(
      id: key,
      title: json['title'] ?? 'No Title',
      author: authorName,
      imageUrl: imgUrl,
      firstPublishYear: json['first_publish_year'] ?? 0,
      description: json['description'] is String ? json['description'] : 'No description available.', 
    );
  }
}
