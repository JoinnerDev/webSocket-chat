import 'package:flutter/material.dart';

class TreeDotsAnimated extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;
  final Curve curve;
  final int count;

  const TreeDotsAnimated({
    super.key,
    this.color = Colors.white,
    this.size = 10.0,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.count = 3,
  });

  @override
  State<TreeDotsAnimated> createState() => _TreeDotsAnimatedState();
}

class _TreeDotsAnimatedState extends State<TreeDotsAnimated> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: widget.curve),
      ),
    );

    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.7, curve: widget.curve),
      ),
    );

    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: widget.curve),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _animation,
          child: Padding(
            padding: const EdgeInsets.only(left: 1),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _animation2,
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _animation3,
          child: Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(100.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
