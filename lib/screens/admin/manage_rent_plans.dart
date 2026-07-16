import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';

class ManageRentPlansScreen extends StatefulWidget {
  final String hostelId;
  final String hostelName;

  const ManageRentPlansScreen({
    super.key,
    required this.hostelId,
    required this.hostelName,
  });

  @override
  State<ManageRentPlansScreen> createState() => _ManageRentPlansScreenState();
}

class _ManageRentPlansScreenState extends State<ManageRentPlansScreen> {
  List<Map<String, dynamic>> _plans = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      var plans = await adminService.fetchRentPlans(widget.hostelId);
      if (plans.isEmpty) {
        await adminService.seedHostelDefaults(widget.hostelId);
        plans = await adminService.fetchRentPlans(widget.hostelId);
      }
      if (!mounted) return;
      setState(() {
        _plans = plans;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _edit([Map<String, dynamic>? plan]) async {
    final label = TextEditingController(text: plan?['label']?.toString() ?? '');
    final amount = TextEditingController(
      text: plan?['amount'] != null
          ? (plan!['amount'] as num).toStringAsFixed(0)
          : '',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plan == null ? 'Add rent plan' : 'Edit rent plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: label,
              decoration: const InputDecoration(
                labelText: 'Label (e.g. 2 Share)',
              ),
            ),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly amount (₹)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(Strings.saveChanges),
          ),
        ],
      ),
    );

    if (saved != true) return;
    final parsed = double.tryParse(amount.text.trim());
    if (label.text.trim().isEmpty || parsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid label and amount')),
      );
      return;
    }

    try {
      await adminService.upsertRentPlan(
        id: plan?['id']?.toString(),
        hostelId: widget.hostelId,
        label: label.text.trim(),
        amount: parsed,
        sortOrder: plan?['sort_order'] as int? ?? (_plans.length + 1),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _delete(String id) async {
    await adminService.deleteRentPlan(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          Strings.manageRentPlans,
          style: TextStyle(
            color: AppColors.white,
            fontSize: fontSize(context) * 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _edit(),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: EdgeInsets.all(width(context) * 16),
                children: [
                  Text(
                    widget.hostelName,
                    style: TextStyle(
                      color: AppColors.bodyText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: height(context) * 12),
                  if (_plans.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(child: Text(Strings.noData)),
                    )
                  else
                    ..._plans.map((plan) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: height(context) * 8),
                        child: ListTile(
                          tileColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(plan['label']?.toString() ?? ''),
                          subtitle: Text(
                            '₹${(plan['amount'] as num?)?.toStringAsFixed(0) ?? '0'}/month',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _edit(plan),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.red,
                                ),
                                onPressed: () =>
                                    _delete(plan['id']?.toString() ?? ''),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
