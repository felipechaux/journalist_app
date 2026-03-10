import 'package:journalist_app/core/usecase/usecase.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:journalist_app/features/daily_news/domain/params/remove_article_params.dart';

class RemoveArticleUseCase implements UseCase<void, RemoveArticleParams> {
  final ArticleRepository _articleRepository;

  RemoveArticleUseCase(this._articleRepository);

  @override
  Future<void> call({RemoveArticleParams? params}) async {
    return _articleRepository.removeArticle(params!.article);
  }
}
