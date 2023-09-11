import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomNotchedContainer extends StatelessWidget {
  const CustomNotchedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notched Container"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ClipPath(
                  clipper: NotchClipperPath(iconRadius: 24, padding: 8.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                    width: double.infinity,
                    height: 50,
                  ),
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Transform.translate(
                        offset: const Offset(0, -24),
                        child: Container(
                          width: 24 * 2,
                          height: 24 * 2,
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.5),
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.add,
                            size: 24,
                          ),
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotchClipperPath extends CustomClipper<Path> {
  final double iconRadius;
  final double padding;

  NotchClipperPath({required this.iconRadius, this.padding = 0.0 });

  @override
  Path getClip(Size size) {
    final double notchRadius = iconRadius + padding ;

    // We build a path for the notch from 3 segments:
    // Segment A - a Bezier curve from the host's top edge to segment B.
    // Segment B - an arc with radius notchRadius.
    // Segment C - a Bezier curve from segment B back to the host's top edge.
    //
    // A detailed explanation and the derivation of the formulas below is
    // available at: https://goo.gl/Ufzrqn

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;

    // TODO, must fetch guest widget center
    final double b = 0 - 0;
    // final double b = host.top - guest.center.dy;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset?> p = List<Offset?>.filled(6, null);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2]!.dx, p[2]!.dy);
    p[4] = Offset(-1.0 * p[1]!.dx, p[1]!.dy);
    p[5] = Offset(-1.0 * p[0]!.dx, p[0]!.dy);

    // translate all points back to the absolute coordinate system.
    for (int i = 0; i < p.length; i += 1) {
      // TODO, must fecth the guest widget center
      // p[i] = p[i]! + guest.center;
      p[i] = p[i]! + Offset((size.width / 2), 0);
    }

    return Path()
      ..moveTo(0, 0)
      ..lineTo(p[0]!.dx, p[0]!.dy)
      ..quadraticBezierTo(p[1]!.dx, p[1]!.dy, p[2]!.dx, p[2]!.dy)
      ..arcToPoint(
        p[3]!,
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(p[4]!.dx, p[4]!.dy, p[5]!.dx, p[5]!.dy)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class NotchClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(size.width / 2, 0, 30, 20);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
