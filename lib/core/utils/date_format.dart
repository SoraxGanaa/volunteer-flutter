import 'package:intl/intl.dart';

class DateFormatUtil {
  static final _date = DateFormat('yyyy-MM-dd');
  static final _time = DateFormat('HH:mm');

  static String date(DateTime d) => _date.format(d);
  static String time(DateTime d) => _time.format(d);
  static String timeRange(DateTime s, DateTime e) => '${time(s)} - ${time(e)}';
}
