import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'model/poll_card.dart';
import 'model/poll_option.dart';
class PollsScreen extends StatefulWidget {
  const PollsScreen({super.key});

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  // Dynamic list of polls
  final List<Poll> _polls = [
    Poll(
      question: "Should we install CCTV cameras in all common areas?",
      status: "Active",
      totalVotes: 47,
      timeRemaining: "3 days left",
      options: [
        PollOption(title: "Yes, install immediately", percentage: 0.62),
        PollOption(title: "Only at entry/exit points", percentage: 0.28),
        PollOption(title: "No, not needed", percentage: 0.10),
      ],
    ),
    Poll(
      question: "Best time for society maintenance work?",
      status: "Active",
      totalVotes: 83,
      timeRemaining: "1 day left",
      options: [
        PollOption(title: "Morning (7-10 AM)", percentage: 0.45),
        PollOption(title: "Afternoon (12-3 PM)", percentage: 0.35),
        PollOption(title: "Evening (5-8 PM)", percentage: 0.20),
      ],
      hasVoted: true,
      selectedOptionIndex: 1, // Represents "Afternoon"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F0),
      appBar: AppBar(title: const Text("Polls & Voting"), backgroundColor: const Color(0xFF0F2D52)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _polls.length,
        itemBuilder: (context, index) => PollCard(
          poll: _polls[index],
          onVote: () => setState(() => _polls[index].hasVoted = true),
          onOptionSelected: (i) => setState(() => _polls[index].selectedOptionIndex = i),
        ),
      ),
    );
  }
}