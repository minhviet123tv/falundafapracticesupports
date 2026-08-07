import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:falun_dafa_practice_supports/common/app_font_size_scale.dart';

/// Thanh chọn **Kích thước chữ** — 9 nấc ngang (theo ceo_calendar).
class AppFontSizeScaleSlider extends StatelessWidget {
  const AppFontSizeScaleSlider({
    super.key,
    required this.selected,
    required this.onSelected,
    this.accentColor = Colors.blue,
  });

  final AppFontSizeScale selected;
  final ValueChanged<AppFontSizeScale> onSelected;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return _FontSizeScaleTrack(
      values: AppFontSizeScale.values,
      selected: selected,
      onSelected: onSelected,
      scheme: Theme.of(context).colorScheme,
      accentColor: accentColor,
    );
  }
}

class _FontSizeScaleTrack extends StatelessWidget {
  const _FontSizeScaleTrack({
    required this.values,
    required this.selected,
    required this.onSelected,
    required this.scheme,
    required this.accentColor,
  });

  final List<AppFontSizeScale> values;
  final AppFontSizeScale selected;
  final ValueChanged<AppFontSizeScale> onSelected;
  final ColorScheme scheme;
  final Color accentColor;

  static const double _trackHeight = 4;
  static const double _trackVerticalInset = 14;
  static const List<double> _dotDiameters = [
    12, 13, 14, 16, 18, 21, 26, 30, 34,
  ];

  double _dotDiameterForIndex(int index) {
    if (index >= 0 && index < _dotDiameters.length) {
      return _dotDiameters[index];
    }
    return _dotDiameters.last;
  }

  double get _maxDotDiameter {
    var max = 0.0;
    for (var i = 0; i < values.length; i++) {
      max = math.max(max, _dotDiameterForIndex(i));
    }
    return max;
  }

  double _centerXForIndex(int index, double width) {
    if (values.length <= 1) return width / 2;
    final maxRadius = _maxDotDiameter / 2 + 2;
    final usable = width - 2 * maxRadius;
    return maxRadius + usable * (index / (values.length - 1));
  }

  int _indexForLocalX(double x, double width) {
    var best = 0;
    var bestDist = double.infinity;
    for (var i = 0; i < values.length; i++) {
      final dist = (x - _centerXForIndex(i, width)).abs();
      if (dist < bestDist) {
        bestDist = dist;
        best = i;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = values.indexOf(selected).clamp(0, values.length - 1);

    return SizedBox(
      height: _trackVerticalInset * 2 + _maxDotDiameter,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final centerY = constraints.maxHeight / 2;
          final maxRadius = _maxDotDiameter / 2 + 2;

          void pickAt(double localX) {
            onSelected(values[_indexForLocalX(localX, width)]);
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => pickAt(d.localPosition.dx),
            onHorizontalDragUpdate: (d) => pickAt(d.localPosition.dx),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: maxRadius,
                  right: maxRadius,
                  top: centerY - _trackHeight / 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.outlineVariant.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(_trackHeight / 2),
                    ),
                    child: const SizedBox(height: _trackHeight),
                  ),
                ),
                for (var i = 0; i < values.length; i++)
                  _FontSizeScaleDot(
                    left: _centerXForIndex(i, width),
                    top: centerY,
                    diameter: _dotDiameterForIndex(i),
                    isSelected: i == selectedIndex,
                    scheme: scheme,
                    accentColor: accentColor,
                    onTap: () => onSelected(values[i]),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FontSizeScaleDot extends StatelessWidget {
  const _FontSizeScaleDot({
    required this.left,
    required this.top,
    required this.diameter,
    required this.isSelected,
    required this.scheme,
    required this.accentColor,
    required this.onTap,
  });

  final double left;
  final double top;
  final double diameter;
  final bool isSelected;
  final ColorScheme scheme;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left - diameter / 2,
      top: top - diameter / 2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? accentColor
                  : scheme.onSurface.withValues(alpha: 0.62),
              border: Border.all(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.85)
                    : scheme.surface,
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.35),
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
