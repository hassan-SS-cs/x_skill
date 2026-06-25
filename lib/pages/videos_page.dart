import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_skill/models/comment_model.dart';
import 'package:x_skill/models/video_model.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  List<VideoModel> _videos = [];
  VideoModel? _currentVideo;
  VideoPlayerController? _controller;
  List<CommentModel> _comments = [];
  TextEditingController _commentController = TextEditingController();
  Map<String, Duration> _videoDurations = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await _loadData();
    await _initController();
  }
  // format Duration 
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  Future<void> _loadData() async {
    final jsontStr = await rootBundle.loadString('assets/data/videos.json');
    final List data = json.decode(jsontStr);
    setState(() {
      _videos = data.map((item) => VideoModel.fromJson(item)).toList();
      _currentVideo = _videos.first;
      _comments = _currentVideo!.comments;
    });
    for (final video in _videos) {
      final temp = VideoPlayerController.asset(video.url);
      await temp.initialize();
      _videoDurations[video.id] = temp.value.duration;
      await temp.dispose();
    }
    setState(() {});
  }
  // adds a listener so the timer updates every frame
  Future<void> _initController() async {
    _controller?.dispose();
    _controller = VideoPlayerController.asset(_currentVideo!.url);
    await _controller!.initialize();
    _controller!.addListener(() {
      setState(() {});
    });
    setState(() {});
  }
  // disposes old controller switches to new video
  Future<void> _changeVideo(VideoModel video) async {
    _controller?.dispose();
    setState(() {
      _currentVideo = video;
      _comments = List.from(video.comments);
    });
    await _initController();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Text(_currentVideo!.title),
              // Video player by double click or long press
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                },
                onLongPressStart: (_) => _controller!.setPlaybackSpeed(2.0),
                onLongPressEnd: (_) => _controller!.setPlaybackSpeed(1.0),
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
              // Controls part here like play, pause, timer, mute
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    },
                  ),
                  Text(
                    '${_formatDuration(_controller!.value.position)} / ${_formatDuration(_controller!.value.duration)}',
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      _controller!.value.volume > 0
                          ? Icons.volume_up
                          : Icons.volume_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller!.setVolume(
                          _controller!.value.volume > 0 ? 0 : 1,
                        );
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              // more videos
              Text(
                'More videos...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...(_videos
                  .where((v) => v.id != _currentVideo!.id)
                  .map(
                    (video) => GestureDetector(
                      onTap: () => _changeVideo(video),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: const Color.fromARGB(255, 200, 200, 200),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 60,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: Icon(Icons.play_circle_outline),
                            ),
                            SizedBox(width: 8),
                            Text(
                              _videoDurations.containsKey(video.id)
                                  ? _formatDuration(_videoDurations[video.id]!)
                                  : '--:--',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).toList()),
              SizedBox(height: 16),
              // comment part here
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Type a new comment here',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_commentController.text.isNotEmpty) {
                        setState(() {
                          _comments.add(
                            CommentModel(
                              ip: '192.168.1.${_comments.length + 1}',
                              content: _commentController.text,
                            ),
                          );
                          _commentController.clear();
                        });
                      }
                    },
                    child: Text('Publish'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '${_comments.length} Comments',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...(_comments.map(
                (c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From ${c.ip}',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(c.content),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}