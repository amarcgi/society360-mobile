class Announcement {
  final String title;
  final String description;
  final String postedBy;
  final String date;
  final String type; // 'Urgent', 'Event', 'Notice'

  Announcement({
    required this.title,
    required this.description,
    required this.postedBy,
    required this.date,
    required this.type
  });
}