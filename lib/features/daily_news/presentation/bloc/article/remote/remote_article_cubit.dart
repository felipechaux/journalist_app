import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/usecases/get_article.dart';
import 'package:journalist_app/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';

class RemoteArticlesCubit extends Cubit<RemoteArticlesState> {
  final GetArticleUseCase _getArticleUseCase;

  RemoteArticlesCubit(this._getArticleUseCase)
    : super(const RemoteArticlesLoading()) {
    getArticles(); // Fetch automatically on creation
  }

  Future<void> getArticles() async {
    emit(const RemoteArticlesLoading());
    final dataState = await _getArticleUseCase();

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(RemoteArticlesDone(dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(RemoteArticlesError(dataState.error!));
    }
  }
}
