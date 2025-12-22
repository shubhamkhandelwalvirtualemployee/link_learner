import 'package:intl/intl.dart';
import 'package:link_learner/presentation/instructor/model/weekly_available_model.dart';

List<AvailabilitySlot> generateHourlySlots(AvailabilitySlot original) {
  DateTime start = DateFormat("HH:mm").parse(original.startTime);
  DateTime end = DateFormat("HH:mm").parse(original.endTime);

  List<AvailabilitySlot> out = [];

  while (start.isBefore(end.add(const Duration(hours: 1)))) {
    DateTime next = start.add(const Duration(hours: 1));
    out.add(
      AvailabilitySlot(
        id: original.id,
        dayOfWeek: original.dayOfWeek,
        startTime: DateFormat("HH:mm").format(start),
        endTime: DateFormat("HH:mm").format(next),
      ),
    );
    start = next;
  }
  return out;
}
