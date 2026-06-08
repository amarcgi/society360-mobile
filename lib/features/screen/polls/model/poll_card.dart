import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:society360_app/features/screen/polls/model/poll_option.dart';
class PollCard extends StatelessWidget {
  final Poll poll;
  final VoidCallback onVote;
  final Function(int) onOptionSelected;

  const PollCard({super.key, required this.poll, required this.onVote, required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text(poll.question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)),
              child: Text(poll.status, style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold))),
        ]),
        Row(children: [
          Icon(Icons.people, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Text("${poll.totalVotes} votes", style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 12),
          Icon(Icons.access_time, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Text(poll.timeRemaining, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ]),
        const SizedBox(height: 16),

        // Options List
        ...List.generate(poll.options.length, (i) => _buildOptionRow(i)),

        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("${poll.totalVotes} of 120 residents voted", style: const TextStyle(fontSize: 12)),
          poll.hasVoted
              ? _buildVotedChip()
              : OutlinedButton(onPressed: onVote, child: const Text("Cast Vote")),
        ]),
      ]),
    );
  }

  Widget _buildOptionRow(int index) {
    final opt = poll.options[index];
    bool isSelected = poll.selectedOptionIndex == index;
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(children: [
      Row(children: [
        Radio(value: index, groupValue: poll.selectedOptionIndex, onChanged: poll.hasVoted ? null : (v) => onOptionSelected(index)),
        Expanded(child: Text(opt.title)),
        Text("${(opt.percentage * 100).toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
      ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: opt.percentage, minHeight: 6, color: const Color(0xFF0F2D52))),
    ]));
  }

  Widget _buildVotedChip() => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(20)),
      child: const Row(children: [Icon(Icons.check, size: 16, color: Colors.teal), Text(" You voted", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold))]));
}