import 'package:flutter/material.dart';
import '../../models/maintenance.dart';
import '../../models/maintenance_status.dart';
import '../../services/maintenance_service.dart';
import 'package:intl/intl.dart';

class MaintenanceDetailsScreen extends StatefulWidget {
  final Maintenance request;

  const MaintenanceDetailsScreen({
    super.key,
    required this.request,
  });

  @override
  State<MaintenanceDetailsScreen> createState() => _MaintenanceDetailsScreenState();
}

class _MaintenanceDetailsScreenState extends State<MaintenanceDetailsScreen> {
  final MaintenanceService _maintenanceService = MaintenanceService();
  late Maintenance _request;
  bool _isUpdating = false;
  final _actualCostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _request = widget.request;
    _actualCostController.text = _request.actualCost.toString();
  }

  Future<void> _updateStatus(MaintenanceStatus? status) async {
    if (status == null || status == _request.status) return;

    setState(() => _isUpdating = true);
    try {
      final actualCost = double.tryParse(_actualCostController.text) ?? 0;
      
      final updatedRequest = _request.copyWith(
        status: status,
        actualCost: actualCost,
        completedAt: status == MaintenanceStatus.completed ? DateTime.now() : null,
      );

      await _maintenanceService.updateRequest(updatedRequest);
      
      setState(() {
        _request = updatedRequest;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to ${status.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d, yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Request'),
                  content: const Text('Are you sure you want to delete this request?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              );

              if (confirm == true) {
                await _maintenanceService.deleteRequest(_request.id);
                if (mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: _isUpdating
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _request.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _statusBadge(_request.status),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'PRIORITY: ${_request.priority.name.toUpperCase()}',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_request.photos.isNotEmpty) ...[
                    const Text('Photos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _request.photos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(_request.photos[index], width: 200, height: 150, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(_request.description, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.calendar_today, 'Reported At', dateFormat.format(_request.reportedAt)),
                  _buildInfoRow(Icons.person_outline, 'Assigned To', _request.assignedTo.isEmpty ? 'Unassigned' : _request.assignedTo),
                  _buildInfoRow(Icons.attach_money, 'Estimated Cost', 'KES ${_request.estimatedCost}'),
                  if (_request.isCompleted && _request.completedAt != null)
                    _buildInfoRow(Icons.check_circle_outline, 'Completed At', dateFormat.format(_request.completedAt!)),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Workflow Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _actualCostController,
                    decoration: const InputDecoration(
                      labelText: 'Actual Cost (KES)',
                      border: OutlineInputBorder(),
                      prefixText: 'KES ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  const Text('Update Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<MaintenanceStatus>(
                    value: _request.status,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: MaintenanceStatus.values.map((s) {
                      return DropdownMenuItem(
                        value: s,
                        child: Text(s.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: _updateStatus,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(MaintenanceStatus status) {
    Color color;
    switch (status) {
      case MaintenanceStatus.reported: color = Colors.grey; break;
      case MaintenanceStatus.assigned: color = Colors.blue; break;
      case MaintenanceStatus.inProgress: color = Colors.orange; break;
      case MaintenanceStatus.completed: color = Colors.green; break;
      case MaintenanceStatus.cancelled: color = Colors.red; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(status.name.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
