import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerController extends GetxController {
  final player = AudioPlayer();
  var isPlaying = false.obs;
  var currentIndex = 0.obs;
  var currentPosition = Duration.zero.obs;
  var totalDuration = Duration.zero.obs;

  // List of audio URLs and names
  final List<String> playlist = <String>[].obs;
  final List<String> playlistNames = <String>[].obs;
  final List<String> trackDurations = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    player.currentIndexStream.listen((index) {
      if (index != null && index < playlist.length) currentIndex.value = index;
    });
    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
    player.positionStream.listen((position) {
      currentPosition.value = position;
    });
    player.durationStream.listen((duration) {
      if (duration != null) totalDuration.value = duration;
    });
  }

  void addTrackWithName(String name, String url) async {
    playlist.add(url);
    playlistNames.add(name);

    try {
      Duration? duration = await player.setUrl(url);
      String durationString = duration != null
          ? "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}"
          : "Unknown";
      trackDurations.add(durationString);
    } catch (e) {
      trackDurations.add("Error");
      print("Error loading track duration: $e");
    }

    setPlaylist();
  }

  void updateTrack(int index, String name, String url) async {
    if (index < playlist.length) {
      playlist[index] = url;
      playlistNames[index] = name;

      try {
        Duration? duration = await player.setUrl(url);
        String durationString = duration != null
            ? "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}"
            : "Unknown";
        trackDurations[index] = durationString;
      } catch (e) {
        trackDurations[index] = "Error";
        print("Error loading track duration: $e");
      }

      setPlaylist();
    }
  }

  Future<void> setPlaylist() async {
    try {
      await player.setAudioSource(
        ConcatenatingAudioSource(
          children: playlist.map((url) => AudioSource.uri(Uri.parse(url))).toList(),
        ),
      );
    } catch (e) {
      print("Error setting playlist: $e");
    }
  }

  void play() {
    player.play();
  }

  void pause() {
    player.pause();
  }

  void seek(Duration position) {
    player.seek(position);
  }

  void next() {
    player.seekToNext();
  }

  void previous() {
    player.seekToPrevious();
  }

  void playTrackFromUrl(String url) async {
    try {
      await player.setUrl(url);
      player.play();
    } catch (e) {
      print("Error playing track: $e");
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
