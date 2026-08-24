import 'dart:async';
import 'package:flutter/material.dart';

/// A global trigger for smooth animations when switching between navigation items.
class SmoothAnimationTrigger {
  static final StreamController<int> _controller = StreamController<int>.broadcast();
  static Stream<int> get stream => _controller.stream;

  static void trigger(int index) {
    _controller.add(index);
  }
}

class SmoothEntryAnimation extends StatefulWidget {
  final Widget child;
  final Offset slideOffset;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final int? navIndex;

  const SmoothEntryAnimation({
    super.key,
    required this.child,
    this.slideOffset = const Offset(0, 40),
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutQuart,
    this.navIndex,
  });

  @override
  State<SmoothEntryAnimation> createState() => _SmoothEntryAnimationState();
}

class _SmoothEntryAnimationState extends State<SmoothEntryAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    // Initial play
    _startAnimation();

    // Listen for navigation triggers
    if (widget.navIndex != null) {
      _subscription = SmoothAnimationTrigger.stream.listen((index) {
        if (index == widget.navIndex) {
          _startAnimation();
        }
      });
    }
  }

  void _startAnimation() {
    _controller.reset();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
