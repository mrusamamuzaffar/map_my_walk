import 'dart:async';
import 'package:flutter/material.dart';

class Animator extends StatefulWidget {
  final Widget? child;
  final Duration? time;

  const Animator({
    Key? key,
    this.child,
    this.time,
  }) : super(key: key);

  @override
  AnimatorState createState() => AnimatorState();
}

class AnimatorState extends State<Animator> with SingleTickerProviderStateMixin {
  Timer? timer;
  AnimationController? animationController;
  Animation<double>? animation;  // Ensure the animation is typed to match expected usage.

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 290),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeInOut,
    );

    // Delay the timer start to wait for the duration provided by the parent.
    timer = Timer(widget.time ?? Duration.zero, () {  // Provide a default value if none is given.
      // Check both mounted and animationController status to ensure safe operation.
      if (mounted && animationController != null && !animationController!.isAnimating) {
        animationController!.forward();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: animation!.value,
          child: Transform.translate(
            offset: Offset(0.0, (1 - animation!.value) * 20),
            child: child,
          ),
        );
      },
    );
  }
}

class WidgetAnimator extends StatelessWidget {
  final Widget child;

  const WidgetAnimator({
    Key? key,
    required this.child,
  }) : super(key: key);

  // Removed the timer and duration logic from this class.
  @override
  Widget build(BuildContext context) {
    return Animator(
      key: key,
      child: child,
      time: const Duration(milliseconds: 500), // Set a constant start delay.
    );
  }
}
