import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/photo.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Album>> getAlbums() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/albums'));
      if (response.statusCode == 200) {
        final List<dynamic> albumsJson = json.decode(response.body);
        final List<Album> albums = albumsJson.map((json) => Album.fromJson(json)).toList();
        
        // Fetch photos for each album
        final photosResponse = await http.get(Uri.parse('$baseUrl/photos'));
        if (photosResponse.statusCode == 200) {
          final List<dynamic> photosJson = json.decode(photosResponse.body);
          final Map<int, Photo> photosMap = {};
          
          for (var photoJson in photosJson) {
            final photo = Photo.fromJson(photoJson);
            if (!photosMap.containsKey(photo.albumId)) {
              photosMap[photo.albumId] = photo;
            }
          }
          
          // Update albums with photo information
          return albums.map((album) {
            if (photosMap.containsKey(album.id)) {
              final photo = photosMap[album.id]!;
              return Album(
                id: album.id,
                userId: album.userId,
                title: album.title,
                thumbnailUrl: photo.thumbnailUrl,
                url: photo.url,
              );
            }
            return album;
          }).toList();
        }
        return albums;
      } else {
        throw Exception('Failed to load albums');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Photo>> getPhotos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/photos'));
      if (response.statusCode == 200) {
        final List<dynamic> photosJson = json.decode(response.body);
        return photosJson.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load photos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Photo>> getAlbumPhotos(int albumId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/photos?albumId=$albumId'));
      if (response.statusCode == 200) {
        final List<dynamic> photosJson = json.decode(response.body);
        return photosJson.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load album photos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Album> getAlbumDetails(int albumId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/albums/$albumId'));
      if (response.statusCode == 200) {
        final albumJson = json.decode(response.body);
        final album = Album.fromJson(albumJson);
        
        // Fetch photo for this album
        final photosResponse = await http.get(Uri.parse('$baseUrl/photos?albumId=$albumId'));
        if (photosResponse.statusCode == 200) {
          final List<dynamic> photosJson = json.decode(photosResponse.body);
          if (photosJson.isNotEmpty) {
            final photo = Photo.fromJson(photosJson.first);
            return Album(
              id: album.id,
              userId: album.userId,
              title: album.title,
              thumbnailUrl: photo.thumbnailUrl,
              url: photo.url,
            );
          }
        }
        return album;
      } else {
        throw Exception('Failed to load album details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 