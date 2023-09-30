import 'package:flutter/material.dart';
import 'package:janwar_x/constants/apppadding.dart';
import 'package:janwar_x/widgets/app_text.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerView extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerView({super.key, required this.videoUrl});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieContoller;
  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController.pause();
          });
    _chewieContoller = ChewieController(
        videoPlayerController: _videoPlayerController, aspectRatio: 16 / 9);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const AppText(
          text: "Visuals",
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: AppPadding.defaultPadding,
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(
                    height: 400,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Chewie(controller: _chewieContoller),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 111,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: const Center(
              child: Icon(
                Icons.play_circle_fill_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
          )
        ],
      ),
    );
  }
}
