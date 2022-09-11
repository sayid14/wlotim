import 'package:flutter/material.dart';

class ImageNetWork extends StatelessWidget {
  const ImageNetWork(this.image, {Key? key, this.fit}) : super(key: key);
  final String image;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        "assets/broken_image.png",
        fit: fit,
      ),
    );
  }
}
