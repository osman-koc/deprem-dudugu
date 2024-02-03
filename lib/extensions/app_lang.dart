import 'package:flutter/material.dart';
import 'package:depremdudugu/util/localization.dart';

class AppLangTranslations {
  final AppLocalizations _appLocalizations;

  AppLangTranslations(this._appLocalizations);

  List<String> audioNames() => [
        this.audioWhistle,
        this.audioCat,
        this.audioSiren,
        this.audioHammer,
        this.audioMorse,
      ];

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
}

extension AppLangContextExtension on BuildContext {
  AppLangTranslations get translate =>
      AppLangTranslations(AppLocalizations.of(this));
}
