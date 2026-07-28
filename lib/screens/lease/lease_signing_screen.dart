import 'package:flutter/material.dart';
import '../../models/lease.dart';
import '../../models/lease_status.dart';
import '../../services/lease_service.dart';
import 'package:file_picker/file_picker.dart';

class LeaseSigningScreen extends StatefulWidget {
  final Lease lease;

  const LeaseSigningScreen({super.key, required this.lease});

  @override
  State<LeaseSigningScreen> createState() => _LeaseSigningScreenState();
}

class _LeaseSigningScreenState extends State<LeaseSigningScreen> {
  bool _isUploading = false;
  String? _fileName;
  final _leaseService = LeaseService();

  Future<void> _pickAndUploadLease() async {
    // Correct API call for modern file_picker versions (like 11.0.2)
    // The library uses a static method directly on the class.
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _isUploading = true;
        _fileName = result.files.first.name;
      });

      try {
        // TODO: In a production app, upload file to Firebase Storage first
        const String mockDownloadUrl = "https://firebasestorage.googleapis.com/v0/b/kejah/o/leases/signed_lease.pdf";

        // Update Lease in Firestore
        final updatedLease = widget.lease.copyWith(
          status: LeaseStatus.active,
          isSigned: true,
          signedAgreementUrl: mockDownloadUrl,
        );

        await _leaseService.updateLease(updatedLease);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lease signed and uploaded successfully!")),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Error: $e")));
        }
      } finally {
        if (mounted) setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text("Lease Agreement")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description_outlined, size: 80, color: Colors.indigo),
            const SizedBox(height: 24),
            Text(
              "Sign Your Lease",
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your application has been approved! Please download the agreement, sign it, and upload a scanned PDF copy below.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  _leaseDetailRow("Lease No", widget.lease.leaseNumber),
                  _leaseDetailRow("Rent", "KES ${widget.lease.monthlyRent}"),
                  _leaseDetailRow("Deposit", "KES ${widget.lease.deposit}"),
                ],
              ),
            ),
            const SizedBox(height: 40),
            if (_isUploading)
              const CircularProgressIndicator()
            else ...[
              ElevatedButton.icon(
                onPressed: _pickAndUploadLease,
                icon: const Icon(Icons.upload_file),
                label: const Text("UPLOAD SIGNED PDF"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
              if (_fileName != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text("Selected: $_fileName", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _leaseDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
        ],
      ),
    );
  }
}
