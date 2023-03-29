import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  VideoPlayer({this.videoUrl}) : assert(videoUrl != null);
  @override
  _VideoPlayerState createState() => _VideoPlayerState(this.videoUrl);
}

class _VideoPlayerState extends State<VideoPlayer> {
  SharedPreferences sharedPreferences;
  final String videoUrl;
  _VideoPlayerState(this.videoUrl);
  CachedVideoPlayerController controller;
  bool volume;
  @override
  void initState() {
    loadValues();

    super.initState();
  }

  loadValues() async {
    sharedPreferences = await SharedPreferences.getInstance();
    volume = sharedPreferences.getBool("volume");
    controller = CachedVideoPlayerController.network(
      videoUrl,
    );
    controller.initialize().then((_) {
      setState(() {});
      controller.play();
      // controller.setLooping(true);
      controller.setVolume(sharedPreferences.getBool("volume") ? 100 : 0);
      // if (mounted) setState(() {});
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return volume == null
        ? Container()
        : controller.value != null && controller.value.isInitialized
            ? AspectRatio(
                child: Stack(children: [
                  CachedVideoPlayer(controller),
                  Positioned(
                      right: 3,
                      bottom: 3,
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              volume
                                  ? sharedPreferences.setBool("volume", false)
                                  : sharedPreferences.setBool("volume", true);
                              volume = !volume;
                              print(volume);
                              if (volume) {
                                controller.setVolume(100.0);
                              } else {
                                controller.setVolume(0.0);
                              }
                            });
                          },
                          child: Icon(
                            volume ? Icons.volume_up : Icons.volume_off,
                            color: Colors.black,
                            size: 40,
                          )))
                ]),
                aspectRatio: controller.value.aspectRatio,
              )
            : Center(child: SpinKitCircle(itemBuilder: (_, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.black : Colors.white,
                  ),
                );
              }));
  }
}
