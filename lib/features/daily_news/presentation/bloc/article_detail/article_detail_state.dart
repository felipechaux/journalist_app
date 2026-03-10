import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class ArticleDetailState extends Equatable {
  final ArticleEntity? article;

  const ArticleDetailState({this.article});

  @override
  List<Object?> get props => [article];
}

class ArticleDetailInitial extends ArticleDetailState {
  const ArticleDetailInitial(ArticleEntity article) : super(article: article);
}

class ArticleDetailLoading extends ArticleDetailState {
  const ArticleDetailLoading(ArticleEntity article) : super(article: article);
}

class ArticleDetailLoaded extends ArticleDetailState {
  const ArticleDetailLoaded(ArticleEntity article) : super(article: article);
}

class ArticleDetailError extends ArticleDetailState {
  final String message;
  const ArticleDetailError(ArticleEntity article, this.message)
    : super(article: article);

  @override
  List<Object?> get props => [article, message];
}
