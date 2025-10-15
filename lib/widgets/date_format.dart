import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String formatDate(String createdAt) {
  DateTime dateTime = DateTime.parse(createdAt).toLocal();
  return timeago.format(dateTime);
}

String formatDateWithTime(String createdAt) {
  DateTime dateTime = DateTime.parse(createdAt).toLocal();

  String formattedDate = DateFormat('d MMM yyyy | hh:mm').format(dateTime);

  return '$formattedDate UST';
}
