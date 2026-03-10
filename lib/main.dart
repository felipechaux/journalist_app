import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journalist_app/config/routes/routes.dart';
import 'package:journalist_app/features/daily_news/presentation/pages/home/daily_news.dart';
import 'config/theme/app_themes.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'package:journalist_app/core/network_info/bloc/network_cubit.dart';
import 'injection_container.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:journalist_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesCubit>(create: (context) => sl()),
        BlocProvider<NetworkCubit>(create: (context) => sl()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(),
        onGenerateRoute: AppRoutes.onGenerateRoutes,
        home: const DailyNews(),
      ),
    );
  }
}
