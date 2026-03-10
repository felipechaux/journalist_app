// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get savedArticlesTitle => 'Saved Articles';

  @override
  String get noSavedArticles => 'NO SAVED ARTICLES';

  @override
  String get articleNotFound => 'Article not found.';

  @override
  String get articleSavedSuccess => 'Article saved successfully!';

  @override
  String get offlineMessage => 'You are offline. Some features may be limited.';

  @override
  String get onlineMessage => 'Back online! Syncing latest news...';

  @override
  String get dailyNewsTitle => 'JOURNALIST APP';

  @override
  String get publishArticleFab => 'Publish';

  @override
  String get publishArticleTitle => 'Publish Article';

  @override
  String get articlePublishedSuccess => 'Article published successfully!';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get titleLabel => 'Title';

  @override
  String get contentLabel => 'Content';

  @override
  String get descriptionLabel => 'Short description (optional)';

  @override
  String get publishButton => 'Publish Article';

  @override
  String get titleAndContentRequired => 'Title and content are required';

  @override
  String get saveCta => 'Save';

  @override
  String get removeCta => 'Remove';

  @override
  String get shareCta => 'Share';

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get draftTitle => 'Draft';

  @override
  String get addCoverImage => 'Add Cover Image (Optional)';

  @override
  String get tapToChange => 'Tap to change';

  @override
  String get articleTitleHint => 'Article Title';

  @override
  String get writeStoryHint => 'Write your story here...';

  @override
  String charactersCount(int count) {
    return '$count characters';
  }
}
