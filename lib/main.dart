import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

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
  var assetsAudioPlayer = AssetsAudioPlayer();

  int selectedVoiceIndex = 0;
  var voiceNames = <String>[
    'Düdük sesi',
    'Kedi sesi',
    'Siren sesi',
    'Mors alfabesi yardım sesi'
  ];
  var voiceUrls = <String>[
    'assets/audios/referee-whistle.mp3',
    'assets/audios/cat-meow.mp3',
    'assets/audios/siren.mp3',
    'assets/audios/morse-sos.mp3'
  ];

  void playVoice() {
    if (isStart) {
      assetsAudioPlayer.open(
        Audio(voiceUrls[selectedVoiceIndex]),
        autoStart: true,
        showNotification: false,
        loopMode: LoopMode.single,
      );
    } else {
      assetsAudioPlayer.stop();
    }
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
            //Padding(padding: EdgeInsets.only(top: 10.0)),
            ButtonTheme(
              padding: EdgeInsets.all(50.0),
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
                    Image.asset(
                        isStart
                            ? 'assets/img/whistle-01.png'
                            : 'assets/img/whistle-01-noclick.png',
                        width: 160),
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
