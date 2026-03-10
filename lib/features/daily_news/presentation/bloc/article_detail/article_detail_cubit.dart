import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/article.dart';
import 'article_detail_state.dart';

class ArticleDetailCubit extends Cubit<ArticleDetailState> {
  ArticleDetailCubit(ArticleEntity article)
    : super(ArticleDetailInitial(article));

  void loadArticleDetails() async {
    emit(ArticleDetailLoading(state.article!));

    // Simulate some loading time or pre-fetch data if needed
    // In this case, we're just satisfying the user's request for a Cubit to handle potential slowness
    await Future.delayed(const Duration(milliseconds: 500));

    emit(ArticleDetailLoaded(state.article!));
  }
}
