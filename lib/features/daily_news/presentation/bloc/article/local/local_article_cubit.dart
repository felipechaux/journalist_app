import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/local/local_article_state.dart';

import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/remove_article.dart';
import '../../../../domain/usecases/save_article.dart';

class LocalArticleCubit extends Cubit<LocalArticlesState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleCubit(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
  ) : super(const LocalArticlesLoading()) {
    getSavedArticles();
  }

  Future<void> getSavedArticles() async {
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles));
  }

  Future<void> removeArticle(ArticleEntity article) async {
    await _removeArticleUseCase(params: article);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles));
  }

  Future<void> saveArticle(ArticleEntity article) async {
    await _saveArticleUseCase(params: article);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticlesDone(articles));
  }
}
