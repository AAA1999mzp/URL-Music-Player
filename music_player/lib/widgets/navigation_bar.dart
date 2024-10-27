import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/player_view.dart';
import '../views/add_track_view.dart';

class NavigationBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.music_note),
          label: 'Player',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Track',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Get.to(() => PlayerView());
        } else if (index == 1) {
          Get.to(() => AddTrackView());
        }
      },
    );
  }
}
