import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnrollmentService {
  static const String _enrolledKey = 'enrolled_courses';
  Future<List<String>> getEnrolledCourseIds() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()!.containsKey('enrolled_book_ids')) {
         return List<String>.from(doc.data()!['enrolled_book_ids']);
      }
    } catch (e) {
      print('Error fetching enrolled books: $e');
    }
    return [];
  }
  Future<bool> isEnrolled(String courseId) async {
    final ids = await getEnrolledCourseIds();
    return ids.contains(courseId);
  }

  Future<bool> enroll(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'enrolled_book_ids': FieldValue.arrayUnion([courseId]),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
       print('Error enrolling in book: $e');
       return false;
    }
  }

  Future<bool> unenroll(String courseId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'enrolled_book_ids': FieldValue.arrayRemove([courseId]),
      });
      return true;
    } catch (e) {
      print('Error unenrolling from book: $e');
      return false;
    }
  }
}
