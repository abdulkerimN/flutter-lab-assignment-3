import '../models/album.dart';
import '../models/photo.dart';
import '../services/api_service.dart';

class AlbumRepository {
  final ApiService _apiService;

  AlbumRepository(this._apiService);

  Future<List<Album>> getAlbums() async {
    try {
      return await _apiService.getAlbums();
    } catch (e) {
      throw Exception('Failed to fetch albums: $e');
    }
  }

  Future<List<Photo>> getPhotos() async {
    try {
      return await _apiService.getPhotos();
    } catch (e) {
      throw Exception('Failed to fetch photos: $e');
    }
  }

  Future<List<Photo>> getAlbumPhotos(int albumId) async {
    try {
      return await _apiService.getAlbumPhotos(albumId);
    } catch (e) {
      throw Exception('Failed to fetch album photos: $e');
    }
  }
} 