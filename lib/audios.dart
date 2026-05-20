import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioPlayer _player = AudioPlayer();
  static bool _sonidoActivado = true;

  static void setEstado(bool activado) {
    _sonidoActivado = activado;
    if (!_sonidoActivado) {
      _player.stop();
    }
  }

  static Future<void> playAsset(String assetPath) async {
    if (!_sonidoActivado) return;
    await _player.play(AssetSource(assetPath));
  }
}
