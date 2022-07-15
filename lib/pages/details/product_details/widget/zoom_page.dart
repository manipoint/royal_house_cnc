import 'package:cached_network_image/cached_network_image.dart';
import "package:vector_math/vector_math_64.dart" show Vector3;
import 'package:flutter/material.dart';

class ZoomInOut extends StatefulWidget {
  static const String routeName = '/zoom-in';
  final String productImage;

  const ZoomInOut({Key? key, required this.productImage}) : super(key: key);

  @override
  State<ZoomInOut> createState() => _ZoomInOutState();
}

class _ZoomInOutState extends State<ZoomInOut> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            _previousScale = _scale;
            setState(() {});
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            _scale = _previousScale * details.scale;

            setState(() {});
          },
          onScaleEnd: (ScaleEndDetails details) {
            _previousScale = 1.0;
            setState(() {});
          },
          child: RotatedBox(
            quarterTurns: 0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                  imageUrl: widget.productImage,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
