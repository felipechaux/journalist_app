import 'package:equatable/equatable.dart';

abstract class ArticleSummaryState extends Equatable {
  const ArticleSummaryState();

  @override
  List<Object?> get props => [];
}

class ArticleSummaryInitial extends ArticleSummaryState {}

class ArticleSummaryLoading extends ArticleSummaryState {}

class ArticleSummarySuccess extends ArticleSummaryState {
  final String summary;

  const ArticleSummarySuccess(this.summary);

  @override
  List<Object?> get props => [summary];
}

class ArticleSummaryFailed extends ArticleSummaryState {
  final String error;

  const ArticleSummaryFailed(this.error);

  @override
  List<Object?> get props => [error];
}
