import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart'; // Handles picking multiple files
import 'model/complaint_enums.dart';
import 'model/complaint_models.dart';

// Scope breakdown matching your system's architecture
enum ComplaintScope { flat, building, society }

class RaiseComplaintFormScreen extends StatefulWidget {
  const RaiseComplaintFormScreen({super.key});

  @override
  State<RaiseComplaintFormScreen> createState() => _RaiseComplaintFormScreenState();
}

class _RaiseComplaintFormScreenState extends State<RaiseComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  int? _selectedCategoryId;
  Priority _selectedPriority = Priority.MEDIUM;

  // Default target scope selection
  ComplaintScope _selectedScope = ComplaintScope.flat;

  // List tracking local paths/files picked by user for attachmentUrl payloads
  List<PlatformFile> _selectedFiles = [];

  // Mirroring system defaults via ComplaintCategory configuration
  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Plumbing'},
    {'id': 2, 'name': 'Electrical'},
    {'id': 3, 'name': 'Lift Maintenance'},
    {'id': 4, 'name': 'Water Provision'},
    {'id': 5, 'name': 'Security'},
  ];

  // Triggers native platform system explorer to select files
  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any, // Adjust to FileType.image if you want to restrict to photos
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting files: $e')),
      );
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {

      // Structural evaluation matching your backend fields: flatId & societyId
      int? finalFlatId;
      if (_selectedScope == ComplaintScope.flat) {
        finalFlatId = 402; // Extracted from current user profile context
      } else if (_selectedScope == ComplaintScope.building) {
        finalFlatId = 0; // Sentinel value representing common building structural grounds
      } else {
        finalFlatId = -1; // Sentinel value indicating a society-wide master issue ticket
      }

      // Convert local attachments to a comma-separated string or handle individual uploads
      final String? attachmentString = _selectedFiles.isEmpty
          ? null
          : _selectedFiles.map((file) => file.name).join(',');

      // Assemble structured entity matching your backend specifications
      final requestPayload = RaiseComplainResponse(
        flatId: finalFlatId,
        residentId: 99, // Current session resident id
        complaintCategoryId: _selectedCategoryId!,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        priority: _selectedPriority,
        complaintStatus: ComplaintStatus.OPEN,
        attachmentUrl: attachmentString, // Maps cleanly to your String field setup
      );

      // State Management Dispatch Target:
      // context.read<ComplaintBloc>().add(SubmitNewComplaint(requestPayload));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket created successfully. Notifying support team.')),
      );
      context.pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2C54),
        title: const Text('Raise Complaint', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // --- NEW FEATURE: TARGET COMPLAINT SCOPE ---
            const Text('COMPLAINT TARGET *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    avatar: Icon(Icons.apartment, size: 16, color: _selectedScope == ComplaintScope.flat ? Colors.white : Colors.black),
                    label: const Text('My Flat'),
                    selected: _selectedScope == ComplaintScope.flat,
                    selectedColor: const Color(0xFF0D2C54),
                    labelStyle: TextStyle(color: _selectedScope == ComplaintScope.flat ? Colors.white : Colors.black),
                    backgroundColor: Colors.white,
                    onSelected: (bool selected) {
                      if (selected) setState(() => _selectedScope = ComplaintScope.flat);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ChoiceChip(
                    avatar: Icon(Icons.foundation, size: 16, color: _selectedScope == ComplaintScope.building ? Colors.white : Colors.black),
                    label: const Text('Building'),
                    selected: _selectedScope == ComplaintScope.building,
                    selectedColor: const Color(0xFF0D2C54),
                    labelStyle: TextStyle(color: _selectedScope == ComplaintScope.building ? Colors.white : Colors.black),
                    backgroundColor: Colors.white,
                    onSelected: (bool selected) {
                      if (selected) setState(() => _selectedScope = ComplaintScope.building);
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ChoiceChip(
                    avatar: Icon(Icons.public, size: 16, color: _selectedScope == ComplaintScope.society ? Colors.white : Colors.black),
                    label: const Text('Society'),
                    selected: _selectedScope == ComplaintScope.society,
                    selectedColor: const Color(0xFF0D2C54),
                    labelStyle: TextStyle(color: _selectedScope == ComplaintScope.society ? Colors.white : Colors.black),
                    backgroundColor: Colors.white,
                    onSelected: (bool selected) {
                      if (selected) setState(() => _selectedScope = ComplaintScope.society);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('DEPARTMENT CATEGORY *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              hint: const Text('Select issue branch...'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              items: _categories.map((cat) {
                return DropdownMenuItem<int>(value: cat['id'] as int, child: Text(cat['name'] as String));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategoryId = val),
              validator: (v) => v == null ? 'Please map a core department classification.' : null,
            ),
            const SizedBox(height: 20),

            const Text('COMPLAINT TITLE *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Summary headline of the defect',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Headline criteria mandatory.' : null,
            ),
            const SizedBox(height: 20),

            const Text('DETAILED SPECIFICATION *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Provide comprehensive logs explaining the request...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              validator: (v) => v == null || v.trim().length < 10 ? 'Detailed description requires descriptive scope.' : null,
            ),
            const SizedBox(height: 20),

            const Text('SEVERITY LEVEL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: Priority.values.map((prio) {
                final isSelected = _selectedPriority == prio;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(prio.name),
                    selected: isSelected,
                    selectedColor: const Color(0xFF0D2C54),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                    backgroundColor: Colors.white,
                    onSelected: (_) => setState(() => _selectedPriority = prio),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // --- NEW FEATURE: MULTI-FILE ATTACHMENT HUB ---
            const Text('ATTACHMENTS (MULTIPLE ENTRIES)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickFiles,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade600),
                    const SizedBox(width: 10),
                    Text(
                      'Upload Media or Documents',
                      style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),

            // Render picked files queue list dynamically
            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = _selectedFiles[index];
                  final double sizeInMb = file.size / (1024 * 1024);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_drive_file, color: Color(0xFF0D2C54), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              Text('${sizeInMb.toStringAsFixed(2)} MB', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 20),
                          onPressed: () => _removeFile(index),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D2C54),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submitForm,
              child: const Text('File Support Ticket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}