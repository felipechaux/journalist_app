import 'dart:io';

import 'package:dio/dio.dart';
import 'package:journalist_app/core/constants/constants.dart';
import 'package:journalist_app/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:journalist_app/features/daily_news/data/models/article.dart';
import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';

import '../data_sources/remote/firebase_article_service.dart';
import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final AppDatabase _appDatabase;
  final FirebaseArticleService _firebaseArticleService;

  ArticleRepositoryImpl(
    this._newsApiService,
    this._appDatabase,
    this._firebaseArticleService,
  );

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _appDatabase.articleDAO.getArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _appDatabase.articleDAO.deleteArticle(
      ArticleModel.fromEntity(article),
    );
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _appDatabase.articleDAO.insertArticle(
      ArticleModel.fromEntity(article),
    );
  }

  @override
  Future<DataState<void>> publishArticle(
    ArticleEntity article, {
    String? localImagePath,
  }) async {
    try {
      await _firebaseArticleService.publishArticle(
        ArticleModel.fromEntity(article),
        localImagePath: localImagePath,
      );
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(
        DioException(
          error: e.toString(),
          requestOptions: RequestOptions(path: ''),
        ),
      );
    }
  }
}
