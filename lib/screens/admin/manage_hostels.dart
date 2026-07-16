import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/widgets/textinput.dart';

class ManageHostelsScreen extends StatefulWidget {
  const ManageHostelsScreen({super.key});

  @override
  State<ManageHostelsScreen> createState() => _ManageHostelsScreenState();
}

class _ManageHostelsScreenState extends State<ManageHostelsScreen> {
  List<Hostel> _hostels = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final hostels = await adminService.fetchAllHostels();
    if (!mounted) return;
    setState(() {
      _hostels = hostels;
      _loading = false;
    });
  }

  Future<void> _edit([Hostel? hostel]) async {
    final name = TextEditingController(text: hostel?.name ?? '');
    final address = TextEditingController(text: hostel?.address ?? '');
    final city = TextEditingController(text: hostel?.city ?? 'Hyderabad');
    final area = TextEditingController(text: hostel?.area ?? 'KPHB');

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hostel == null ? 'Add hostel' : 'Edit hostel'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInput(
                hintText: 'Name',
                textInputType: TextInputType.text,
                controller: name,
              ),
              SizedBox(height: height(context) * 8),
              TextInput(
                hintText: 'Address',
                textInputType: TextInputType.streetAddress,
                controller: address,
              ),
              SizedBox(height: height(context) * 8),
              TextInput(
                hintText: 'City',
                textInputType: TextInputType.text,
                controller: city,
              ),
              SizedBox(height: height(context) * 8),
              TextInput(
                hintText: 'Area',
                textInputType: TextInputType.text,
                controller: area,
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
      if (hostel == null) {
        await adminService.createHostel(
          name: name.text.trim(),
          address: address.text.trim(),
          city: city.text.trim(),
          area: area.text.trim(),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Hostel created with default food menu, specs, rents & welcome notice.',
            ),
          ),
        );
      } else {
        await adminService.updateHostel(
          hostelId: hostel.id,
          name: name.text.trim(),
          address: address.text.trim(),
          city: city.text.trim(),
          area: area.text.trim(),
        );
      }
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
          Strings.manageHostels,
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
                itemCount: _hostels.length,
                separatorBuilder: (_, __) => SizedBox(height: height(context) * 8),
                itemBuilder: (context, index) {
                  final hostel = _hostels[index];
                  return ListTile(
                    tileColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: Text(hostel.name),
                    subtitle: Text('${hostel.area}, ${hostel.city}\n${hostel.address}'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Seed defaults',
                          icon: const Icon(Icons.playlist_add_check_rounded),
                          onPressed: () async {
                            try {
                              await adminService.seedHostelDefaults(hostel.id);
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Defaults ready for ${hostel.name}',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$e')),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _edit(hostel),
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
