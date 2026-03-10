import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/core/usecase/usecase.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';

class GetArticleUseCase
    implements UseCase<DataState<List<ArticleEntity>>, bool?> {
  final ArticleRepository _articleRepository;

  GetArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<ArticleEntity>>> call({bool? params}) async {
    return _articleRepository.getFirebaseArticles(refresh: params ?? false);
  }
}
