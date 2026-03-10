import 'package:journalist_app/features/daily_news/domain/entities/article.dart';

class PublishArticleParams {
  final ArticleEntity article;
  final String? localImagePath;

  PublishArticleParams({required this.article, this.localImagePath});
}
