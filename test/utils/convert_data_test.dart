// This test utility convert data
//

import 'package:flutter_test/flutter_test.dart';

import 'package:cirilla/utils/convert_data.dart';

void main() {
  group('ConvertData - stringToDouble', () {
    test('value should be return default with empty string', () {
      expect(ConvertData.stringToDouble(''), 0);
    });

    test('value should be return default value with empty string', () {
      expect(ConvertData.stringToDouble('', 1), 1);
    });

    test('value should be return default with any data', () {
      Map data1 = {'test': 1};
      expect(ConvertData.stringToDouble(data1), 0);

      Map data2 = {};
      expect(ConvertData.stringToDouble(data2), 0);

      List data3 = [];
      expect(ConvertData.stringToDouble(data3), 0);

      List data4 = [1];
      expect(ConvertData.stringToDouble(data4), 0);
    });

    test('value should be return default with any data', () {
      Map data1 = {'test': 1};
      expect(ConvertData.stringToDouble(data1, 0), 0);

      Map data2 = {};
      expect(ConvertData.stringToDouble(data2, 1), 1);

      List data3 = [];
      expect(ConvertData.stringToDouble(data3, 2), 2);

      List data4 = [1];
      expect(ConvertData.stringToDouble(data4, 3), 3);
    });

    test('value should be convert from String', () {
      String data1 = '-1';
      expect(ConvertData.stringToDouble(data1, 0), -1);

      String data2 = '0';
      expect(ConvertData.stringToDouble(data2, 1), 0);

      String data3 = '1';
      expect(ConvertData.stringToDouble(data3, 2), 1);

      String data4 = '111111';
      expect(ConvertData.stringToDouble(data4, 3), 111111);
    });

    test('value should be convert from int', () {
      int data1 = 1;
      expect(ConvertData.stringToDoubleCanBeNull(data1), 1);

      int data2 = 1;
      expect(ConvertData.stringToDoubleCanBeNull(data2).runtimeType, double);
    });

    test('value should be convert from double', () {
      double data1 = 1.1;
      expect(ConvertData.stringToDoubleCanBeNull(data1), 1.1);
    });

  });
  group('ConvertData - stringToDoubleCanBeNull', () {
    test('value should be return null with empty string', () {
      expect(ConvertData.stringToDoubleCanBeNull(''), null);
    });

    test('value should be return default value with empty string', () {
      expect(ConvertData.stringToDoubleCanBeNull('', 0), 0);
    });

    test('value should be return null with any data', () {
      Map data1 = {'test': 1};
      expect(ConvertData.stringToDoubleCanBeNull(data1), null);

      Map data2 = {};
      expect(ConvertData.stringToDoubleCanBeNull(data2), null);

      List data3 = [];
      expect(ConvertData.stringToDoubleCanBeNull(data3), null);

      List data4 = [1];
      expect(ConvertData.stringToDoubleCanBeNull(data4), null);
    });

    test('value should be return default with any data', () {
      Map data1 = {'test': 1};
      expect(ConvertData.stringToDoubleCanBeNull(data1, 0), 0);

      Map data2 = {};
      expect(ConvertData.stringToDoubleCanBeNull(data2, 1), 1);

      List data3 = [];
      expect(ConvertData.stringToDoubleCanBeNull(data3, 2), 2);

      List data4 = [1];
      expect(ConvertData.stringToDoubleCanBeNull(data4, 3), 3);
    });

    test('value should be convert from String', () {
      String data1 = '-1';
      expect(ConvertData.stringToDoubleCanBeNull(data1, 0), -1);

      String data2 = '0';
      expect(ConvertData.stringToDoubleCanBeNull(data2, 1), 0);

      String data3 = '1';
      expect(ConvertData.stringToDoubleCanBeNull(data3, 2), 1);

      String data4 = '111111';
      expect(ConvertData.stringToDoubleCanBeNull(data4, 3), 111111);
    });

    test('value should be convert from int', () {
      int data1 = 1;
      expect(ConvertData.stringToDoubleCanBeNull(data1), 1);

      int data2 = 1;
      expect(ConvertData.stringToDoubleCanBeNull(data2).runtimeType, double);
    });

    test('value should be convert from double', () {
      double data1 = 1.1;
      expect(ConvertData.stringToDoubleCanBeNull(data1), 1.1);
    });

  });
}
