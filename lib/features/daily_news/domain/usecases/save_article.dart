import 'package:journalist_app/core/usecase/usecase.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:journalist_app/features/daily_news/domain/params/save_article_params.dart';

class SaveArticleUseCase implements UseCase<void, SaveArticleParams> {
  final ArticleRepository _articleRepository;

  SaveArticleUseCase(this._articleRepository);

  @override
  Future<void> call({SaveArticleParams? params}) async {
    return _articleRepository.saveArticle(params!.article);
  }
}
