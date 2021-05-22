import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatefulWidget {
  static const routeName = '/image_preview';

  final ImageProvider imageProvider;

  ImagePreviewScreen({this.imageProvider});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
//            value: event == null
//                ? 0
//                : event.cumulativeBytesLoaded / event.expectedTotalBytes,
          ),
        ),
        imageProvider: widget.imageProvider,
      ),
    );
  }
}