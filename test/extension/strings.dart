// This test extension String
//

import 'package:flutter_test/flutter_test.dart';

import 'package:cirilla/extension/strings.dart';

void main() {
  group('extension - removeSymbols', () {
    test('value should be return symbols', () {
      expect('@423234!ABCBC'.removeSymbols, '423234ABCBC');
    });
  });
}
