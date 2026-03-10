import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:journalist_app/core/network_info/network_info.dart';
import 'package:journalist_app/core/network_info/bloc/network_cubit.dart';
import 'package:journalist_app/features/daily_news/data/data_sources/remote/firebase_article_service.dart';
import 'package:journalist_app/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:journalist_app/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:journalist_app/features/daily_news/domain/usecases/get_article.dart';
import 'package:journalist_app/features/publish_article/domain/usecases/publish_article.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_cubit.dart';
import 'package:journalist_app/features/publish_article/domain/repository/publish_article_repository.dart';
import 'package:journalist_app/features/publish_article/presentation/bloc/publish_article_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  sl.registerSingleton<AppDatabase>(database);

  // Firebase
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<FirebaseArticleService>(
    FirebaseArticleService(sl(), sl()),
  );

  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Connectivity
  sl.registerSingleton<Connectivity>(Connectivity());
  sl.registerSingleton<NetworkInfo>(NetworkInfoImpl(sl()));

  // Dependencies
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));

  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl(), sl(), sl()),
  );

  sl.registerSingleton<PublishArticleRepository>(
    sl<ArticleRepository>() as ArticleRepositoryImpl,
  );

  //UseCases
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));

  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));

  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));

  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));

  sl.registerSingleton<PublishArticleUseCase>(PublishArticleUseCase(sl()));

  //Blocs
  sl.registerFactory<RemoteArticlesCubit>(() => RemoteArticlesCubit(sl()));

  sl.registerFactory<PublishArticleBloc>(() => PublishArticleBloc(sl()));

  sl.registerFactory<LocalArticleCubit>(
    () => LocalArticleCubit(sl(), sl(), sl(), sl()),
  );

  sl.registerFactory<NetworkCubit>(() => NetworkCubit(sl()));
}
