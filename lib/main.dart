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
  // void _incrementCounter() {
  //   setState(() {});
  // }

  bool isStart = false;
  var assetsAudioPlayer = AssetsAudioPlayer();

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
              height: 250,
              minWidth: 250,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: RaisedButton(
                color: isStart ? Colors.grey : Colors.red,
                onPressed: () => setState(() {
                  isStart = !isStart;
                  if (isStart) {
                    assetsAudioPlayer.open(
                      Audio("assets/audios/referee-whistle.mp3"),
                      autoStart: true,
                      showNotification: false,
                      loopMode: LoopMode.single,
                    );
                  } else {
                    assetsAudioPlayer.stop();
                  }
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
            Text(
              '\n\nYardım için düdüğe basın.\nDurdurmak için tekrar basın.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
