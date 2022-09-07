import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.width, required this.category})
      : super(key: key);
  final double width;
  final String category;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CategoryCardClipper(),
      child: Container(
        width: width,
        color: Colors.yellow[900],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CategoryCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * .9, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
