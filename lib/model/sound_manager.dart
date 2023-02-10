import 'package:just_audio/just_audio.dart';

class SoundManager {
  final bgmPlayer = AudioPlayer();
  final bellPlayer = AudioPlayer();
  final soundGongPlayer = AudioPlayer();

  double volume = 0.2;

  prepareSounds(bool isBgm, String bellPath, String? bgmPath) async{
    await bgmPlayer.setAsset(bgmPath!);
    await bgmPlayer.setLoopMode(LoopMode.one);
    await bgmPlayer.setVolume(volume);

    await bellPlayer.setAsset(bellPath);
    await bellPlayer.setLoopMode(LoopMode.one);
    await bellPlayer.setVolume(volume);
  }

  playSounds(bool isBgm, String bellPath, String? bgmPath) async{
    await bellPlayer.setVolume(volume);
    bellPlayer..seek(Duration.zero)..play();
    bgmPlayer..seek(Duration.zero)..play();
  }

  void stopBgm(bool isBgm, int themeId) {
    bellPlayer.stop();
    if(isBgm) bgmPlayer.stop();
  }

  void ringFinalGong() async{
    await soundGongPlayer.setAsset("assets/sounds/gong_sound.mp3");
    await soundGongPlayer.setVolume(volume);
    soundGongPlayer.play();
  }

  void changeVolume(double newVolume) {
    volume = newVolume / 20;
    bellPlayer.setVolume(volume);
    soundGongPlayer.setVolume(volume);
  }

  void dispose() {
    bgmPlayer.dispose();
    bellPlayer.dispose();
    soundGongPlayer.dispose();
  }

}