import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/usecases/generate_article_summary.dart';

import 'article_summary_state.dart';

class ArticleSummaryCubit extends Cubit<ArticleSummaryState> {
  final GenerateArticleSummaryUseCase _generateArticleSummaryUseCase;

  ArticleSummaryCubit(this._generateArticleSummaryUseCase)
    : super(ArticleSummaryInitial());

  Future<void> generateSummary(String content) async {
    emit(ArticleSummaryLoading());

    final dataState = await _generateArticleSummaryUseCase(params: content);

    if (dataState is DataSuccess && dataState.data != null) {
      emit(ArticleSummarySuccess(dataState.data!));
    } else {
      emit(
        ArticleSummaryFailed(dataState.error?.message ?? "An error occurred"),
      );
    }
  }
}
