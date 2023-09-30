import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:janwar_x/widgets/app_text.dart';
import 'package:video_player/video_player.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String documentId;
  final String videoUrl;

  ItemDetailsScreen({
    required this.documentId,
    required this.videoUrl,
  });

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late Future<DocumentSnapshot> _itemSnapshot;
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // Fetch item data from Firestore
    _itemSnapshot = FirebaseFirestore.instance
        .collection('addpro')
        .doc(widget.documentId)
        .get();

    // Initialize video controller
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: _itemSnapshot,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Item not found'));
            }

            final itemData = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 1.5, // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: itemData['imageUrl'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_videoController.value.isInitialized) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return VideoPlayerScreen(
                                    videoController: _videoController,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        child: Text("View Video"),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: itemData['name'],
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: 'Price: RS ${itemData['price']}',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      AppText(
                        text: 'Description:',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      AppText(
                        text: itemData['description'],
                        fontSize: 16.0,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 100.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: 'Age',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  AppText(
                                    text: itemData['age'],
                                    fontSize: 16.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              height: 100.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: 'Weight',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  AppText(
                                    text: itemData['weight'],
                                    fontSize: 16.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              height: 100.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: 'Quantity',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  AppText(
                                    text: itemData['quantity'].toString(),
                                    fontSize: 16.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerController videoController;

  VideoPlayerScreen({required this.videoController});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: widget.videoController.value.isInitialized
            ? AspectRatio(
          aspectRatio: widget.videoController.value.aspectRatio,
          child: VideoPlayer(widget.videoController),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.videoController.value.isInitialized) {
            if (widget.videoController.value.isPlaying) {
              widget.videoController.pause();
            } else {
              widget.videoController.play();
            }
            setState(() {});
          }
        },
        child: Icon(
          widget.videoController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoController.dispose();
  }
}
