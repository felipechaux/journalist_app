import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/publish_article/domain/usecases/publish_article.dart';

import 'publish_article_state.dart';

class PublishArticleCubit extends Cubit<PublishArticleState> {
  final PublishArticleUseCase publishArticleUseCase;

  PublishArticleCubit(this.publishArticleUseCase)
    : super(PublishArticleInitial());

  Future<void> publishArticle({
    required String title,
    required String content,
    String? imagePath,
  }) async {
    emit(PublishArticleLoading());

    final article = ArticleEntity(title: title, content: content);

    final result = await publishArticleUseCase(
      params: PublishArticleParams(article: article, localImagePath: imagePath),
    );

    if (result is DataSuccess) {
      emit(PublishArticleSuccess());
    } else if (result is DataFailed) {
      emit(
        PublishArticleFailure(
          error: result.error?.message ?? "An error occurred",
        ),
      );
    }
  }
}
