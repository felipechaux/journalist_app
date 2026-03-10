import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journalist_app/config/routes/routes.dart';
import 'package:journalist_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:journalist_app/config/theme/app_themes.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'package:journalist_app/core/network_info/bloc/network_cubit.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/local/local_article_cubit.dart';
import 'injection_container.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:journalist_app/firebase_options.dart';
import 'package:journalist_app/l10n/app_localizations.dart';
import 'package:journalist_app/core/localization/bloc/locale_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticlesCubit>(create: (context) => sl()),
        BlocProvider<LocalArticleCubit>(create: (context) => sl()),
        BlocProvider<NetworkCubit>(create: (context) => sl()),
        BlocProvider<LocaleCubit>(create: (context) => LocaleCubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme(),
            onGenerateRoute: AppRoutes.onGenerateRoutes,
            home: const SplashScreen(),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
