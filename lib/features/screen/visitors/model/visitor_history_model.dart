
// --- Dynamic Data Model ---
class VisitorHistoryModel {
  final String name;
  final String logDetails;
  final String state; // e.g., "Out", "Inside"
  final DateTime dateTime;

  const VisitorHistoryModel({
    required this.name,
    required this.logDetails,
    required this.state,
    required this.dateTime,
  });
}
