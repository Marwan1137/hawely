import 'package:flutter/material.dart'; // Flutter framework for UI components

/* -------------------------------------------------------------------------- */
/*                            GradientText Widget                             */
/* -------------------------------------------------------------------------- */
class GradientText extends StatefulWidget {
  const GradientText({
    required this.text, // Text to be displayed
    super.key,
    required this.colors, // List of colors for the gradient
    this.style, // TextStyle for customizing text appearance
    this.duration = const Duration(seconds: 2), // Duration of the animation
  });

  final String text; // Text to display
  final TextStyle? style; // Style of the text
  final List<Color> colors; // Gradient colors
  final Duration duration; // Duration of the gradient animation

  @override
  // ignore: library_private_types_in_public_api
  _GradientTextState createState() =>
      _GradientTextState(); // State of the widget
}

/* -------------------------------------------------------------------------- */
/*                        GradientText Widget State                           */
/* -------------------------------------------------------------------------- */
class _GradientTextState extends State<GradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Animation controller
  late Animation<double> _animation; // Animation to control the gradient

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this, // Provide SingleTickerProviderStateMixin for animations
      duration: widget.duration, // Use the provided animation duration
    )..repeat(reverse: true); // Repeat the animation with a reverse effect

    // Define the animation for gradient stops
    _animation =
        Tween(begin: 0.0, end: 1.0).animate(_controller); // Tween from 0 to 1
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation, // Attach the animation
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn, // Blend mode for masking
          shaderCallback: (bounds) => LinearGradient(
            colors: widget.colors, // Apply the gradient colors
            stops: [
              _animation.value, // Start point of the gradient animation
              _animation.value + 0.5, // End point of the gradient animation
            ],
            begin: Alignment.topLeft, // Start alignment of the gradient
            end: Alignment.bottomRight, // End alignment of the gradient
          ).createShader(
            Rect.fromLTWH(
                0, 0, bounds.width, bounds.height), // Area of the gradient
          ),
          child: Text(
            widget.text, // Display the provided text
            style: widget.style
                ?.copyWith(color: Colors.white), // Ensure the text is visible
          ),
        );
      },
    );
  }
}
