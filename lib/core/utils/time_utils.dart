import 'package:intl/intl.dart';

class TimeUtils {
  static String formatToAmPm(String time) {
  final parsedTime = DateFormat("HH:mm").parse(time);
  return DateFormat("hh:mm a").format(parsedTime);
}
}