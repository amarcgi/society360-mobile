class PollOption {
  final String title;
  final double percentage;
  PollOption({required this.title, required this.percentage});
}

class Poll {
  final String question;
  final String status;
  final int totalVotes;
  final String timeRemaining;
  final List<PollOption> options;
  bool hasVoted;
  int? selectedOptionIndex;

  Poll({
    required this.question, required this.status, required this.totalVotes,
    required this.timeRemaining, required this.options,
    this.hasVoted = false, this.selectedOptionIndex,
  });
}