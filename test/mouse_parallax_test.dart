import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mouse_parallax/src/parallax_factor_calculator.dart';

import 'widgets/golden_test_widget.dart';

extension SetScreenSize on WidgetTester {
  Future<void> setScreenSize(
      {double width = 540,
      double height = 960,
      double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = pixelDensity;
  }
}

enum OffsetDefault { topLeft, bottomRight, center }
void main() {
  group('Test Rendering', () {
    testWidgets(
      'Parallax Layers are positioned correctly',
      (WidgetTester tester) async {
        final starterWidget = GoldenTestWidget();
        await tester.setScreenSize(width: 797, height: 596);
        await tester.pumpWidget(starterWidget);
        await expectLater(
          find.byType(GoldenTestWidget),
          matchesGoldenFile('goldens/golden1.png'),
        );
      },
    );
  });

  group('RangeParallaxFactorCalculator Test', () {
    RangeParallaxFactorCalculator getBasicCalculator({
      OffsetDefault offsetType,
      double referencePosition = 0.5,
      bool negate = false,
    }) {
      Offset position;
      switch (offsetType) {
        case OffsetDefault.topLeft:
          position = const Offset(0, 0);
          break;
        case OffsetDefault.bottomRight:
          position = const Offset(1000, 500);
          break;
        case OffsetDefault.center:
          position = const Offset(500, 250);
          break;
      }
      final calculator = RangeParallaxFactorCalculator(
        width: 1000,
        height: 500,
        referencePosition: ReferencePosition(
          referencePosition,
          referencePosition,
        ),
        position: position,
        negative: negate,
      );
      return calculator;
    }

    test('Center is 0', () {
      final calculator = getBasicCalculator(offsetType: OffsetDefault.center);
      final result = calculator.calculate();
      expect(result.x, 0);
    });
    test('Left is 1', () {
      final calculator = getBasicCalculator(offsetType: OffsetDefault.topLeft);

      final result = calculator.calculate();
      expect(result.x, 1);
    });
    test('Right is -1', () {
      final calculator =
          getBasicCalculator(offsetType: OffsetDefault.bottomRight);
      final result = calculator.calculate();
      expect(result.x, -1);
    });
    test('Negation Mirrors Values', () {
      final leftCalculator = getBasicCalculator(
        offsetType: OffsetDefault.topLeft,
        negate: true,
      );
      final rightCalculator = getBasicCalculator(
        offsetType: OffsetDefault.bottomRight,
        negate: true,
      );
      final leftResult = leftCalculator.calculate();
      final rightResult = rightCalculator.calculate();
      expect(leftResult.x, -1);
      expect(rightResult.x, 1);
    });

    test('Reference Position alters values', () {
      final calculator = getBasicCalculator(
        offsetType: OffsetDefault.topLeft,
        negate: true,
        referencePosition: 0,
      );
      final result = calculator.calculate();

      expect(result.x, 0);
      final calculator2 = getBasicCalculator(
        offsetType: OffsetDefault.bottomRight,
        negate: true,
        referencePosition: 0,
      );
      final result2 = calculator2.calculate();

      expect(result2.x, 2);
    });
  });
}
