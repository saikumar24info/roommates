import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';

class ManageFoodMenuScreen extends StatefulWidget {
  final String hostelId;
  final String hostelName;

  const ManageFoodMenuScreen({
    super.key,
    required this.hostelId,
    required this.hostelName,
  });

  @override
  State<ManageFoodMenuScreen> createState() => _ManageFoodMenuScreenState();
}

class _ManageFoodMenuScreenState extends State<ManageFoodMenuScreen> {
  static const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Map<String, dynamic> _menu = {};
  String _selectedDay = 'Monday';
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await adminService.fetchFoodMenu(widget.hostelId);
    setState(() {
      _menu = data != null ? Map<String, dynamic>.from(data) : {};
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _meals {
    final raw = _menu[_selectedDay];
    if (raw is! List) return [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> _editMeal(int index) async {
    final meal = Map<String, dynamic>.from(_meals[index]);
    final title = TextEditingController(text: meal['title']?.toString() ?? '');
    final desc =
        TextEditingController(text: meal['description']?.toString() ?? '');
    var isVeg = meal['isVeg'] == true;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModal) => AlertDialog(
          title: Text('${meal['time'] ?? 'Meal'} · $_selectedDay'),
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
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Vegetarian'),
                  value: isVeg,
                  onChanged: (v) => setModal(() => isVeg = v),
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

    if (saved == true) {
      final updated = List<Map<String, dynamic>>.from(_meals);
      updated[index] = {
        ...meal,
        'title': title.text.trim(),
        'description': desc.text.trim(),
        'isVeg': isVeg,
      };
      setState(() => _menu[_selectedDay] = updated);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await adminService.saveFoodMenu(
        hostelId: widget.hostelId,
        menuData: _menu,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.savedSuccessfully)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          Strings.manageFoodMenu,
          style: TextStyle(color: AppColors.white, fontSize: fontSize(context) * 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(
              _saving ? '...' : 'Save',
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(width(context) * 12),
                  child: Text(
                    widget.hostelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodyText,
                    ),
                  ),
                ),
                SizedBox(
                  height: height(context) * 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: width(context) * 12),
                    itemCount: days.length,
                    separatorBuilder: (_, __) => SizedBox(width: width(context) * 8),
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final selected = day == _selectedDay;
                      return ChoiceChip(
                        label: Text(day.substring(0, 3)),
                        selected: selected,
                        selectedColor: AppColors.primarySoft,
                        onSelected: (_) => setState(() => _selectedDay = day),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _meals.isEmpty
                      ? const Center(child: Text(Strings.noData))
                      : ListView.separated(
                          padding: EdgeInsets.all(width(context) * 16),
                          itemCount: _meals.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: height(context) * 10),
                          itemBuilder: (context, index) {
                            final meal = _meals[index];
                            return ListTile(
                              tileColor: AppColors.surface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: Text(
                                '${meal['time'] ?? ''} · ${meal['title'] ?? ''}',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(meal['description']?.toString() ?? ''),
                              trailing: const Icon(Icons.edit_outlined),
                              onTap: () => _editMeal(index),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
