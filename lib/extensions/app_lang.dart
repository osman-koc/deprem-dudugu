import 'package:flutter/material.dart';
import 'package:depremdudugu/util/localization.dart';

class AppLangTranslations {
  final AppLocalizations _appLocalizations;

  AppLangTranslations(this._appLocalizations);

  String get appName => _appLocalizations.translate(key: 'app_name');
  String get appDeveloper => _appLocalizations.translate(key: 'app_developer');
  String get appWebsite => _appLocalizations.translate(key: 'app_website');
  String get appMail => _appLocalizations.translate(key: 'app_email');
  String get about => _appLocalizations.translate(key: 'about');
  String get aboutAppTitle =>
      _appLocalizations.translate(key: 'about_app_title');
  String get developedBy => _appLocalizations.translate(key: 'developedby');
  String get contact => _appLocalizations.translate(key: 'contact');
  String get close => _appLocalizations.translate(key: 'close');
  String get audioWhistle => _appLocalizations.translate(key: 'audio_whistle');
  String get audioCat => _appLocalizations.translate(key: 'audio_cat');
  String get audioSiren => _appLocalizations.translate(key: 'audio_siren');
  String get audioHammer => _appLocalizations.translate(key: 'audio_hammer');
  String get audioMorse => _appLocalizations.translate(key: 'audio_morse');
  String get pressForHelp => _appLocalizations.translate(key: 'press_for_help');
  String get pressForStop => _appLocalizations.translate(key: 'press_for_stop');
  String get sos => _appLocalizations.translate(key: 'sos');

  String get setTimer => _appLocalizations.translate(key: 'set_timer');
  String get reset => _appLocalizations.translate(key: 'reset');
  String get ok => _appLocalizations.translate(key: 'ok');
  String get cancel => _appLocalizations.translate(key: 'cancel');
  String get buttonTextStop =>
      _appLocalizations.translate(key: 'buttonTextStop');
  String get buttonTextPlay =>
      _appLocalizations.translate(key: 'buttonTextPlay');
  String get timerExpireText =>
      _appLocalizations.translate(key: 'timer_expire_text');
}

extension AppLangContextExtension on BuildContext {
  AppLangTranslations get translate =>
      AppLangTranslations(AppLocalizations.of(this));
}
