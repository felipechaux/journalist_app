import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:journalist_app/core/resources/data_state.dart';
import 'package:journalist_app/features/daily_news/domain/entities/article.dart';
import 'package:journalist_app/features/publish_article/domain/repository/publish_article_repository.dart';
import 'package:journalist_app/features/publish_article/domain/usecases/publish_article.dart';
import 'package:journalist_app/features/publish_article/domain/params/publish_article_params.dart';

class MockPublishArticleRepository extends Mock
    implements PublishArticleRepository {}

class FakeArticleEntity extends Fake implements ArticleEntity {}

void main() {
  late PublishArticleUseCase usecase;
  late MockPublishArticleRepository mockPublishArticleRepository;

  setUp(() {
    mockPublishArticleRepository = MockPublishArticleRepository();
    usecase = PublishArticleUseCase(mockPublishArticleRepository);
    registerFallbackValue(FakeArticleEntity());
  });

  group('PublishArticleUseCase', () {
    const tArticle = ArticleEntity(
      id: 1,
      title: 'Test Publish Title',
      content: 'Test Publish Content',
    );
    const tLocalImagePath = '/path/to/image.png';
    final tPublishArticleParamsWithImage = PublishArticleParams(
      article: tArticle,
      localImagePath: tLocalImagePath,
    );
    final tPublishArticleParamsWithoutImage = PublishArticleParams(
      article: tArticle,
    );

    test(
      'should publish the article to the repository successfully with image',
      () async {
        // arrange
        when(
          () => mockPublishArticleRepository.publishArticle(
            any(),
            localImagePath: any(named: 'localImagePath'),
          ),
        ).thenAnswer((_) async => const DataSuccess(null));

        // act
        final result = await usecase(params: tPublishArticleParamsWithImage);

        // assert
        expect(result, isA<DataSuccess<void>>());
        verify(
          () => mockPublishArticleRepository.publishArticle(
            tArticle,
            localImagePath: tLocalImagePath,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockPublishArticleRepository);
      },
    );

    test(
      'should publish the article to the repository successfully without image',
      () async {
        // arrange
        when(
          () => mockPublishArticleRepository.publishArticle(
            any(),
            localImagePath: any(named: 'localImagePath'),
          ),
        ).thenAnswer((_) async => const DataSuccess(null));

        // act
        final result = await usecase(params: tPublishArticleParamsWithoutImage);

        // assert
        expect(result, isA<DataSuccess<void>>());
        verify(
          () => mockPublishArticleRepository.publishArticle(
            tArticle,
            localImagePath: null,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockPublishArticleRepository);
      },
    );
  });
}
