import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  Future<Map<String, String>> getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {
        'firstName': 'Student',
        'lastName': '',
        'name': 'Student',
        'bio': 'Learning Flutter',
        'role': 'Student',
        'email': ''
      };
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final firstName = data['firstName'] ?? '';
        final lastName = data['lastName'] ?? '';
        return {
          'firstName': firstName,
          'lastName': lastName,
          'name': '$firstName $lastName'.trim(), // For backward compatibility
          'bio': data['bio'] ?? 'Learning Flutter',
          'role': data['role'] ?? 'Student',
          'email': data['email'] ?? user.email ?? '',
        };
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }

    return {
      'firstName': 'Student', 
      'lastName': '', 
      'name': user.displayName ?? 'Student', 
      'bio': 'Learning Flutter',
      'role': 'Student',
      'email': user.email ?? ''
    };
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? role,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};
    if (firstName != null) updates['firstName'] = firstName;
    if (lastName != null) updates['lastName'] = lastName;
    if (bio != null) updates['bio'] = bio;
    if (role != null) updates['role'] = role;

    if (updates.isNotEmpty) {
       await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
         updates, SetOptions(merge: true)
       );
    }
  }
}
