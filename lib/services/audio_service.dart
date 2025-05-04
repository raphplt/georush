import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  bool get isMuted => _isMuted;
  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> playMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/soundtrack.mp3'));
    await _audioPlayer.setVolume(_isMuted ? 0 : 1);
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _audioPlayer.setVolume(_isMuted ? 0 : 1);
    notifyListeners();
  }

  void setMute(bool value) {
    _isMuted = value;
    _audioPlayer.setVolume(_isMuted ? 0 : 1);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
