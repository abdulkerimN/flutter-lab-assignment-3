import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/album.dart';
import '../models/photo.dart';
import '../repositories/album_repository.dart';

// Events
abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlbums extends AlbumEvent {}

class LoadAlbumPhotos extends AlbumEvent {
  final int albumId;

  const LoadAlbumPhotos(this.albumId);

  @override
  List<Object?> get props => [albumId];
}

// States
abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object?> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  final Map<int, List<Photo>> albumPhotos;

  const AlbumLoaded({
    required this.albums,
    required this.albumPhotos,
  });

  @override
  List<Object?> get props => [albums, albumPhotos];
}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository _repository;

  AlbumBloc(this._repository) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadAlbumPhotos>(_onLoadAlbumPhotos);
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await _repository.getAlbums();
      final photos = await _repository.getPhotos();
      
      final albumPhotos = <int, List<Photo>>{};
      for (var album in albums) {
        albumPhotos[album.id] = photos.where((photo) => photo.albumId == album.id).toList();
      }

      emit(AlbumLoaded(albums: albums, albumPhotos: albumPhotos));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  Future<void> _onLoadAlbumPhotos(LoadAlbumPhotos event, Emitter<AlbumState> emit) async {
    if (state is AlbumLoaded) {
      final currentState = state as AlbumLoaded;
      try {
        final photos = await _repository.getAlbumPhotos(event.albumId);
        final updatedAlbumPhotos = Map<int, List<Photo>>.from(currentState.albumPhotos);
        updatedAlbumPhotos[event.albumId] = photos;

        emit(AlbumLoaded(
          albums: currentState.albums,
          albumPhotos: updatedAlbumPhotos,
        ));
      } catch (e) {
        emit(AlbumError(e.toString()));
      }
    }
  }
} 