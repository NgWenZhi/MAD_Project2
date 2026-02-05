class SlotsDataService {
  static Map<String, Map<DateTime, Set<String>>> availability = {};

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static void saveAvailability(
    String doctorId,
    DateTime date,
    Set<String> slots,
  ) {
    final normalizedDate = _normalizeDate(date);

    availability.putIfAbsent(doctorId, () => {});
    availability[doctorId]![normalizedDate] = Set.from(slots);
  }

  static Set<String> getAvailability(
    String doctorId,
    DateTime date,
  ) {
    final normalizedDate = _normalizeDate(date);

    return availability[doctorId]?[normalizedDate] ?? {};
  }
}
