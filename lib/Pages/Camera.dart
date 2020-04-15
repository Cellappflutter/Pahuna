import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ecommerce_app_ui_kit/config/ui_icons.dart';
import 'package:ecommerce_app_ui_kit/database/database.dart';
import 'package:ecommerce_app_ui_kit/database/storage.dart';
import 'package:ecommerce_app_ui_kit/src/screens/customappbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraState extends StatefulWidget {
  @override
  _CameraStateState createState() => _CameraStateState();
}

class _CameraStateState extends State<CameraState>
    with TickerProviderStateMixin {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  int _index = 1;
  bool isOpened = false;
  AnimationController _animationController;

  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  File _image;
  bool isGalleryImage = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    animationInit();
    initCamera();
  }

  initCamera() {
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 1;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  animationInit() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      //  errorDialog(context, "Theres problem with device Camera");
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget uploadImage() {
    return Container(
      child: FloatingActionButton(
        heroTag: "uploadImage",
        onPressed: () async {
          //  CircularProgressIndicator();
          //    showLoading();
          await uploadPicture().then((onValue) {
            //   Navigator.of(_scaffoldKey.currentContext).pop();
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: (onValue)
                  ? Text("Sucessfully uploaded")
                  : Text(
                      "There's problem uploading Image, Please try again.",
                      overflow: TextOverflow.fade,
                    ),
              backgroundColor: (onValue) ? Colors.green : Colors.red,
            ));
            if (onValue) {
              _animationController.reverse();
              _image = null;
              isOpened = false;
              setState(() {});
            }
          });
        },
        child: Icon(Icons.cloud_upload),
      ),
    );
  }

  Widget deleteImage() {
    return Container(
      child: FloatingActionButton(
        onPressed: () {
          if (!isGalleryImage) {
            initCamera();
            _index = 2;
          } else {
            _index = 1;
          }
          _image = null;
          isOpened = false;
          setState(() {});
          _animationController.reverse();
        },
        child: Icon(Icons.delete_forever),
      ),
    );
  }

  Widget gallery() {
    return Container(
      child: FloatingActionButton(
        heroTag: "gallery",
        backgroundColor: Colors.green,
        onPressed: () {
          if (_index != 3) {
            if (isOpened) {
              _animationController.reverse();
              isOpened = false;
            }
            _image = null;
            _index = 1;
            setState(() {});
            launchGallery();
          }
        },
        child: Icon(
          UiIcons.image,
        ),
      ),
    );
  }

  Widget cameraToggle() {
    return Container(
      child: FloatingActionButton(
          heroTag: "cameraToggle",
          backgroundColor: Colors.blue,
          onPressed: () async {
            if (_index != 2) {
              controller.initialize().then((onValue) {
                if (isOpened) {
                  isOpened = false;
                  _animationController.reverse();
                }
              });
              _index = 2;
              setState(() {});
            }
          },
          child: Icon(Icons.photo_camera)),
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _cameraTogglesRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;
    return Align(
      alignment: Alignment.topRight,
      child: FlatButton(
        onPressed: _onSwitchCamera,
        child: Icon(
          _getCameraLensIcon(lensDirection),
          size: 30,
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  Future<void> _onCapturePressed(context) async {
    try {
      String dateTime = DateTime.now().toString();
      final path = join(
        (await getTemporaryDirectory()).path,
        '$dateTime.jpeg',
      );
      await controller.takePicture(path);
      print(path);
      print(dateTime);
      setState(() {
        _index = 1;
        _image = File(path);
        isGalleryImage = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    SafeArea(
     
      child: 
      Scaffold(
        appBar: customAppBar(context, "Upload Image"),
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            getChildWidget(),
            floatingButton(context),
          ],
        ),
      ),
    );
  }

  getChildWidget() {
    switch (_index) {
      case 1:
        {
          return defaultScreen();
        }
      case 2:
        {
          return cameraScreen();
        }
      case 3:
        {
          return galleryScreen();
        }
      default:
        {
          return defaultScreen();
        }
    }
  }

  defaultScreen() {
    return Center(
      child: (_image != null)
          ? Image.file(_image)
          : Image.asset("assets/image_placeholder.png"),
    );
  }

  galleryScreen() {
    return Center(
      child: Text("Gallery screen"),
    );
  }

  cameraScreen() {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        _cameraPreviewWidget(),
        _cameraTogglesRowWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              heroTag: "cameraScreen",
              backgroundColor: Colors.blueGrey,
              onPressed: () {
                _onCapturePressed(context).then((onValue) {
                  if (!isOpened) {
                    _animationController.forward();
                    isOpened = true;
                  }
                });
              },
              child: Icon(Icons.camera),
            ),
          ),
        )
      ],
    );
  }

  floatingButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * 2.0,
                0.0,
              ),
              child: uploadImage(),
            ),
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton.value * 1.0,
                0.0,
              ),
              child: deleteImage(),
            ),
            cameraToggle(),
            SizedBox(
              height: 10,
            ),
            gallery(),
          ],
        ),
      ),
    );
  }

  Future<bool> uploadPicture() async {
    try {
      String fileName = _image.path.split('/').removeLast();
      return await Future.wait([
        StorageService().uploadImage(_image, fileName),
        DatabaseService().addUserPhoto(DatabaseService.uid, fileName)
      ]).then((onValue) {
        if (onValue[0] && onValue[1]) {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  launchGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = image;
      _animationController.forward();
      isOpened = true;
      isGalleryImage = true;
      setState(() {});
    }
  }

  showLoading() {
    showDialog(
        context: (_scaffoldKey.currentContext),
        barrierDismissible: false,
        builder: (currentContext) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Center(child: CircularProgressIndicator()),
          );
        });
  }
}
