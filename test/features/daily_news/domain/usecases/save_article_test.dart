import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/daily_news/domain/repository/article_repository.dart';
import 'package:journalist_app/features/daily_news/domain/usecases/save_article.dart';
import 'package:journalist_app/features/daily_news/domain/params/save_article_params.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

void main() {
  late SaveArticleUseCase usecase;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    usecase = SaveArticleUseCase(mockArticleRepository);
    registerFallbackValue(FakeArticleEntity());
  });

  group('SaveArticleUseCase', () {
    const tArticle = ArticleEntity(
      id: 1,
      title: 'Test Title',
      content: 'Test Content',
    );
    final tSaveArticleParams = SaveArticleParams(article: tArticle);

    test('should save the article to the repository successfully', () async {
      // arrange
      when(
        () => mockArticleRepository.saveArticle(any()),
      ).thenAnswer((_) async => Future.value());

      // act
      await usecase(params: tSaveArticleParams);

      // assert
      verify(() => mockArticleRepository.saveArticle(tArticle)).called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    });
  });
}
