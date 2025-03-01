import 'package:flutter/material.dart';

class ContainerComponent extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color color;
  const ContainerComponent(
      {super.key,
      required this.child,
      this.width,
      this.height,
      this.color=Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: color,
            ),
            child: child));
  }
}
