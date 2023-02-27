import 'dart:io';

import 'package:depremdudugu/constants/const_asset.dart';
import 'package:depremdudugu/constants/const_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whistle',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('tr', 'TR'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (locale != null &&
              supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static bool isStart = false;
  var audioPlayer = new AudioPlayer();

  int selectedVoiceIndex = 0;

  final imgActive = ConstAsset.whistlePng;
  final imgPassive = ConstAsset.whistleNoClickPng;

  @override
  void initState() {
    super.initState();
    isStart = audioPlayer.state == PlayerState.playing;
  }

  Future playLocal(localFileName) async {
    await audioPlayer.stop();

    if (isStart) {
      final dir = await getApplicationDocumentsDirectory();
      final file = new File("${dir.path}/$localFileName");
      if (!(await file.exists())) {
        final soundData = await rootBundle.load("assets/audios/$localFileName");
        final bytes = soundData.buffer.asUint8List();
        await file.writeAsBytes(bytes, flush: true);
      }
      await audioPlayer.setSourceUrl(file.path);
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.resume();
    }
  }

  static ButtonStyle getRaisedButtonStyle({required bool playerIsStart}) {
    return ElevatedButton.styleFrom(
      //foregroundColor: playerIsStart ? Colors.grey : Colors.red,
      backgroundColor: playerIsStart ? Colors.grey : Colors.red,
      //backgroundColor: Colors.grey[300],
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(64)),
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    List<String> voiceNames = <String>[
      AppLocalizations.of(context).translate(key: 'audio_whistle'),
      AppLocalizations.of(context).translate(key: 'audio_cat'),
      AppLocalizations.of(context).translate(key: 'audio_siren'),
      AppLocalizations.of(context).translate(key: 'audio_hammer'),
      AppLocalizations.of(context).translate(key: 'audio_morse')
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(key: 'appName')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              padding: EdgeInsets.all(40.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: ElevatedButton(
                //color: isStart ? Colors.grey : Colors.red,
                style: getRaisedButtonStyle(playerIsStart: isStart),
                onPressed: () => setState(() {
                  isStart = !isStart;
                  playLocal(ConstVoice.getAll[selectedVoiceIndex])
                      .then((value) => (null));
                }),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(isStart ? imgActive : imgPassive, width: 160),
                    Text(
                      AppLocalizations.of(context).translate(key: 'sos'),
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(' ')
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              child: DropdownButton<String>(
                value: voiceNames[selectedVoiceIndex],
                items: voiceNames.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVoiceIndex = voiceNames.indexOf(value!);
                    isStart = false;
                    playLocal(ConstVoice.getAll[selectedVoiceIndex])
                        .then((value) => (null));
                  });
                },
                style: TextStyle(
                  color: isDarkMode(context) ? Colors.white : Colors.black87,
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              '\n\n' +
                  AppLocalizations.of(context).translate(key: 'pressForHelp') +
                  '\n' +
                  AppLocalizations.of(context).translate(key: 'pressForStop'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Padding(padding: EdgeInsets.only(top: 50.0)),
            Text(
              AppLocalizations.of(context).translate(key: 'copyright'),
              textAlign: TextAlign.center,
              style: TextStyle(
                //color: Colors.black87,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
