class StringUtils {
  static final List<String> month = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String stopWatch(DateTime? datetime) {
    if (datetime != null) {
      return '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}:${datetime.second.toString().padLeft(2, '0')}';
    }
    return '-';
  }

  static String stopWatchSubtract(DateTime? datetime2, DateTime? datetime1) {
    if (datetime1 != null && datetime2 != null) {
      var tempDate = ((datetime2).subtract(Duration(
          hours: datetime1.hour,
          minutes: datetime1.minute,
          seconds: datetime1.second)));

      return '${tempDate.hour.toString().padLeft(2, '0')}:${tempDate.minute.toString().padLeft(2, '0')}:${tempDate.second.toString().padLeft(2, '0')}';
    }
    return '-';
  }

  static String dayMonthYear(DateTime? datetime) {
    if (datetime != null) {
      return '${datetime.day} ${month[datetime.month - 1]} ${datetime.year}';
    }
    return '-';
  }
}
