import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/widgets/elevated_button.dart';
import 'package:room_mates/widgets/textinput.dart';

class ManageHostelInfoScreen extends StatefulWidget {
  final String hostelId;

  const ManageHostelInfoScreen({super.key, required this.hostelId});

  @override
  State<ManageHostelInfoScreen> createState() => _ManageHostelInfoScreenState();
}

class _ManageHostelInfoScreenState extends State<ManageHostelInfoScreen> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _area = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _city.dispose();
    _area.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final hostel = await adminService.fetchHostel(widget.hostelId);
    if (!mounted) return;
    if (hostel != null) {
      _name.text = hostel.name;
      _address.text = hostel.address;
      _city.text = hostel.city;
      _area.text = hostel.area;
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _address.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and address are required')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await adminService.updateHostel(
        hostelId: widget.hostelId,
        name: _name.text.trim(),
        address: _address.text.trim(),
        city: _city.text.trim().isEmpty ? 'Hyderabad' : _city.text.trim(),
        area: _area.text.trim().isEmpty ? 'KPHB' : _area.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(Strings.savedSuccessfully)),
      );
      Navigator.pop(context);
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
          Strings.manageHostelInfo,
          style: TextStyle(color: AppColors.white, fontSize: fontSize(context) * 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: EdgeInsets.all(width(context) * 16),
              children: [
                TextInput(
                  hintText: 'Hostel name',
                  textInputType: TextInputType.text,
                  controller: _name,
                ),
                SizedBox(height: height(context) * 10),
                TextInput(
                  hintText: 'Address',
                  textInputType: TextInputType.streetAddress,
                  controller: _address,
                ),
                SizedBox(height: height(context) * 10),
                TextInput(
                  hintText: 'City',
                  textInputType: TextInputType.text,
                  controller: _city,
                ),
                SizedBox(height: height(context) * 10),
                TextInput(
                  hintText: 'Area',
                  textInputType: TextInputType.text,
                  controller: _area,
                ),
                SizedBox(height: height(context) * 20),
                elevatedButton(
                  context,
                  buttonText: _saving ? 'Saving...' : Strings.saveChanges,
                  buttonWidth: 360,
                  buttonHeight: 48,
                  onPress: _saving ? () {} : _save,
                ),
              ],
            ),
    );
  }
}
