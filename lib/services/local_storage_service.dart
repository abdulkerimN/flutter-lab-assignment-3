import 'package:hive_flutter/hive_flutter.dart';
import '../models/album.dart';

class LocalStorageService {
  static const String albumsBoxName = 'albums';
  static const String photosBoxName = 'photos';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AlbumAdapter());
    await Hive.openBox<Album>(albumsBoxName);
  }

  Future<void> saveAlbums(List<Album> albums) async {
    final box = Hive.box<Album>(albumsBoxName);
    await box.clear();
    await box.addAll(albums);
  }

  List<Album> getAlbums() {
    final box = Hive.box<Album>(albumsBoxName);
    return box.values.toList();
  }

  Album? getAlbum(int id) {
    final box = Hive.box<Album>(albumsBoxName);
    try {
      return box.values.firstWhere((album) => album.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveAlbum(Album album) async {
    final box = Hive.box<Album>(albumsBoxName);
    await box.put(album.id, album);
  }
} 