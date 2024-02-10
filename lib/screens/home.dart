import 'package:depremdudugu/constants/app_colors.dart';
import 'package:depremdudugu/constants/const_asset.dart';
import 'package:depremdudugu/constants/const_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:depremdudugu/extensions/app_lang.dart';
import 'package:depremdudugu/screens/about_popup.dart';
import 'package:flutter/material.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      var assetPath = "audios/$localFileName";
      var assetSrc = AssetSource(assetPath);
      await audioPlayer.play(assetSrc);
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.resume();
    }
  }

  static ButtonStyle getRaisedButtonStyle({required bool playerIsStart}) {
    return ElevatedButton.styleFrom(
      backgroundColor: playerIsStart ? Colors.grey : Colors.red,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate.appName),
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
                      context.translate.sos,
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
                value: context.translate.audioNames()[selectedVoiceIndex],
                items: context.translate
                    .audioNames()
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVoiceIndex =
                        context.translate.audioNames().indexOf(value!);
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
                  context.translate.pressForHelp +
                  '\n' +
                  context.translate.pressForStop,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Padding(padding: EdgeInsets.only(top: 50.0)),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.menu_outlined),
        closedBackgroundColor: AppColors(context).floatButtonBg,
        closedForegroundColor: AppColors(context).floatButtonText,
        openBackgroundColor: AppColors(context).floatButtonBg,
        openForegroundColor: AppColors(context).floatButtonText,
        labelsBackgroundColor: AppColors(context).floatButtonBg,
        labelsStyle: TextStyle(color: AppColors(context).floatButtonText),
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: Icon(Icons.info_outline),
            backgroundColor: AppColors(context).floatButtonBg,
            foregroundColor: AppColors(context).floatButtonText,
            label: context.translate.about,
            onPressed: () {
              setState(() {
                _showAboutDialog(context);
              });
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AboutScreenPopup();
      },
    );
  }
}
