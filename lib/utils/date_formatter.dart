import 'package:intl/intl.dart';

String dateFormatted() {
  var date = new DateTime.now();
  var format = new DateFormat("dd/MM/yyyy");
  return format.format(date);
}
