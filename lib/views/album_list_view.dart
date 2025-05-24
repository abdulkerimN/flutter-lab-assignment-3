import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/album_bloc.dart';
import '../models/album.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumListView extends StatelessWidget {
  const AlbumListView({super.key});

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

          if (state is AlbumsLoaded) {
            return _buildAlbumList(context, state.albums);
          }

          return const Center(child: Text('No albums found'));
        },
      ),
    );
  }

  Widget _buildAlbumList(BuildContext context, List<Album> albums) {
    return ListView.builder(
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: album.thumbnailUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: album.thumbnailUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  )
                : const Icon(Icons.album),
            title: Text(
              album.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('Album ID: ${album.id}'),
            onTap: () {
              context.go('/album/${album.id}');
            },
          ),
        );
      },
    );
  }
} 