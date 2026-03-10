import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/core/usecase/usecase.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';

class PublishArticleUseCase
    implements UseCase<DataState<void>, PublishArticleParams> {
  final ArticleRepository _articleRepository;

  PublishArticleUseCase(this._articleRepository);

  @override
  Future<DataState<void>> call({PublishArticleParams? params}) {
    return _articleRepository.publishArticle(
      params!.article,
      localImagePath: params.localImagePath,
    );
  }
}

class PublishArticleParams {
  final ArticleEntity article;
  final String? localImagePath;

  PublishArticleParams({required this.article, this.localImagePath});
}
