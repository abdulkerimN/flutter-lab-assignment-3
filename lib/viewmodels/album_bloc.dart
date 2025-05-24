import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/album.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

// Events
abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class LoadAlbums extends AlbumEvent {}

class LoadAlbumDetails extends AlbumEvent {
  final int albumId;

  const LoadAlbumDetails(this.albumId);

  @override
  List<Object> get props => [albumId];
}

// States
abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumsLoaded extends AlbumState {
  final List<Album> albums;
  final bool isOffline;

  const AlbumsLoaded(this.albums, {this.isOffline = false});

  @override
  List<Object> get props => [albums, isOffline];
}

class AlbumDetailsLoaded extends AlbumState {
  final Album album;
  final bool isOffline;

  const AlbumDetailsLoaded(this.album, {this.isOffline = false});

  @override
  List<Object> get props => [album, isOffline];
}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  AlbumBloc(this._apiService, this._localStorageService) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadAlbumDetails>(_onLoadAlbumDetails);
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await _apiService.getAlbums();
      await _localStorageService.saveAlbums(albums);
      emit(AlbumsLoaded(albums));
    } catch (e) {
      // Try to load from local storage if API fails
      final localAlbums = _localStorageService.getAlbums();
      if (localAlbums.isNotEmpty) {
        emit(AlbumsLoaded(localAlbums, isOffline: true));
      } else {
        emit(AlbumError(e.toString()));
      }
    }
  }

  Future<void> _onLoadAlbumDetails(LoadAlbumDetails event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final album = await _apiService.getAlbumDetails(event.albumId);
      await _localStorageService.saveAlbum(album);
      emit(AlbumDetailsLoaded(album));
    } catch (e) {
      // Try to load from local storage if API fails
      final localAlbum = _localStorageService.getAlbum(event.albumId);
      if (localAlbum != null) {
        emit(AlbumDetailsLoaded(localAlbum, isOffline: true));
      } else {
        emit(AlbumError(e.toString()));
      }
    }
  }
} 