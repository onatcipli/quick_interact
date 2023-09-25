import 'package:flutter_test/flutter_test.dart';
import 'package:quick_interact/quick_interact.dart';


void main() {
  group('QuickInteractConfig', () {
    test('default values', () {
      const config = QuickInteractConfig();
      expect(config.widgetSize, 35);
      expect(config.widgetPadding, 4);
      // Add more assertions for the rest of the default values
    });
  });
}
