import 'package:journalist_app/core/usecase/usecase.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import '../repository/share_article_repository.dart';

class ShareArticleUseCase implements UseCase<void, ArticleEntity> {
  final ShareArticleRepository _shareArticleRepository;

  ShareArticleUseCase(this._shareArticleRepository);

  @override
  Future<void> call({ArticleEntity? params}) async {
    return _shareArticleRepository.shareArticle(params!);
  }
}
