import 'package:flutter/material.dart';

class HGap extends StatelessWidget {
  final double size;
  const HGap(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size);
  }
}

class VGap extends StatelessWidget {
  final double size;
  const VGap(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size);
  }
}
