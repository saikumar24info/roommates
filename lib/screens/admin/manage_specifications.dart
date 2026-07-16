import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/hostel_specification.dart';
import 'package:room_mates/services/specification_service.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';

class ManageSpecificationsScreen extends StatefulWidget {
  final String hostelId;

  const ManageSpecificationsScreen({super.key, required this.hostelId});

  @override
  State<ManageSpecificationsScreen> createState() =>
      _ManageSpecificationsScreenState();
}

class _ManageSpecificationsScreenState
    extends State<ManageSpecificationsScreen> {
  List<HostelSpecification> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items =
        await specificationService.fetchAllForHostel(widget.hostelId);
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _edit([HostelSpecification? item]) async {
    final title = TextEditingController(text: item?.title ?? '');
    final desc = TextEditingController(text: item?.description ?? '');
    var iconKey = item?.iconKey ?? 'wifi';
    var enabled = item?.isEnabled ?? true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModal) => AlertDialog(
          title: Text(item == null ? 'Add amenity' : 'Edit amenity'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: desc,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: iconKey,
                  decoration: const InputDecoration(labelText: 'Icon'),
                  items: SpecificationService.iconKeys
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setModal(() => iconKey = v);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Enabled'),
                  value: enabled,
                  onChanged: (v) => setModal(() => enabled = v),
                ),
              ],
            ),
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
      ),
    );

    if (saved != true) return;
    try {
      await specificationService.upsertSpecification(
        id: item?.id,
        hostelId: widget.hostelId,
        title: title.text.trim(),
        description: desc.text.trim(),
        iconKey: iconKey,
        sortOrder: item?.sortOrder ?? (_items.length + 1),
        isEnabled: enabled,
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
          Strings.manageSpecifications,
          style: TextStyle(color: AppColors.white, fontSize: fontSize(context) * 18),
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
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: EdgeInsets.all(width(context) * 16),
                itemCount: _items.length,
                separatorBuilder: (_, __) => SizedBox(height: height(context) * 8),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    tileColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Image.asset(
                      SpecificationService.iconAssetForKey(item.iconKey),
                      height: 28,
                      color: AppColors.primary,
                    ),
                    title: Text(item.title),
                    subtitle: Text(
                      item.isEnabled ? item.description : 'Disabled',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _edit(item),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
