import 'package:intl/intl.dart';

List<String> getMonths() {
  final months = <String>[];
  final now = DateTime.now();
  final year = now.year;
  final startDate = DateTime(year, 1);

  // Generate a list of 12 dates, one for each month of the year
  final dates = List.generate(12, (index) => DateTime(year, index + 1));

  // Format each date as a month string
  final formatter = DateFormat.MMMM();
  for (final date in dates) {
    final monthString = formatter.format(date);
    months.add(monthString);
  }

  return months;
}