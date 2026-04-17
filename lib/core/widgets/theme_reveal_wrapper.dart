import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A wrapper that provides a circular reveal animation when the theme changes.
class ThemeRevealWrapper extends StatefulWidget {
  final Widget child;
  final ThemeMode themeMode;

  const ThemeRevealWrapper({
    super.key,
    required this.child,
    required this.themeMode,
  });

  @override
  State<ThemeRevealWrapper> createState() => ThemeRevealWrapperState();

  static ThemeRevealWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<ThemeRevealWrapperState>();
  }
}

class ThemeRevealWrapperState extends State<ThemeRevealWrapper> with SingleTickerProviderStateMixin {
  final GlobalKey _boundaryKey = GlobalKey();
  ui.Image? _previousImage;
  late AnimationController _animationController;
  Offset _center = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didUpdateWidget(ThemeRevealWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.themeMode != oldWidget.themeMode) {
      _startReveal();
    }
  }

  Future<void> _startReveal() async {
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary != null) {
        final image = await boundary.toImage(pixelRatio: ui.PlatformDispatcher.instance.views.first.devicePixelRatio);
        setState(() {
          _previousImage = image;
        });
        _animationController.forward(from: 0.0).then((_) {
          setState(() {
            _previousImage = null;
          });
        });
      }
    } catch (e) {
      debugPrint('Theme reveal error: $e');
    }
  }

  /// Called by the toggle button to set the center of the ripple
  void setThemeChangePosition(Offset position) {
    _center = position;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        RepaintBoundary(
          key: _boundaryKey,
          child: widget.child,
        ),
        if (_previousImage != null)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: _RevealPainter(
                  image: _previousImage!,
                  fraction: _animationController.value,
                  center: _center,
                ),
                child: SizedBox.expand(),
              );
            },
          ),
      ],
    );
  }
}

class _RevealPainter extends CustomPainter {
  final ui.Image image;
  final double fraction;
  final Offset center;

  _RevealPainter({
    required this.image,
    required this.fraction,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // We want to reveal the NEW theme (which is already rendered behind this painter).
    // So we draw the OLD theme image, but clipped so that the NEW theme shows through.
    
    final paint = Paint();
    // Create a path that covers everything EXCEPT the growing circle
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: fraction * sqrt(pow(size.width, 2) + pow(size.height, 2))))
      ..fillType = PathFillType.evenOdd;

    canvas.save();
    canvas.clipPath(path);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RevealPainter oldDelegate) => true;
}
