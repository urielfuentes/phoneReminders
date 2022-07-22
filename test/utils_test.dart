import 'package:choresreminder/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Date Formatter Not Expired', () {
    test('Year', () {
      var date = DateTime.now().add(const Duration(days: 365));
      expect(getFormattedDate(date), equals('1 año.'));
    });

    test('Years', () {
      var date = DateTime.now().add(const Duration(days: 1460));
      expect(getFormattedDate(date), equals('4 años.'));
    });

    test('Year, month', () {
      var date = DateTime.now().add(const Duration(days: 395));
      expect(getFormattedDate(date), equals('1 año, 1 mes.'));
    });

    test('Years, months', () {
      var date = DateTime.now().add(const Duration(days: 1155));
      expect(getFormattedDate(date), equals('3 años, 2 meses.'));
    });

    test('Years, weeks', () {
      var date = DateTime.now().add(const Duration(days: 745));
      expect(getFormattedDate(date), equals('2 años, 2 semanas.'));
    });

    test('Year, day', () {
      var date = DateTime.now().add(const Duration(days: 366));
      expect(getFormattedDate(date), equals('1 año, 1 dia.'));
    });

    test('Month', () {
      var date = DateTime.now().add(const Duration(days: 30));
      expect(getFormattedDate(date), equals('1 mes.'));
    });

    test('Months', () {
      var date = DateTime.now().add(const Duration(days: 90));
      expect(getFormattedDate(date), equals('3 meses.'));
    });

    test('Months', () {
      var date = DateTime.now().add(const Duration(days: 120));
      expect(getFormattedDate(date), equals('4 meses.'));
    });

    test('Months, week', () {
      var date = DateTime.now().add(const Duration(days: 99));
      expect(getFormattedDate(date), equals('3 meses, 1 semana.'));
    });

    test('Months, days', () {
      var date = DateTime.now().add(const Duration(days: 95));
      expect(getFormattedDate(date), equals('3 meses, 5 dias.'));
    });

    test('Weeks', () {
      var date = DateTime.now().add(const Duration(days: 21));
      expect(getFormattedDate(date), equals('3 semanas.'));
    });

    test('Weeks, days', () {
      var date = DateTime.now().add(const Duration(days: 25));
      expect(getFormattedDate(date), equals('3 semanas, 4 dias.'));
    });

    test('Week, day', () {
      var date = DateTime.now().add(const Duration(days: 8));
      expect(getFormattedDate(date), equals('1 semana, 1 dia.'));
    });

    test('Days', () {
      var date = DateTime.now().add(const Duration(days: 4));
      expect(getFormattedDate(date), equals('4 dias.'));
    });

    test('Day', () {
      var date = DateTime.now().add(const Duration(days: 1));
      expect(getFormattedDate(date), equals('1 dia.'));
    });
  });

  group('Date Formatter Expired', () {
    test('Year', () {
      var date = DateTime.now().add(const Duration(days: -365));
      expect(getFormattedDate(date), equals('1 año.'));
    });

    test('Years', () {
      var date = DateTime.now().add(const Duration(days: -1460));
      expect(getFormattedDate(date), equals('4 años.'));
    });

    test('Year, month', () {
      var date = DateTime.now().add(const Duration(days: -395));
      expect(getFormattedDate(date), equals('1 año, 1 mes.'));
    });

    test('Years, months', () {
      var date = DateTime.now().add(const Duration(days: -1155));
      expect(getFormattedDate(date), equals('3 años, 2 meses.'));
    });

    test('Years, weeks', () {
      var date = DateTime.now().add(const Duration(days: -745));
      expect(getFormattedDate(date), equals('2 años, 2 semanas.'));
    });

    test('Year, day', () {
      var date = DateTime.now().add(const Duration(days: -366));
      expect(getFormattedDate(date), equals('1 año, 1 dia.'));
    });

    test('Month', () {
      var date = DateTime.now().add(const Duration(days: -30));
      expect(getFormattedDate(date), equals('1 mes.'));
    });

    test('Months', () {
      var date = DateTime.now().add(const Duration(days: -90));
      expect(getFormattedDate(date), equals('3 meses.'));
    });

    test('Months, week', () {
      var date = DateTime.now().add(const Duration(days: -99));
      expect(getFormattedDate(date), equals('3 meses, 1 semana.'));
    });

    test('Months, days', () {
      var date = DateTime.now().add(const Duration(days: -95));
      expect(getFormattedDate(date), equals('3 meses, 5 dias.'));
    });

    test('Weeks', () {
      var date = DateTime.now().add(const Duration(days: -21));
      expect(getFormattedDate(date), equals('3 semanas.'));
    });

    test('Weeks, days', () {
      var date = DateTime.now().add(const Duration(days: -25));
      expect(getFormattedDate(date), equals('3 semanas, 4 dias.'));
    });

    test('Week, day', () {
      var date = DateTime.now().add(const Duration(days: -8));
      expect(getFormattedDate(date), equals('1 semana, 1 dia.'));
    });

    test('Days', () {
      var date = DateTime.now().add(const Duration(days: -4));
      expect(getFormattedDate(date), equals('4 dias.'));
    });

    test('Day', () {
      var date = DateTime.now().add(const Duration(days: -1));
      expect(getFormattedDate(date), equals('1 dia.'));
    });

    test('DateTime.now()', () {
      var date = DateTime.now();
      expect(getFormattedDate(date), equals('Hoy.'));
    });
  });
}
