import 'package:web/web.dart' as web;

class WebAudioPlayer {
  web.HTMLAudioElement? _audioElement;

  void playAudioUrl(String audioBase64) {
    // Dispose previous audio element if exists
    _audioElement?.pause();

    // Create and play audio element
    final abc = "data:audio/mp3;base64,$audioBase64";

    _audioElement =
        web.HTMLAudioElement()
          ..src = abc
          ..autoplay = true;

    // Append to document for some browsers that require it
    final node = web.document.body?.appendChild(_audioElement!);
    _audioElement = node as web.HTMLAudioElement?;
    _audioElement?.play();
  }

  void dispose() {
    if (_audioElement != null) {
      _audioElement!.pause();
      web.URL.revokeObjectURL(_audioElement!.src);
      _audioElement = null;
    }
  }
}
