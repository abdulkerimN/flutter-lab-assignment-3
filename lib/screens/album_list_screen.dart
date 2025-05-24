import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/album_bloc.dart';
import 'album_detail_screen.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumInitial) {
            context.read<AlbumBloc>().add(LoadAlbums());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AlbumBloc>().add(LoadAlbums());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AlbumLoaded) {
            return ListView.builder(
              itemCount: state.albums.length,
              itemBuilder: (context, index) {
                final album = state.albums[index];
                final photos = state.albumPhotos[album.id] ?? [];
                final thumbnailUrl = photos.isNotEmpty ? photos.first.thumbnailUrl : '';

                return ListTile(
                  leading: thumbnailUrl.isNotEmpty
                      ? Image.network(
                          thumbnailUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported);
                          },
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(album.title),
                  subtitle: Text('Album ID: ${album.id}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlbumDetailScreen(album: album),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('No albums found'));
        },
      ),
    );
  }
} 