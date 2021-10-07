import 'package:flutter/material.dart';

enum CirillaAnimationIndicatorType { circle, line }

class CirillaAnimationIndicator extends StatefulWidget {
  final double value;
  final Color? color;
  final Color? indicatorColor;
  final Duration? duration;

  /// use when [type = CirillaAnimationIndicatorType.circle]
  final double? size;
  final double? strokeWidth;
  final CirillaAnimationIndicatorType type;

  CirillaAnimationIndicator({
    Key? key,
    this.value = 1,
    this.color,
    this.indicatorColor,
    this.duration,
    this.size,
    this.strokeWidth,
    this.type = CirillaAnimationIndicatorType.line,
  })  : assert(value >= 0 && value <= 1),
        super(key: key);

  @override
  _CirillaAnimationIndicatorState createState() => _CirillaAnimationIndicatorState();
}

class _CirillaAnimationIndicatorState extends State<CirillaAnimationIndicator> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    double valueTo = widget.value;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.animateTo(valueTo);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CirillaAnimationIndicator oldWidget) {
    if (oldWidget.value != widget.value) {
      return change(widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  void change(double value) {
    controller.animateTo(value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    switch (widget.type) {
      case CirillaAnimationIndicatorType.circle:
        double size = widget.size ?? 72;
        double strokeWidth = widget.strokeWidth ?? 5;
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: controller.value,
            backgroundColor: widget.color ?? theme.dividerColor,
            color: widget.indicatorColor ?? theme.primaryColor,
            strokeWidth: strokeWidth,
          ),
        );
      default:
        double strokeWidth = widget.strokeWidth ?? 6;
        return ClipRRect(
          borderRadius: BorderRadius.circular(strokeWidth / 2),
          child: SizedBox(
            height: strokeWidth,
            child: LinearProgressIndicator(
              value: controller.value,
              backgroundColor: widget.color ?? theme.dividerColor,
              color: widget.indicatorColor ?? theme.primaryColor,
            ),
          ),
        );
    }
  }
}
