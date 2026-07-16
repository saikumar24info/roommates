import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/hostel_specification.dart';
import 'package:room_mates/services/specification_service.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/utils/text_utility.dart';
import 'package:room_mates/widgets/specification_details.dart';

class Specificatons extends StatefulWidget {
  const Specificatons({super.key});

  @override
  State<Specificatons> createState() => _SpecificatonsState();
}

class _SpecificatonsState extends State<Specificatons> {
  List<HostelSpecification> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<String?> _resolveHostelId() async {
    final cached = await AppLocalPrefs.getHostelId();
    if (cached != null && cached.isNotEmpty) return cached;

    final userId = await AppLocalPrefs.getUserId();
    if (userId == null || userId.toString().isEmpty) return null;

    try {
      final profile = await profileService.fetchProfile(userId.toString());
      if (profile != null && profile.hostelId.isNotEmpty) {
        await AppLocalPrefs.setProfile(profile);
        return profile.hostelId;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final hostelId = await _resolveHostelId();
      final items = hostelId == null || hostelId.isEmpty
          ? specificationService.localDefaults()
          : await specificationService.fetchForHostel(hostelId);

      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
        if (_items.isEmpty) {
          _error = Strings.noData;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _items = specificationService.localDefaults();
        _loading = false;
        if (_items.isEmpty) {
          _error = e.toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.white,
            size: height(context) * 30,
          ),
        ),
        title: TextUtility.headerText(
          context,
          Strings.specifications,
          AppColors.white,
        ),
      ),
      body: _loading
          ? const Center(
              child: SpinKitWave(
                color: AppColors.primary,
                type: SpinKitWaveType.start,
              ),
            )
          : _error != null && _items.isEmpty
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _load,
                  child: _items.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(height: height(context) * 120),
                            const Center(child: Text(Strings.noData)),
                          ],
                        )
                      : ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                            width(context) * 16,
                            height(context) * 14,
                            width(context) * 16,
                            height(context) * 24,
                          ),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return specificationDetails(
                              context,
                              SpecificationService.iconAssetForKey(
                                item.iconKey,
                              ),
                              item.title,
                              item.description,
                            );
                          },
                        ),
                ),
    );
  }
}
