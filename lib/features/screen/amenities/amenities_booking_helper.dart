import 'package:flutter/material.dart';

class AmenitiesBookingHelper {
  static void showBookingModal(BuildContext context, String amenityName) {
    DateTime? startDate;
    DateTime? endDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    final TextEditingController purposeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          // Use Padding with bottom viewInsets to ensure keyboard doesn't cover input
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text("Book $amenityName", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 20),

                  // 1. Date Range
                  const Text("Select Dates", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _dateInput("From", startDate, () async {
                      DateTime? d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2027));
                      if (d != null) setModalState(() => startDate = d);
                    })),
                    const SizedBox(width: 10),
                    Expanded(child: _dateInput("To", endDate, () async {
                      DateTime? d = await showDatePicker(context: context, initialDate: startDate ?? DateTime.now(), firstDate: startDate ?? DateTime.now(), lastDate: DateTime(2027));
                      if (d != null) setModalState(() => endDate = d);
                    })),
                  ]),

                  const SizedBox(height: 20),

                  // 2. Time Range
                  const Text("Select Time", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _timeInput("Start", startTime, () async {
                      TimeOfDay? t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (t != null) setModalState(() => startTime = t);
                    })),
                    const SizedBox(width: 10),
                    Expanded(child: _timeInput("End", endTime, () async {
                      TimeOfDay? t = await showTimePicker(context: context, initialTime: startTime ?? TimeOfDay.now());
                      if (t != null) setModalState(() => endTime = t);
                    })),
                  ]),

                  const SizedBox(height: 20),

                  // 3. Purpose
                  const Text("Booking Purpose", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: purposeController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: "Enter purpose (e.g., Birthday Party)",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 4. Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C2CB),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: (startDate != null && endDate != null && startTime != null && endTime != null)
                          ? () {
                        // Perform your API call here using:
                        // startDate, endDate, startTime, endTime, purposeController.text
                        Navigator.pop(context);
                      }
                          : null,
                      child: const Text("CONFIRM BOOKING", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static Widget _dateInput(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: InputDecorator(decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()), child: Text(date == null ? "Select" : "${date.day}/${date.month}/${date.year}")));
  }

  static Widget _timeInput(String label, TimeOfDay? time, VoidCallback onTap) {
    return InkWell(onTap: onTap, child: InputDecorator(decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()), child: Text(time == null ? "Select" : "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}")));
  }
}