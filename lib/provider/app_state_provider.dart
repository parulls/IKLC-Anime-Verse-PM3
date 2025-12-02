import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/anime.dart';
import '../repositories/anime_repository.dart';
import '../service/firestore_service.dart';

/// Main app state provider managing favorites, filtering, and search
/// This provider handles all anime-related state management
class AppStateProvider extends ChangeNotifier {
  final AnimeRepository _repository = AnimeRepository();
  final FirestoreService _firestoreService = FirestoreService();

  // API Data state
  List<Anime> _animeList = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  // Pagination state
  int _currentPage = 1;
  bool _hasMore = true;

  // Search mode state
  bool _isSearchMode = false;

  StreamSubscription<List<Anime>>? _favoritesSubscription;
  StreamSubscription<User?>? _authSubscription;

  // Favorites state
  List<Anime> _favorites = [];

  // Filtering state
  String _selectedGenre = "All";

  // Search state (separated by screen)
  String _homeSearchQuery = "";
  String _favoriteSearchQuery = "";
  Timer? _searchDebounce;

  // Getters
  List<Anime> get animeList => _animeList;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  bool get isSearchMode => _isSearchMode;
  List<Anime> get favorites => _favorites;
  String get selectedGenre => _selectedGenre;
  String get homeSearchQuery => _homeSearchQuery;
  String get favoriteSearchQuery => _favoriteSearchQuery;

  AppStateProvider() {
    _initAuthListener();
    fetchTopAnime();
  }

  void _initAuthListener() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        debugPrint('✅ User authenticated, subscribing to favorites: ${user.uid}');
        _subscribeToFavorites(user.uid);
      } else {
        debugPrint('❌ User logged out, unsubscribing from favorites');
        _unsubscribeFromFavorites();
      }
    });
  }

  void _subscribeToFavorites(String userId) {
    _favoritesSubscription?.cancel();
    _favoritesSubscription =
        _firestoreService.getFavoritesStream(userId).listen(
              (favorites) {
            debugPrint('📚 Favorites updated: ${favorites.length} items');
            _favorites = favorites;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('❌ Error loading favorites: $error');
          },
        );
  }

  void _unsubscribeFromFavorites() {
    _favoritesSubscription?.cancel();
    _favoritesSubscription = null;
    _favorites = [];
    notifyListeners();
  }

  // ========== API DATA MANAGEMENT ==========

  /// Fetch top anime from API (reset list)
  Future<void> fetchTopAnime({int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    _isSearchMode = false;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      _animeList = await _repository.getTopAnime(page: page);
    } catch (e) {
      _errorMessage = 'Failed to load anime: $e';
      debugPrint('Error fetching anime: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load more anime (pagination)
  Future<void> loadMoreAnime() async {
    if (_isLoadingMore || !_hasMore || _isSearchMode || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newAnime = await _repository.getTopAnime(page: _currentPage);

      if (newAnime.isEmpty) {
        _hasMore = false;
        debugPrint('📄 No more anime to load (reached end)');
      } else {
        _animeList.addAll(newAnime);
        debugPrint('📄 Loaded page $_currentPage: ${newAnime.length} anime');
      }
    } catch (e) {
      _errorMessage = 'Failed to load more: $e';
      debugPrint('Error loading more anime: $e');
      _currentPage--;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Search anime from API (server-side)
  Future<void> searchAnimeFromAPI(String query) async {
    if (query.trim().isEmpty) {
      await fetchTopAnime();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _isSearchMode = true;
    _hasMore = false;
    notifyListeners();

    try {
      _animeList = await _repository.searchAnime(query);
      debugPrint('🔍 Search results: ${_animeList.length} anime');
    } catch (e) {
      _errorMessage = 'Search failed: $e';
      debugPrint('Error searching anime: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get anime by ID
  Future<Anime?> getAnimeById(int malId) async {
    try {
      return await _repository.getAnimeById(malId);
    } catch (e) {
      debugPrint('Error fetching anime by ID: $e');
      return null;
    }
  }

  // ========== FAVORITES MANAGEMENT ==========

  /// Check if anime is in favorites
  bool isFavorite(int malId) {
    return _favorites.any((anime) => anime.malId == malId);
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(Anime anime) async {
    try {
      if (isFavorite(anime.malId)) {
        await removeFavorite(anime.malId);
        debugPrint('💔 Removed from favorites: ${anime.title}');
      } else {
        await addFavorite(anime);
        debugPrint('❤️ Added to favorites: ${anime.title}');
      }
    } catch (e) {
      debugPrint('❌ Error toggling favorite: $e');
    }
  }

  /// Add anime to favorites
  Future<void> addFavorite(Anime anime) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestoreService.addFavorite(user.uid, anime);
      } catch (e) {
        debugPrint('❌ Error adding favorite: $e');
        rethrow;
      }
    } else {
      debugPrint('⚠️ Cannot add favorite: User not authenticated');
    }
  }

  /// Remove anime from favorites
  Future<void> removeFavorite(int malId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _firestoreService.removeFavorite(user.uid, malId);
      } catch (e) {
        debugPrint('❌ Error removing favorite: $e');
        rethrow;
      }
    } else {
      debugPrint('⚠️ Cannot remove favorite: User not authenticated');
    }
  }

  /// Get favorites count
  int get favoritesCount => _favorites.length;

  // ========== GENRE FILTER ==========

  /// Set selected genre
  void setSelectedGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  // ========== SEARCH FUNCTIONALITY ==========

  /// Set search query for HomeScreen (with debounced API search)
  void setHomeSearchQuery(String query) {
    _homeSearchQuery = query;
    notifyListeners();

    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 800), () {
      if (query.trim().isNotEmpty) {
        searchAnimeFromAPI(query);
      } else {
        fetchTopAnime();
      }
    });
  }

  /// Set search query for FavoriteScreen
  void setFavoriteSearchQuery(String query) {
    _favoriteSearchQuery = query;
    notifyListeners();
  }

  // ========== FILTERING LOGIC ==========

  /// Get filtered anime list for HomeScreen (based on genre and home search)
  List<Anime> getFilteredAnimeForHome() {
    List<Anime> result = _animeList;

    if (_selectedGenre != "All") {
      result = result.where((anime) {
        return anime.genres.any(
                (genre) => genre.toLowerCase() == _selectedGenre.toLowerCase());
      }).toList();
    }

    if (_homeSearchQuery.isNotEmpty) {
      result = result.where((anime) {
        return anime.title
            .toLowerCase()
            .contains(_homeSearchQuery.toLowerCase());
      }).toList();
    }

    return result;
  }

  /// Get filtered favorites for FavoriteScreen (based on favorite search)
  List<Anime> getFilteredFavorites() {
    List<Anime> result = _favorites;

    if (_favoriteSearchQuery.isNotEmpty) {
      result = result.where((anime) {
        return anime.title
            .toLowerCase()
            .contains(_favoriteSearchQuery.toLowerCase());
      }).toList();
    }

    return result;
  }

  @override
  void dispose() {
    debugPrint('🔄 Disposing AppStateProvider');
    _favoritesSubscription?.cancel();
    _authSubscription?.cancel();
    _searchDebounce?.cancel();
    _repository.dispose();
    super.dispose();
  }
}