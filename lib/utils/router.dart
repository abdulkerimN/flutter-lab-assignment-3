import 'package:go_router/go_router.dart';
import '../views/album_list_view.dart';
import '../views/album_detail_view.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AlbumListView(),
    ),
    GoRoute(
      path: '/album/:id',
      builder: (context, state) {
        final albumId = int.parse(state.pathParameters['id']!);
        return AlbumDetailView(albumId: albumId);
      },
    ),
  ],
); 