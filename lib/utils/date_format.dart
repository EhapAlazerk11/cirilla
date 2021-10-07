import 'package:intl/intl.dart';

String formatDate({required String date, String dateFormat = 'MMMM d, y', String locate = 'en_US'}) {
  DateTime _date = DateTime.parse(date);
  return DateFormat(dateFormat, 'en_US').format(_date);
}

bool compareSpaceDate({required String date, int space = 30}) {
  DateTime _dateNow = DateTime.now();
  DateTime _date = DateTime.parse(date).add(Duration(days: space));
  return !_dateNow.isAfter(_date);
}

String? formatPosition({Duration? position}) {
  return RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch(position.toString())?.group(1);
}
