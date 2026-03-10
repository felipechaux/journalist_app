import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/publish_article/domain/usecases/publish_article.dart';
import 'package:journalist_app/features/publish_article/domain/params/publish_article_params.dart';

import 'publish_article_event.dart';
import 'publish_article_state.dart';

class PublishArticleBloc
    extends Bloc<PublishArticleEvent, PublishArticleState> {
  final PublishArticleUseCase publishArticleUseCase;

  PublishArticleBloc(this.publishArticleUseCase)
    : super(PublishArticleInitial()) {
    on<PublishArticleSubmitted>(onPublishArticle);
  }

  void onPublishArticle(
    PublishArticleSubmitted event,
    Emitter<PublishArticleState> emit,
  ) async {
    emit(PublishArticleLoading());

    final article = ArticleEntity(title: event.title, content: event.content);

    final result = await publishArticleUseCase(
      params: PublishArticleParams(
        article: article,
        localImagePath: event.imagePath,
      ),
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
