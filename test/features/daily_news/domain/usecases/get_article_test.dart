import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:journalist_app/features/daily_news/domain/usecases/get_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

void main() {
  late GetArticleUseCase usecase;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    usecase = GetArticleUseCase(mockArticleRepository);
    registerFallbackValue(FakeArticleEntity());
  });

  group('GetArticleUseCase', () {
    final tArticleParams = false;
    final tArticleList = [
      const ArticleEntity(
        id: 1,
        title: 'Test Title 1',
        content: 'Test Content 1',
      ),
      const ArticleEntity(
        id: 2,
        title: 'Test Title 2',
        content: 'Test Content 2',
      ),
    ];

    test('should get list of articles from the repository', () async {
      // arrange
      when(
        () => mockArticleRepository.getFirebaseArticles(
          refresh: any(named: 'refresh'),
        ),
      ).thenAnswer((_) async => DataSuccess(tArticleList));

      // act
      final result = await usecase(params: tArticleParams);

      // assert
      expect(result.data, tArticleList);
      verify(
        () =>
            mockArticleRepository.getFirebaseArticles(refresh: tArticleParams),
      ).called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    });
  });
}
