import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/core/usecase/usecase.dart';
import 'package:journalist_app/features/publish_article/domain/repository/publish_article_repository.dart';
import 'package:journalist_app/features/publish_article/domain/params/publish_article_params.dart';

class PublishArticleUseCase
    implements UseCase<DataState<void>, PublishArticleParams> {
  final PublishArticleRepository _publishArticleRepository;

  PublishArticleUseCase(this._publishArticleRepository);

  @override
  Future<DataState<void>> call({PublishArticleParams? params}) async {
    return _publishArticleRepository.publishArticle(
      params!.article,
      localImagePath: params.localImagePath,
    );
  }
}
