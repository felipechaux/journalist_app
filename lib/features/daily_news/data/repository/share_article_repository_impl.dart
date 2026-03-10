import 'package:share_plus/share_plus.dart';

import '../../domain/entities/article.dart';
import '../../domain/repository/share_article_repository.dart';

class ShareArticleRepositoryImpl implements ShareArticleRepository {
  @override
  Future<void> shareArticle(ArticleEntity article) async {
    final title = article.title ?? '';
    final description = article.description ?? '';
    final content = article.content ?? '';
    final url = article.url ?? '';

    final shareContent = [
      if (title.isNotEmpty) title,
      if (description.isNotEmpty) description,
      if (content.isNotEmpty) content,
      if (url.isNotEmpty) url,
    ].join('\n\n');

    if (shareContent.isNotEmpty) {
      await SharePlus.instance.share(
        ShareParams(
          text: shareContent,
          subject: title.isNotEmpty ? title : null,
        ),
      );
    }
  }
}
