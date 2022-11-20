import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GCPMundo extends StatefulWidget {
  const GCPMundo({Key? key}) : super(key: key);

  @override
  _GCPMundoState createState() => _GCPMundoState();
}

class _GCPMundoState extends State<GCPMundo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: 'ZG4qkdiXdqU',
        flags: const YoutubePlayerFlags(mute: false, autoPlay: true));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              "GCP Mundo",
              style: TextStyle(
                shadows: [
                  Shadow(
                    blurRadius: 8.0,
                    color: Colors.black,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {},
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback);
  }

  Future<bool> _willPopCallback() async {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      _controller.toggleFullScreenMode();
    }
    return true; // return true if the route to be popped
  }
}
