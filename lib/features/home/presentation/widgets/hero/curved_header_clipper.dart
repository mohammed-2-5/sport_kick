import 'package:flutter/material.dart';

/// Custom clipper for curved header with elegant wave effect.
///
/// Creates a smooth S-curve at the bottom of the header.
/// The curve depth can be customized for different visual effects.
class CurvedHeaderClipper extends CustomClipper<Path> {
  /// The depth of the curve effect (default: 60)
  final double curveDepth;

  /// The intensity of the wave pattern (default: 1.0)
  final double waveIntensity;

  CurvedHeaderClipper({this.curveDepth = 60, this.waveIntensity = 1.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    final effectiveDepth = curveDepth * waveIntensity;

    path.lineTo(0, size.height - effectiveDepth);

    // First wave segment - curves down
    final firstControlPoint = Offset(
      size.width * 0.25,
      size.height - effectiveDepth - (20 * waveIntensity),
    );
    final firstEndPoint = Offset(
      size.width * 0.5,
      size.height - effectiveDepth + (20 * waveIntensity),
    );

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second wave segment - curves up
    final secondControlPoint = Offset(
      size.width * 0.75,
      size.height - effectiveDepth + (60 * waveIntensity),
    );
    final secondEndPoint = Offset(
      size.width,
      size.height - effectiveDepth + (10 * waveIntensity),
    );

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CurvedHeaderClipper oldClipper) =>
      oldClipper.curveDepth != curveDepth ||
      oldClipper.waveIntensity != waveIntensity;
}
