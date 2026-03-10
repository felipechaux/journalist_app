import 'package:equatable/equatable.dart';

abstract class PublishArticleEvent extends Equatable {
  const PublishArticleEvent();

  @override
  List<Object?> get props => [];
}

class PublishArticleSubmitted extends PublishArticleEvent {
  final String title;
  final String content;
  final String? imagePath;

  const PublishArticleSubmitted({
    required this.title,
    required this.content,
    this.imagePath,
  });

  @override
  List<Object?> get props => [title, content, imagePath];
}
