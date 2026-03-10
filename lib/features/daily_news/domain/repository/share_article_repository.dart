import 'package:journalist_app/features/daily_news/domain/entities/article.dart';

abstract class ShareArticleRepository {
  Future<void> shareArticle(ArticleEntity article);
}
