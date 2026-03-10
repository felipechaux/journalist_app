import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void setLocale(Locale locale) {
    if (!['en', 'es'].contains(locale.languageCode)) return;
    emit(locale);
  }

  void toggleLanguage() {
    if (state.languageCode == 'en') {
      emit(const Locale('es'));
    } else {
      emit(const Locale('en'));
    }
  }
}
