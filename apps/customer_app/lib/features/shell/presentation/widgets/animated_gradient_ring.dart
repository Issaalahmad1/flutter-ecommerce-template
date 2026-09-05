import 'package:decoze_core/core.dart';
import 'package:flutter/material.dart';

/// إطار متدرّج (أصفر↔رمادي) بيلف حوالين صورة البروفايل ويدور باستمرار
/// لما التاب يبقى مفعّل — قريب من حركة "Story Ring" بتاعة إنستجرام،
/// بس بألوان البراند بدل قوس قزح إنستجرام. لما التاب مش مفعّل، بيفضل
/// إطار رمادي ثابت من غير حركة.
class AnimatedGradientRing extends StatefulWidget {
  final Widget child;
  final bool isActive;

  const AnimatedGradientRing({super.key, required this.child, required this.isActive});

  @override
  State<AnimatedGradientRing> createState() => _AnimatedGradientRingState();
}

class _AnimatedGradientRingState extends State<AnimatedGradientRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const brand = BrandConfig.decoze;

    if (!widget.isActive) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: brand.textSecondary.withValues(alpha: 0.5)),
        ),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              transform: GradientRotation(_controller.value * 6.2832),
              colors: [
                brand.accent,
                brand.textSecondary,
                brand.accent,
                brand.textSecondary,
                brand.accent,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
