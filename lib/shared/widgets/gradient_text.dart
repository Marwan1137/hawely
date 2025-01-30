import 'package:flutter/material.dart';

class GradientText extends StatefulWidget {
  const GradientText({
    required this.text,
    super.key,
    required this.colors,
    this.style,
    this.duration = const Duration(seconds: 2),
  });

  final String text;
  final TextStyle? style;
  final List<Color> colors;
  final Duration duration;

  @override
  // ignore: library_private_types_in_public_api
  _GradientTextState createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration, // Use the provided duration
    )..repeat(reverse: true); // Loop the animation

    // Define the animation
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: widget.colors,
            stops: [_animation.value, _animation.value + 0.5], // Animate stops
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            widget.text,
            style: widget.style
                ?.copyWith(color: Colors.white), // Ensure text is visible
          ),
        );
      },
    );
  }
}
