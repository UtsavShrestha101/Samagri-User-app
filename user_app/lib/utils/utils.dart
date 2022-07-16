import 'package:intl/intl.dart';

class Utils {
  String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);
    return "$date $time";
  }

  String customDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    // final time = DateFormat.Hm().format(dateTime);
    return "$date";
  }

  String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return "$time";
  }
}
