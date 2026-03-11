import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/core/usecase/usecase.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';

class GenerateArticleSummaryUseCase
    implements UseCase<DataState<String>, String> {
  final ArticleRepository _articleRepository;

  GenerateArticleSummaryUseCase(this._articleRepository);

  @override
  Future<DataState<String>> call({String? params}) {
    return _articleRepository.generateArticleSummary(params!);
  }
}
