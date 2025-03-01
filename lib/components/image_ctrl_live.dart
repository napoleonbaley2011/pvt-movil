import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:muserpol_pvt/bloc/user/user_bloc.dart';
import 'package:muserpol_pvt/components/button.dart';

class ImageCtrlLive extends StatefulWidget {
  final Function(String) sendImage;
  const ImageCtrlLive({super.key, required this.sendImage});

  @override
  State<ImageCtrlLive> createState() => _ImageCtrlLiveState();
}

class _ImageCtrlLiveState extends State<ImageCtrlLive>
    with WidgetsBindingObserver {
  late List<CameraDescription>? _availableCameras;
  CameraController? controllerCam;
  bool? isCameraReady;
  Future<void>? _initializeControllerFuture;
  double mirror = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getAvailableCameras();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controllerCam!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controllerCam == null || !controllerCam!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controllerCam?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controllerCam != null) {
        _getAvailableCameras();
      }
    }
  }

  Future<void> _getAvailableCameras() async {
    _availableCameras = await availableCameras();
    CameraDescription newDescription;
    newDescription = _availableCameras!.firstWhere((description) =>
        description.lensDirection == CameraLensDirection.front);
    _initCamera(newDescription);
  }

  Future<void> _initCamera(CameraDescription description) async {
    final stateCam = BlocProvider.of<UserBloc>(context, listen: false);
    controllerCam = CameraController(description, ResolutionPreset.high,
        enableAudio: false);
    _initializeControllerFuture = controllerCam!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controllerCam!.setFlashMode(FlashMode.off);
      controllerCam!.addListener(() {
        if (mounted) setState(() {});
        if (controllerCam!.value.hasError) {
          debugPrint('Camera error ${controllerCam!.value.errorDescription}');
        }
      });
      stateCam.add(UpdateStateBtntoggleCameraLens(true));
      setState(() {});
    }).catchError((Object e) {
      debugPrint('error $e');
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint('User denied camera access.');
            break;
          default:
            debugPrint('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stateCam = BlocProvider.of<UserBloc>(context, listen: true).state;
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            stateCam.stateCam) {
          return Stack(children: <Widget>[
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(mirror),
                    child: CameraPreview(
                      controllerCam!,
                    ))),
            stateCam.stateBtntoggleCameraLens
                ? Positioned(
                    bottom: 20,
                    right: 20,
                    left: 20,
                    child: Row(
                      children: [
                        IconBtnComponent(
                          iconText: 'assets/icons/camera-switch.svg',
                          onPressed: () => switchCam(),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: ButtonComponent(
                                text: 'CAPTURAR',
                                onPressed: () => takePhoto())),
                      ],
                    ))
                : Container(),
          ]);
        } else {
          return Center(
              child: Image.asset(
            'assets/images/load.gif',
            fit: BoxFit.cover,
            height: 20,
          )); // Otherwise, display a loading indicator.
        }
      },
    );
  }

  switchCam() {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    if (userBloc.state.stateCam) {
      userBloc.add(UpdateStateBtntoggleCameraLens(false));
      _toggleCameraLens();
    }
  }

  takePhoto() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    try {
      if (userBloc.state.stateBtntoggleCameraLens) {
        userBloc.add(UpdateStateCam(false));
        final picture = await controllerCam!.takePicture();
        ImageProperties properties = await FlutterNativeImage.getImageProperties(picture.path);
        File compressedFile = await FlutterNativeImage.compressImage(
          picture.path,
          quality: 70,
          targetWidth: properties.height! > properties.width! ? 240 : 320,
          targetHeight: properties.height! > properties.width! ? 320 : 240,
        );
        String base64 = base64Encode(compressedFile.readAsBytesSync());
        widget.sendImage(base64);
      }
    } catch (_) {
      debugPrint('paso paso algo');
    }
  }

  void _toggleCameraLens() {
    final lensDirection = controllerCam!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      setState(() => mirror = math.pi);
      newDescription = _availableCameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      setState(() => mirror = 0);
      newDescription = _availableCameras!.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }
    _initCamera(newDescription);
  }
}
