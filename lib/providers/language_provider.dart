import 'dart:io';
import 'package:avenue/constants/constants.dart';
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class LanguageProvider with ChangeNotifier {
  Locale? _locale;
  Locale get locale => _locale ?? Locale('en');

  LanguageProvider() {
    getLocale();
  }

  Future<void> getLocale() async {
    try {
      String? localeName = await LocalStorageService.read(keyLocale);
      if (localeName == null) {
        String deviceLocale = Platform.localeName.split('_')[0];
        localeName = deviceLocale != 'vi' ? 'en' : 'vi';
        await LocalStorageService.save(keyLocale, localeName);
      }
      _locale = Locale(localeName);
      notifyListeners();
    } catch (_) {}
  }

  void saveLocale(Locale locale) async {
    if (locale.languageCode == _locale?.languageCode) {
      return;
    }
    _locale = locale;
    notifyListeners();
    await LocalStorageService.save(keyLocale, _locale!.languageCode);
  }
}
