import 'package:depremdudugu/constants/app_colors.dart';
import 'package:depremdudugu/constants/const_asset.dart';
import 'package:depremdudugu/constants/const_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:depremdudugu/extensions/app_lang.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static bool isPlaying = false;
  var audioPlayer = new AudioPlayer();
  int selectedVoiceIndex = 0;

  final imgActive = ConstAsset.whistlePng;
  final imgPassive = ConstAsset.whistleNoClickPng;

  CountdownTimerController? timerController;
  bool timerIsActive = false;
  int _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  Duration _initialtimer = const Duration();

  @override
  void initState() {
    super.initState();
    isPlaying = audioPlayer.state == PlayerState.playing;
  }

  @override
  void dispose() {
    timerController?.dispose();
    super.dispose();
  }

  void timerOnEnd() {
    timerController?.disposeTimer();
    _initialtimer = const Duration();
    timerIsActive = false;
    isPlaying = !timerIsActive;
    buttonClickEvent();
  }

  Future playLocal(localFileName) async {
    await audioPlayer.stop();

    if (isPlaying) {
      var assetPath = "audios/$localFileName";
      var assetSrc = AssetSource(assetPath);
      await audioPlayer.play(assetSrc);
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.resume();
    } else if (timerIsActive) {
      timerOnEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> voiceNames = ConstVoice.getAllNames(context);

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: playTimerModalButton(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            playButton(context),
            audioDropdown(voiceNames),
            descriptionTexts(context),
            Padding(padding: EdgeInsets.only(top: 50.0)),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors(context).appDefaultTextColor,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors(context).appDefaultBgColor),
      title: Text(context.translate.appName),
    );
  }

  ButtonTheme playButton(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.all(40.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ElevatedButton(
        style: getRaisedButtonStyle(playerIsStart: isPlaying),
        onPressed: buttonClickEvent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(isPlaying ? imgActive : imgPassive, width: 160),
            Text(
              context.translate.sos,
              style: TextStyle(color: Colors.white),
            ),
            Text(' ')
          ],
        ),
      ),
    );
  }

  Container audioDropdown(List<String> voiceNames) {
    return Container(
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
            isPlaying = false;
            playLocal(ConstVoice.getAll[selectedVoiceIndex])
                .then((value) => {(null)});
          });
        },
        style: TextStyle(
          color: AppColors(context).dropdownButtonBg,
          fontSize: 20,
        ),
      ),
    );
  }

  Text descriptionTexts(BuildContext context) {
    return Text(
      '\n\n' +
          context.translate.pressForHelp +
          '\n' +
          context.translate.pressForStop,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
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

  FloatingActionButton playTimerModalButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text(
        context.translate.setTimer,
        style: TextStyle(color: AppColors(context).white),
      ),
      icon: Icon(
        Icons.timer,
        color: AppColors(context).white,
      ),
      backgroundColor: AppColors(context).timerButtonBg,
      onPressed: () {
        timerShowDialog(context);
      },
    );
  }

  setTimerMinute() {
    if (_initialtimer.inMilliseconds > 0) {
      int minutes = _initialtimer.inMinutes;
      _endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * minutes;
      timerController =
          CountdownTimerController(endTime: _endTime, onEnd: timerOnEnd);
      timerIsActive = true;
    } else {
      timerIsActive = false;
    }
    isPlaying = !timerIsActive;
    buttonClickEvent();
  }

  void timerShowDialog(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: AppColors(context).timerBg,
      context: context,
      builder: (builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height /
              (timerIsActive ? 5 : 2),
          child: Column(
            children: [
              timerIsActive
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          counterTextWidget(),
                        ],
                      ),
                    )
                  : timerPickerWidget(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cancelButton(context),
                  okResetButton(context),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  CountdownTimer counterTextWidget() {
    return CountdownTimer(
      controller: timerController,
      onEnd: timerOnEnd,
      endTime: _endTime,
      textStyle: const TextStyle(fontSize: 28.0),
      endWidget: Text(context.translate.timerExpireText),
    );
  }

  CupertinoTimerPicker timerPickerWidget() {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 1,
      secondInterval: 1,
      initialTimerDuration: _initialtimer,
      onTimerDurationChanged: (Duration changedtimer) {
        setState(() {
          _initialtimer = changedtimer;
        });
      },
    );
  }

  TextButton okResetButton(BuildContext context) {
    if (timerIsActive) {
      return TextButton(
        child: Text(
          context.translate.reset,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          timerOnEnd();
        },
      );
    } else {
      return TextButton(
        child: Text(
          context.translate.ok,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          setTimerMinute();
        },
      );
    }
  }

  TextButton cancelButton(BuildContext context) {
    return TextButton(
      child: Text(
        context.translate.cancel,
        style: const TextStyle(fontSize: 18),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  void buttonClickEvent() {
    try {
      setState(() {
        isPlaying = !isPlaying;
        playLocal(ConstVoice.getAllPaths[selectedVoiceIndex])
            .then((value) => (null));
      });
    } catch (e) {
      isPlaying = false;
    }
  }
}
