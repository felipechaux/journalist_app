import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @savedArticlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Articles'**
  String get savedArticlesTitle;

  /// No description provided for @noSavedArticles.
  ///
  /// In en, this message translates to:
  /// **'NO SAVED ARTICLES'**
  String get noSavedArticles;

  /// No description provided for @articleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Article not found.'**
  String get articleNotFound;

  /// No description provided for @articleSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Article saved successfully!'**
  String get articleSavedSuccess;

  /// No description provided for @offlineMessage.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Some features may be limited.'**
  String get offlineMessage;

  /// No description provided for @onlineMessage.
  ///
  /// In en, this message translates to:
  /// **'Back online! Syncing latest news...'**
  String get onlineMessage;

  /// No description provided for @dailyNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'JOURNALIST APP'**
  String get dailyNewsTitle;

  /// No description provided for @publishArticleFab.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publishArticleFab;

  /// No description provided for @publishArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish Article'**
  String get publishArticleTitle;

  /// No description provided for @articlePublishedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Article published successfully!'**
  String get articlePublishedSuccess;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(String error);

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @contentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Short description (optional)'**
  String get descriptionLabel;

  /// No description provided for @publishButton.
  ///
  /// In en, this message translates to:
  /// **'Publish Article'**
  String get publishButton;

  /// No description provided for @titleAndContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Title and content are required'**
  String get titleAndContentRequired;

  /// No description provided for @saveCta.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveCta;

  /// No description provided for @removeCta.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeCta;

  /// No description provided for @shareCta.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareCta;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @draftTitle.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draftTitle;

  /// No description provided for @addCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Add Cover Image (Optional)'**
  String get addCoverImage;

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get tapToChange;

  /// No description provided for @articleTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Article Title'**
  String get articleTitleHint;

  /// No description provided for @writeStoryHint.
  ///
  /// In en, this message translates to:
  /// **'Write your story here...'**
  String get writeStoryHint;

  /// No description provided for @charactersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} characters'**
  String charactersCount(int count);

  /// No description provided for @generateAiSummary.
  ///
  /// In en, this message translates to:
  /// **'Generate AI Summary'**
  String get generateAiSummary;

  /// No description provided for @aiSummaryError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t generate a summary right now. Please check your connection or try again later.'**
  String get aiSummaryError;

  /// No description provided for @aiSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get aiSummaryTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
