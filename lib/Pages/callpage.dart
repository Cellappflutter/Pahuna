import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ecommerce_app_ui_kit/Helper/constant.dart';
import 'package:ecommerce_app_ui_kit/Helper/screen_size_config.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final List<int> _users = <int>[];
  final List<int> _finalUsers = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool video = true;
  double dx = ScreenSizeConfig.safeBlockHorizontal * 100-150;
  double dy = 0;

  void dispose() {
    _users.clear();
    _finalUsers.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      print("ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRROR");
      print(code);
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) async {
    };

    AgoraRtcEngine.onLeaveChannel = () async {
      print("User Leavedd");
      setState(() {
        _users.clear();
        _finalUsers.clear();
      });
    };
    AgoraRtcEngine.onConnectionLost = () async {
      Navigator.pop(context);
    };
    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      ///When 2nd user joins
      print("user JOINEDD");
      setState(() {
        _users.add(uid);
        _finalUsers.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      //When 2nduser hangs
      Navigator.of(context).pop();
    };
    AgoraRtcEngine.onRemoteVideoStateChanged = (int a, int b, int c, int d) {
      if (video == false && b != 0) {
        toggleVideoScreen();
      }
      if (b == 0) {
        if (_users.isNotEmpty) {
          AgoraRtcEngine.muteRemoteVideoStream(_users[0], true);
        }
        AgoraRtcEngine.enableLocalVideo(false);
        AgoraRtcEngine.disableVideo();
        setState(() {
          video = false;
          _users.clear();
        });
      }
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  void toggleVideoScreen() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Text("Enable Video for Video Chat"),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  AgoraRtcEngine.enableVideo();
                  AgoraRtcEngine.enableLocalVideo(true);
                  AgoraRtcEngine.muteRemoteVideoStream(_users[0], false);
                  Navigator.pop(context);
                },
                child: Text("Yes"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              )
            ],
          );
        });
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Container(child: view);
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Stack(
      children: wrappedViews,
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Stack(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Stack(
          children: <Widget>[
            _expandedVideoRow([views[1]]),
            Positioned(
              left: dx,
              top: dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    if ((dx + details.delta.dx + 150) >
                        ScreenSizeConfig.safeBlockHorizontal * 100) {
                      dx = ScreenSizeConfig.safeBlockHorizontal * 100 - 150;
                    } else if ((dx + details.delta.dx) <
                        ScreenSizeConfig.safeBlockHorizontal * 0) {
                      dx = 0;
                    } else {
                      dx += details.delta.dx;
                    }
                    if ((dy + details.delta.dy + 150) >
                        ScreenSizeConfig.safeBlockVertical * 100) {
                      dy = ScreenSizeConfig.safeBlockVertical * 100 - 150;
                    } else if ((dy + details.delta.dy) <
                        ScreenSizeConfig.safeBlockVertical * 0) {
                      dy = 0;
                    } else {
                      dy += details.delta.dy;
                    }
                  });
                },
                child: Container(
                  height: 150,
                  width: 150,
                  child: _expandedVideoRow(
                    [views[0]],
                  ),
                ),
              ),
            ),
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                onPressed: _onToggleVideo,
                child: Icon(
                  video ? Icons.videocam : Icons.videocam_off,
                  color: video ? Colors.blueAccent : Colors.white,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: video ? Colors.white : Colors.blueAccent,
                padding: const EdgeInsets.all(12.0),
              ),
              RawMaterialButton(
                onPressed: _onToggleMute,
                child: Icon(
                  muted ? Icons.mic_off : Icons.mic,
                  color: muted ? Colors.white : Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: muted ? Colors.blueAccent : Colors.white,
                padding: const EdgeInsets.all(12.0),
              ),
              RawMaterialButton(
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
                  color: Colors.blueAccent,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(12.0),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) async {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onToggleVideo() {
    setState(() {
      video = !video;
    });
    if (!video) {
      AgoraRtcEngine.disableVideo();
      AgoraRtcEngine.enableLocalVideo(false);
      if (_users.isNotEmpty) {
        AgoraRtcEngine.muteRemoteVideoStream(_users[0], true);
      }
      setState(() {
        _users.clear();
      });
    } else {
      AgoraRtcEngine.enableVideo();
      AgoraRtcEngine.enableLocalVideo(true);
      setState(() {
        _users.add(_finalUsers[0]);
      });
      if (_users.isNotEmpty) {
        AgoraRtcEngine.muteRemoteVideoStream(_users[0], false);
      }
    }
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
