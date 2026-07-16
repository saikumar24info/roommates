import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';

class ManageNotificationsScreen extends StatefulWidget {
  final String hostelId;

  const ManageNotificationsScreen({super.key, required this.hostelId});

  @override
  State<ManageNotificationsScreen> createState() =>
      _ManageNotificationsScreenState();
}

class _ManageNotificationsScreenState extends State<ManageNotificationsScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await adminService.fetchNotifications(widget.hostelId);
    if (!mounted) return;
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _compose([Map<String, dynamic>? item]) async {
    final title = TextEditingController(text: item?['title']?.toString() ?? '');
    final message =
        TextEditingController(text: item?['message']?.toString() ?? '');
    final imageUrl = TextEditingController(
      text: item?['image_url']?.toString() ??
          'https://picsum.photos/seed/hostel/400',
    );
    final time = TextEditingController(
      text: item?['time']?.toString() ??
          TimeOfDay.now().format(context),
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'New notification' : 'Edit notification'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: message,
                decoration: const InputDecoration(labelText: 'Message'),
                maxLines: 3,
              ),
              TextField(
                controller: imageUrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: time,
                decoration: const InputDecoration(labelText: 'Time label'),
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
    );

    if (saved != true) return;
    try {
      await adminService.upsertNotification(
        id: item?['id']?.toString() ??
            'n_${DateTime.now().millisecondsSinceEpoch}',
        hostelId: widget.hostelId,
        title: title.text.trim(),
        message: message.text.trim(),
        imageUrl: imageUrl.text.trim(),
        time: time.text.trim(),
      );
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _delete(String id) async {
    await adminService.deleteNotification(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          Strings.manageNotifications,
          style: TextStyle(color: AppColors.white, fontSize: fontSize(context) * 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _compose(),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load,
              child: _items.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: height(context) * 120),
                        const Center(child: Text(Strings.noNotifications)),
                      ],
                    )
                  : ListView.separated(
                      padding: EdgeInsets.all(width(context) * 16),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: height(context) * 8),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return ListTile(
                          tileColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(item['title']?.toString() ?? ''),
                          subtitle: Text(
                            item['message']?.toString() ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _compose(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppColors.red),
                                onPressed: () =>
                                    _delete(item['id']?.toString() ?? ''),
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
