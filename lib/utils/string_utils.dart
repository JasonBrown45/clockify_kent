import 'package:intl/intl.dart';

class StringUtils {
  static String stopWatch(DateTime? datetime) {
    if (datetime != null) {
      var formatTime = DateFormat('HH:mm:ss');
      String formattedTime = formatTime.format(datetime);
      return formattedTime;
    }
    return '-';
  }

  static String stopWatchSubtract(DateTime? datetime2, DateTime? datetime1) {
    if (datetime1 != null && datetime2 != null) {
      var tempDate = ((datetime2).subtract(Duration(
          hours: datetime1.hour,
          minutes: datetime1.minute,
          seconds: datetime1.second)));
      var formatTime = DateFormat('HH:mm:ss');
      String formattedTime = formatTime.format(tempDate);
      return formattedTime;
    }
    return '-';
  }

  static String dayMonthYear2Digit(DateTime? datetime) {
    if (datetime != null) {
      var formatTime = DateFormat('dd MMM yy');
      String formattedTime = formatTime.format(datetime);
      return formattedTime;
    }
    return '-';
  }

  static String dayMonthYear(DateTime? datetime) {
    if (datetime != null) {
      var formatTime = DateFormat('dd MMM yyyy');
      String formattedTime = formatTime.format(datetime);
      return formattedTime;
    }
    return '-';
  }
}
