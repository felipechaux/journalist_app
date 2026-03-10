import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/usecases/share_article.dart';
import 'article_detail_state.dart';

class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  final ShareArticleUseCase _shareArticleUseCase;

  ArticleDetailCubit(ArticleEntity article, this._shareArticleUseCase)
    : super(ArticleDetailInitial(article));

  Future<void> loadArticleDetails() async {
    emit(ArticleDetailLoading(state.article!));

    // Simulate some loading time or pre-fetch data if needed
    // In this case, we're just satisfying the user's request for a Cubit to handle potential slowness
    await Future.delayed(const Duration(milliseconds: 500));

    emit(ArticleDetailLoaded(state.article!));
  }

  Future<void> shareArticle() async {
    if (state.article != null) {
      await _shareArticleUseCase(params: state.article!);
    }
  }
}
