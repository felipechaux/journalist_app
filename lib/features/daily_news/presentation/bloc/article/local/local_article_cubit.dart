import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/daily_news/domain/usecases/get_article.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:journalist_app/features/daily_news/domain/params/save_article_params.dart';
import 'package:journalist_app/features/daily_news/domain/params/remove_article_params.dart';

import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';
import 'package:journalist_app/features/publish_article/domain/usecases/publish_article.dart';
import 'package:journalist_app/features/publish_article/domain/params/publish_article_params.dart';

class LocalArticleCubit extends Cubit<LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;
  final GetArticleUseCase _getArticleUseCase;
  final PublishArticleUseCase _publishArticleUseCase;

  LocalArticleCubit(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
    this._getArticleUseCase,
    this._publishArticleUseCase,
  ) : super(const LocalArticlesLoading()) {
    getSavedArticles();
  }

  Future<void> getSavedArticles() async {
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles));
  }

  Future<void> syncSavedArticlesWithRemote() async {
    // 1. Get local saved articles
    final localArticles = await _getSavedArticleUseCase();
    if (localArticles.isEmpty) return;

    // 2. Fetch remote articles (refresh: true to bypass cache)
    final remoteDataState = await _getArticleUseCase(params: true);

    if (remoteDataState is DataSuccess && remoteDataState.data != null) {
      final remoteArticles = remoteDataState.data!;
      bool updated = false;

      // 3. For each local article, find the latest version in remote
      for (var local in localArticles) {
        if (local.url == 'DRAFT_ARTICLE') {
          // Push draft to remote
          await _publishArticleUseCase(
            params: PublishArticleParams(
              article: local,
              localImagePath: local.urlToImage,
            ),
          );
          // Remove draft after publishing
          await _removeArticleUseCase(
            params: RemoveArticleParams(article: local),
          );
          updated = true;
          continue;
        }

        final matchingRemote = remoteArticles.cast<ArticleEntity>().firstWhere((
          r,
        ) {
          // Compare URLs if both have it (NewsAPI articles)
          if (local.url != null &&
              local.url!.isNotEmpty &&
              r.url != null &&
              r.url!.isNotEmpty) {
            return r.url == local.url;
          }
          // Fallback for manually published articles without URLs.
          // Match strictly by publishedAt since it acts as a unique timestamp ID.
          // If we matched by title, title edits on the server would cause it to fail to sync.
          return r.publishedAt == local.publishedAt;
        }, orElse: () => local); // Compare business fields (exclude ID)
        final isDifferent =
            matchingRemote.title != local.title ||
            matchingRemote.content != local.content ||
            matchingRemote.description != local.description ||
            matchingRemote.urlToImage != local.urlToImage ||
            matchingRemote.author != local.author;

        if (isDifferent) {
          // Manually remove existing article first to avoid UNIQUE constraint
          // failures if build_runner didn't update the generated code yet.
          await _removeArticleUseCase(
            params: RemoveArticleParams(article: local),
          );

          // Keep the local ID for Floor to handle the replace correctly
          final updatedArticle = ArticleEntity(
            id: local.id,
            author: matchingRemote.author,
            title: matchingRemote.title,
            description: matchingRemote.description,
            url: matchingRemote.url,
            urlToImage: matchingRemote.urlToImage,
            publishedAt: matchingRemote.publishedAt,
            content: matchingRemote.content,
          );
          await _saveArticleUseCase(
            params: SaveArticleParams(article: updatedArticle),
          );
          updated = true;
        }
      }

      if (updated) {
        await getSavedArticles();
      }
    }
  }

  Future<void> removeArticle(ArticleEntity article) async {
    await _removeArticleUseCase(params: RemoveArticleParams(article: article));
    await getSavedArticles();
  }

  Future<void> saveArticle(ArticleEntity article) async {
    await _saveArticleUseCase(params: SaveArticleParams(article: article));
    await getSavedArticles();
  }
}
