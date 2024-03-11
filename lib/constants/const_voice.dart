import 'package:depremdudugu/extensions/app_lang.dart';
import 'package:flutter/material.dart';

class ConstVoice {
  static const String whistleMp3 = 'referee-whistle.mp3';
  static const String catMp3 = 'cat-meow.mp3';
  static const String sirenMp3 = 'siren.mp3';
  static const String morseMp3 = 'morse-sos.mp3';
  static const String hammerMp3 = 'hammer.mp3';

  static const List<String> getAllPaths = <String>[
    'referee-whistle.mp3',
    'cat-meow.mp3',
    'siren.mp3',
    'hammer.mp3',
    'morse-sos.mp3'
  ];

  static List<String> getAllNames(BuildContext context){
    return <String>[
        context.translate.audioWhistle,
        context.translate.audioCat,
        context.translate.audioSiren,
        context.translate.audioHammer,
        context.translate.audioMorse,
    ];
  }

  static const List<String> getAll = <String>[
    whistleMp3,
    catMp3,
    sirenMp3,
    hammerMp3,
    morseMp3
  ];
}
