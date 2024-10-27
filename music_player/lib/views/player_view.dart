import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_player_controller.dart';
import '../widgets/navigation_bar.dart';

class PlayerView extends StatelessWidget {
  final AudioPlayerController controller = Get.put(AudioPlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              final currentTrackName = controller.playlistNames.isNotEmpty &&
                      controller.currentIndex.value < controller.playlistNames.length
                  ? controller.playlistNames[controller.currentIndex.value]
                  : 'No Track Playing';
              final currentTrackArtist = controller.playlistArtists.isNotEmpty &&
                      controller.currentIndex.value < controller.playlistArtists.length
                  ? controller.playlistArtists[controller.currentIndex.value]
                  : '';
              return Column(
                children: [
                  Text(
                    'Playing: $currentTrackName',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Artist: $currentTrackArtist',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                  Slider(
                    value: controller.currentPosition.value.inSeconds.toDouble(),
                    max: controller.totalDuration.value.inSeconds.toDouble(),
                    onChanged: (value) {
                      controller.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Obx(() {
                    return Text(
                      '${controller.currentPosition.value.inMinutes}:${(controller.currentPosition.value.inSeconds % 60).toString().padLeft(2, '0')} / ${controller.totalDuration.value.inMinutes}:${(controller.totalDuration.value.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 16),
                    );
                  }),
                ],
              );
            }),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: () => controller.previous(),
                ),
                Obx(() {
                  return IconButton(
                    icon: Icon(
                      controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () => controller.isPlaying.value
                        ? controller.pause()
                        : controller.play(),
                  );
                }),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () => controller.next(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(() {
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.playlist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.playlistNames[index]),
                      subtitle: Text(controller.playlistArtists[index]),
                      onTap: () => controller.playTrackFromUrl(controller.playlist[index]),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
