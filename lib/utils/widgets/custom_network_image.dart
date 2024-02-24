import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double borderRadius;
  final double? height;
  final BoxFit? fit;
  final double? width;
  final Color? color;
  final AlignmentGeometry? alignment;
  final Widget? child;

  const CustomNetworkImage({
    super.key,
    required this.url,
    this.height,
    this.color,
    this.fit,
    this.alignment,
    this.child,
    this.width,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      color: Colors.grey.withOpacity(0.25),
      errorWidget: (context, url, error) {
        print(" --> --> err in chached network image : $error");
        return SizedBox(
            height: height, width: width, child: const Icon(Icons.error));
      },
      placeholder: (context, url) => Container(
        alignment: alignment,
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.grey.withOpacity(0.25),
        ),
        child: child,
      ),
      imageBuilder: (context, image) => Container(
        height: height,
        width: width,
        alignment: alignment,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
            fit: fit ?? BoxFit.cover,
            image: image,
          ),
        ),
        child: child,
      ),
    );
  }
}
