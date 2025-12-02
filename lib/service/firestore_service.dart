import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/anime.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference _usersCollection() {
    return _firestore.collection('users');
  }

  // Get favorites stream
  Stream<List<Anime>> getFavoritesStream(String userId) {
    debugPrint('📡 Setting up favorites stream for user: $userId');

    return _usersCollection()
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) {
      debugPrint('📦 Received ${snapshot.docs.length} favorites from Firestore');

      return snapshot.docs.map((doc) {
        try {
          return Anime.fromFavoritesJson(doc.data());
        } catch (e) {
          debugPrint('❌ Error parsing anime from Firestore: $e');
          debugPrint('📄 Document data: ${doc.data()}');
          rethrow;
        }
      }).toList();
    }).handleError((error) {
      debugPrint('❌ Firestore stream error: $error');
      throw Exception('Failed to load favorites: $error');
    });
  }

  // Add favorite
  Future<void> addFavorite(String userId, Anime anime) async {
    try {
      debugPrint('➕ Adding favorite: ${anime.title} (${anime.malId})');

      await _usersCollection()
          .doc(userId)
          .collection('favorites')
          .doc(anime.malId.toString())
          .set(anime.toJson());

      debugPrint('✅ Successfully added favorite');
    } catch (e) {
      debugPrint('❌ Error adding favorite: $e');
      throw Exception('Failed to add favorite: $e');
    }
  }

  // Remove favorite
  Future<void> removeFavorite(String userId, int animeId) async {
    try {
      debugPrint('➖ Removing favorite: $animeId');

      await _usersCollection()
          .doc(userId)
          .collection('favorites')
          .doc(animeId.toString())
          .delete();

      debugPrint('✅ Successfully removed favorite');
    } catch (e) {
      debugPrint('❌ Error removing favorite: $e');
      throw Exception('Failed to remove favorite: $e');
    }
  }

  // Check if favorite exists
  Future<bool> isFavorite(String userId, int animeId) async {
    try {
      final doc = await _usersCollection()
          .doc(userId)
          .collection('favorites')
          .doc(animeId.toString())
          .get();

      return doc.exists;
    } catch (e) {
      debugPrint('❌ Error checking favorite status: $e');
      return false;
    }
  }
}