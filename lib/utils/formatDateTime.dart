import 'package:intl/intl.dart';

DateTime convertUtcToLocal(DateTime utc) {
  DateTime myLocal = utc.toLocal();
  return myLocal;
}

String formatDateTime(DateTime date, {String? format}) {
  String formattedDate = "";
  if (format != null) {
    formattedDate = DateFormat(format).format(date);
  } else {
    formattedDate = DateFormat.yMMMd().format(date);
  }
  return formattedDate;
}

String timeAgoSinceDate(DateTime date, {bool numericDates = true}) {
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} years ago';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numericDates) ? '1 year ago' : 'Last year';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} months ago';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numericDates) ? '1 month ago' : 'Last month';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? '1 week ago' : 'Last week';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? '1 day ago' : 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? '1 hour ago' : 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inSeconds >= 3) {
    // return '${difference.inSeconds} seconds ago';
    return 'Just now';
  } else {
    return 'Just now';
  }
}

String chatDate(DateTime date, {bool numericDates = true}) {
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} years ago';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numericDates) ? '1 year ago' : 'Last year';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} months ago';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numericDates) ? '1 month ago' : 'Last month';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? '1 week ago' : 'Last week';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    // return (numericDates) ? '1 day ago' : 'Yesterday';
    return 'Yesterday, ${formatDateTime(date, format: "H:mm")}';
  } else if (difference.inHours >= 2) {
    // return '${difference.inHours} hours ago';
    return formatDateTime(date, format: "H:mm");
  } else if (difference.inHours >= 1) {
    return (numericDates)
        ? formatDateTime(date, format: "H:mm")
        : 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return (numericDates)
        ? formatDateTime(date, format: "H:mm")
        : '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return (numericDates)
        ? formatDateTime(date, format: "H:mm")
        : 'A minute ago';
  } else if (difference.inSeconds >= 3) {
    return (numericDates)
        ? formatDateTime(date, format: "H:mm")
        : '${difference.inSeconds} seconds ago';
  } else {
    return 'Just now';
  }
}

String formatTimerTime(int second) {
  int minutes = second ~/ 60;
  int seconds = second % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
