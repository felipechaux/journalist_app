// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get savedArticlesTitle => 'Artículos Guardados';

  @override
  String get noSavedArticles => 'NO HAY ARTÍCULOS GUARDADOS';

  @override
  String get articleNotFound => 'Artículo no encontrado.';

  @override
  String get articleSavedSuccess => '¡Artículo guardado con éxito!';

  @override
  String get offlineMessage =>
      'Estás desconectado. Algunas funciones pueden estar limitadas.';

  @override
  String get onlineMessage =>
      '¡Conexión recuperada! Sincronizando nuevas noticias...';

  @override
  String get dailyNewsTitle => 'JOURNALIST APP';

  @override
  String get publishArticleFab => 'Publicar';

  @override
  String get publishArticleTitle => 'Publicar Artículo';

  @override
  String get articlePublishedSuccess => '¡Artículo publicado con éxito!';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get titleLabel => 'Título';

  @override
  String get contentLabel => 'Contenido';

  @override
  String get descriptionLabel => 'Breve descripción (opcional)';

  @override
  String get publishButton => 'Publicar Artículo';

  @override
  String get titleAndContentRequired =>
      'El título y el contenido son obligatorios';

  @override
  String get saveCta => 'Guardar';

  @override
  String get removeCta => 'Eliminar';

  @override
  String get shareCta => 'Compartir';

  @override
  String get openInBrowser => 'Abrir en el Navegador';

  @override
  String get changeLanguage => 'Cambiar Idioma';

  @override
  String get draftTitle => 'Borrador';

  @override
  String get addCoverImage => 'Añadir Imagen de Portada (Opcional)';

  @override
  String get tapToChange => 'Toca para cambiar';

  @override
  String get articleTitleHint => 'Título del Artículo';

  @override
  String get writeStoryHint => 'Escribe tu historia aquí...';

  @override
  String charactersCount(int count) {
    return '$count caracteres';
  }

  @override
  String get generateAiSummary => 'Generar Resumen de IA';

  @override
  String get aiSummaryError =>
      'No pudimos generar un resumen en este momento. Por favor, verifica tu conexión o inténtalo más tarde.';

  @override
  String get aiSummaryTitle => 'Resumen de IA';
}
