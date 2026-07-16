import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';

class ManageServiceRequestsScreen extends StatefulWidget {
  final String? hostelId;
  final String titleHostelName;

  const ManageServiceRequestsScreen({
    super.key,
    required this.hostelId,
    required this.titleHostelName,
  });

  @override
  State<ManageServiceRequestsScreen> createState() =>
      _ManageServiceRequestsScreenState();
}

class _ManageServiceRequestsScreenState
    extends State<ManageServiceRequestsScreen> {
  static const statuses = ['Open', 'In Progress', 'Resolved', 'Closed'];
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items =
          await adminService.fetchServiceRequests(hostelId: widget.hostelId);
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _items = [];
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    try {
      await adminService.updateServiceRequestStatus(
        requestId: id,
        status: status,
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          Strings.manageServiceRequests,
          style: TextStyle(color: AppColors.white, fontSize: fontSize(context) * 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(width(context) * 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.bodyText),
                        ),
                        SizedBox(height: height(context) * 12),
                        TextButton(
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
              onRefresh: _load,
              child: _items.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: height(context) * 120),
                        const Center(child: Text(Strings.noRequests)),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(width(context) * 16),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: height(context) * 10),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        final status = item['status']?.toString() ?? 'Open';
                        return Container(
                          padding: EdgeInsets.all(width(context) * 14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']?.toString() ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: height(context) * 4),
                              Text(
                                item['category']?.toString() ?? '',
                                style: const TextStyle(color: AppColors.primary),
                              ),
                              if ((item['description']?.toString() ?? '')
                                  .isNotEmpty) ...[
                                SizedBox(height: height(context) * 6),
                                Text(item['description'].toString()),
                              ],
                              SizedBox(height: height(context) * 10),
                              DropdownButtonFormField<String>(
                                // ignore: deprecated_member_use
                                value: statuses.contains(status)
                                    ? status
                                    : statuses.first,
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                  filled: true,
                                  fillColor: AppColors.background,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items: statuses
                                    .map((s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  _updateStatus(
                                    item['id']?.toString() ?? '',
                                    value,
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
