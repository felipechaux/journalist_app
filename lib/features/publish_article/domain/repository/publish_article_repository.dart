import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';

abstract class PublishArticleRepository {
  Future<DataState<void>> publishArticle(
    ArticleEntity article, {
    String? localImagePath,
  });
}
