import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_player_controller.dart';
import '../widgets/navigation_bar.dart';

class AddTrackView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final AudioPlayerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Track'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Track Name'),
            ),
            TextField(
              controller: artistController,
              decoration: InputDecoration(labelText: 'Artist'),
            ),
            TextField(
              controller: urlController,
              decoration: InputDecoration(labelText: 'Track URL'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && artistController.text.isNotEmpty && urlController.text.isNotEmpty) {
                  controller.addTrackWithNameAndArtist(nameController.text, artistController.text, urlController.text);
                  Get.back();
                }
              },
              child: Text('Add Track'),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.playlist.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(controller.playlistNames[index]),
                      subtitle: Text(controller.playlistArtists[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          nameController.text = controller.playlistNames[index];
                          artistController.text = controller.playlistArtists[index];
                          urlController.text = controller.playlist[index];
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Edit Track'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(labelText: 'Track Name'),
                                  ),
                                  TextField(
                                    controller: artistController,
                                    decoration: InputDecoration(labelText: 'Artist'),
                                  ),
                                  TextField(
                                    controller: urlController,
                                    decoration: InputDecoration(labelText: 'Track URL'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    controller.updateTrack(index, nameController.text, artistController.text, urlController.text);
                                    Get.back();
                                  },
                                  child: Text('Update'),
                                ),
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text('Cancel'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onTap: () => controller.playTrackFromUrl(controller.playlist[index]),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
