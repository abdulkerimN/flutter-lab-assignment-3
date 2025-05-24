import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'services/local_storage_service.dart';
import 'viewmodels/album_bloc.dart';
import 'utils/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  runApp(MyApp(localStorageService: localStorageService));
}
class MyApp extends StatelessWidget {
  final LocalStorageService localStorageService;

  const MyApp({
    super.key,
    required this.localStorageService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumBloc(ApiService(), localStorageService),
      child: MaterialApp.router(
       
        title: 'Album App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
} 