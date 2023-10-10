import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:janwar_x/widgets/app_text.dart';

import 'chat.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String description;
  final String imageUrl;
  final String phone;
  final String age;
  final double price;
  final int quantity;
  final String title;
  final String videoUrl;
  final String weight;

  ItemDetailsScreen({
    required this.imageUrl,
    required this.description,
    required this.phone,
    required this.price,
    required this.quantity,
    required this.title,
    required this.videoUrl,
    required this.weight,
    required this.age,
  });

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBEEDB), // Background color of the entire screen


      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 35,),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image or Video
            Stack(
              children: [
                ClipRRect(
                  // Rounded corners for the image
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1 / 2.7, // Adjusted height

                      child  : CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      width: MediaQuery.of(context).size.width * 1, // Adjust the percentage as needed
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),

                  ),
                ),
              ],
            ),
            // Age, Weight, and Quantity
            Container(
              width: MediaQuery.of(context).size.width, // Set the width to the screen width
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAttributeCard("Age", widget.age),
                    _buildAttributeCard("Weight", widget.weight),
                    _buildAttributeCard("Quantity", widget.quantity.toString()),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppText(
                      text: widget.title,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold, // Unbold product name
                    ),
                  ),
                  Spacer(), // Pushes the price to the right
                  AppText(
                    text: 'Price: RS ${widget.price}',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal, // Unbold price
                  ),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText(
                    text: 'Description:',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  AppText(
                    text: widget.description,
                    fontSize: 14.0,
                  ),
                ],
              ),
            ),
            // Buy Button
            SizedBox(height: 60,),// Row containing Buy and View Video buttons
            Padding(
              padding: const EdgeInsets.only(top: 10),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjust alignment as needed
    children: [
    // Buy Button
      ElevatedButton(
        onPressed: () {
          // Navigate to the VideoPlayerScreen
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
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF021D33), // Set the button color to green
        ),
        child: Text(
          "View Video",
          style: TextStyle(color: Colors.white), // Set the text color to white
        ),
      ),
    SizedBox(
    width: 120,
    child:ElevatedButton(
      onPressed: () {
        // Navigate to the ChatScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(), // Create an instance of your ChatScreen
          ),
        );
      },
    style: ElevatedButton.styleFrom(

    primary: Colors.lightGreen, // Set the button color to blue
    ),
    child: Text(
    "Buy",
    style: TextStyle(color: Colors.white), // Set the text color to white
    ),
    ),
    // View Video Button
    ),
    ],
    ),
    ),
],
    ),
      ),
      ),
    );
  }

  Widget _buildAttributeCard(String title, String value) {
    return SizedBox(
      width: 100.0, // Adjust the width as needed
      height:  80.0, // Adjust the height as needed
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: title,
                fontSize: 12.0, // Decreased font size for attribute title
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8.0),
              AppText(
                text: value,
                fontSize: 10.0, // Decreased font size for attribute value
              ),
            ],
          ),
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
          widget.videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
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