import 'package:equatable/equatable.dart';

abstract class PublishArticleState extends Equatable {
  const PublishArticleState();

  @override
  List<Object> get props => [];
}

class PublishArticleInitial extends PublishArticleState {}

class PublishArticleLoading extends PublishArticleState {}

class PublishArticleSuccess extends PublishArticleState {}

class PublishArticleFailure extends PublishArticleState {
  final String error;

  const PublishArticleFailure({required this.error});

  @override
  List<Object> get props => [error];
}
