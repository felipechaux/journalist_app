import 'dart:io';

import 'package:dio/dio.dart';
import 'package:journalist_app/core/constants/constants.dart';
import 'package:journalist_app/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:journalist_app/features/daily_news/data/models/article.dart';
import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:journalist_app/features/publish_article/domain/repository/publish_article_repository.dart';
import 'package:journalist_app/core/network_info/network_info.dart';

import '../data_sources/remote/firebase_article_service.dart';
import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl
    implements ArticleRepository, PublishArticleRepository {
  final NewsApiService _newsApiService;
  final AppDatabase _appDatabase;
  final FirebaseArticleService _firebaseArticleService;
  final NetworkInfo _networkInfo;

  ArticleRepositoryImpl(
    this._newsApiService,
    this._appDatabase,
    this._firebaseArticleService,
    this._networkInfo,
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
  Future<DataState<List<ArticleEntity>>> getFirebaseArticles({
    bool? refresh,
  }) async {
    try {
      List<ArticleModel> articles = [];
      try {
        final fetchedArticles = await _firebaseArticleService.getArticles(
          forceRefresh: refresh ?? false,
        );
        // Clean up accidentally uploaded artifacts with 'DRAFT_ARTICLE' tag from remote
        articles = fetchedArticles.map((a) {
          if (a.url == 'DRAFT_ARTICLE') {
            return ArticleModel(
              id: a.id,
              author: a.author,
              title: a.title,
              description: a.description,
              url: '',
              urlToImage: a.urlToImage,
              publishedAt: a.publishedAt,
              content: a.content,
            );
          }
          return a;
        }).toList();
      } catch (e) {
        // Fallback to cache without force refresh if offline
        if (refresh == true) {
          try {
            articles = await _firebaseArticleService.getArticles(
              forceRefresh: false,
            );
          } catch (_) {}
        }
      }

      final localArticles = await _appDatabase.articleDAO.getArticles();
      final drafts = localArticles
          .where((a) => a.url == 'DRAFT_ARTICLE')
          .toList();

      final combined = [...drafts, ...articles];

      return DataSuccess(combined);
    } catch (e) {
      return DataFailed(
        DioException(
          error: e.toString(),
          requestOptions: RequestOptions(path: ''),
        ),
      );
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
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        // Save locally as draft
        // URL is set to 'DRAFT_ARTICLE' to identify it later.
        // We temporarily store the localImagePath in urlToImage if available.
        final draftArticle = ArticleModel(
          author: article.author,
          title: article.title,
          description: article.description,
          url: 'DRAFT_ARTICLE',
          urlToImage: localImagePath ?? article.urlToImage,
          publishedAt: DateTime.now().toIso8601String(),
          content: article.content,
        );
        await _appDatabase.articleDAO.insertArticle(draftArticle);
        return const DataSuccess(null);
      }

      final articleToPublish = ArticleModel(
        id: article.id,
        author: article.author,
        title: article.title,
        description: article.description,
        url: article.url == 'DRAFT_ARTICLE' ? '' : article.url,
        urlToImage: article.urlToImage,
        publishedAt: article.publishedAt,
        content: article.content,
      );

      await _firebaseArticleService.publishArticle(
        articleToPublish,
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
