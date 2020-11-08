import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deprem Düdüğü',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Deprem Düdüğü'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isStart = false;
  AudioPlayer audioPlayer = new AudioPlayer();

  int selectedVoiceIndex = 0;
  final voiceNames = <String>[
    'Düdük sesi',
    'Kedi sesi',
    'Siren sesi',
    'Mors alfabesi yardım sesi'
  ];
  final voiceUrls = <String>[
    'referee-whistle.mp3',
    'cat-meow.mp3',
    'siren.mp3',
    'morse-sos.mp3'
  ];

  final imgActive = 'assets/img/whistle-01.png';
  final imgPassive = 'assets/img/whistle-01-noclick.png';

  void playVoice() {
    if (isStart) {
      playLocal(voiceUrls[selectedVoiceIndex]).then((value) => (null));
    } else {
      audioPlayer.stop();
    }
  }

  Future playLocal(localFileName) async {
    audioPlayer.stop();
    final dir = await getApplicationDocumentsDirectory();
    final file = new File("${dir.path}/$localFileName");
    if (!(await file.exists())) {
      final soundData = await rootBundle.load("assets/audios/$localFileName");
      final bytes = soundData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }
    await audioPlayer.play(file.path, isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              padding: EdgeInsets.all(40.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: RaisedButton(
                color: isStart ? Colors.grey : Colors.red,
                onPressed: () => setState(() {
                  isStart = !isStart;
                  playVoice();
                }),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(isStart ? imgActive : imgPassive, width: 160),
                    Text("S.O.S", style: TextStyle(color: Colors.white))
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
                    selectedVoiceIndex = voiceNames.indexOf(value);
                    isStart = false;
                    playVoice();
                  });
                },
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ),
            Text(
              '\n\nYardım için düdüğe basın.\nDurdurmak için tekrar basın.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Padding(padding: EdgeInsets.only(top: 50.0)),
            Text(
              "© 2020 Osman KOÇ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
