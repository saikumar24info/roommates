import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/service_request.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/widgets/elevated_button.dart';
import 'package:room_mates/widgets/textinput.dart';

class ServiceRequestsScreen extends StatefulWidget {
  const ServiceRequestsScreen({super.key});

  @override
  State<ServiceRequestsScreen> createState() => _ServiceRequestsScreenState();
}

class _ServiceRequestsScreenState extends State<ServiceRequestsScreen> {
  static const _categories = [
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Wi-Fi',
    'Food',
    'Other',
  ];

  List<ServiceRequest> _requests = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await serviceRequestService.fetchMyRequests();
      if (!mounted) return;
      setState(() {
        _requests = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final message = e.toString();
      final friendly = message.contains('service_requests') ||
              message.contains('PGRST205') ||
              message.contains('42P01')
          ? 'Service requests are not set up yet. Ask your admin to run the database setup, then retry.'
          : message;
      setState(() {
        _loading = false;
        _error = friendly;
      });
    }
  }

  Future<void> _openCreateSheet() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String category = _categories.first;
    var submitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: width(context) * 16,
                right: width(context) * 16,
                top: height(context) * 16,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    height(context) * 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Strings.newRequest,
                    style: TextStyle(
                      fontSize: fontSize(context) * 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.headerText,
                    ),
                  ),
                  SizedBox(height: height(context) * 14),
                  Text(
                    Strings.requestCategory,
                    style: TextStyle(
                      fontSize: fontSize(context) * 13,
                      color: AppColors.bodyText,
                    ),
                  ),
                  SizedBox(height: height(context) * 6),
                  DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: category,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() => category = value);
                      }
                    },
                  ),
                  SizedBox(height: height(context) * 12),
                  TextInput(
                    hintText: Strings.requestTitle,
                    textInputType: TextInputType.text,
                    controller: titleController,
                    preficIcon: Icon(
                      Icons.title,
                      color: AppColors.primary,
                      size: height(context) * 22,
                    ),
                  ),
                  SizedBox(height: height(context) * 12),
                  TextInput(
                    hintText: Strings.requestDescription,
                    textInputType: TextInputType.multiline,
                    controller: descController,
                    preficIcon: Icon(
                      Icons.notes_outlined,
                      color: AppColors.primary,
                      size: height(context) * 22,
                    ),
                  ),
                  SizedBox(height: height(context) * 18),
                  elevatedButton(
                    context,
                    buttonText:
                        submitting ? 'Submitting...' : Strings.submitRequest,
                    buttonWidth: 360,
                    buttonHeight: 48,
                    borderRadius: 12,
                    fontSize: fontSize(context) * 15,
                    onPress: () async {
                      if (submitting) return;
                      final title = titleController.text.trim();
                      if (title.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a title')),
                        );
                        return;
                      }
                      setModalState(() => submitting = true);
                      try {
                        await serviceRequestService.createRequest(
                          category: category,
                          title: title,
                          description: descController.text.trim(),
                        );
                        if (context.mounted) Navigator.pop(context);
                        if (mounted) {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text(Strings.requestSubmitted),
                            ),
                          );
                          _load();
                        }
                      } catch (e) {
                        setModalState(() => submitting = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'resolved':
      case 'closed':
        return AppColors.green;
      case 'in progress':
        return AppColors.primary;
      default:
        return const Color(0xFFE67E22);
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
          color: AppColors.white,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: height(context) * 26),
        ),
        title: Text(
          Strings.serviceRequests,
          style: TextStyle(
            fontSize: fontSize(context) * 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateSheet,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text(
          Strings.newRequest,
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: _loading
          ? const Center(
              child: SpinKitWave(
                color: AppColors.primary,
                type: SpinKitWaveType.start,
              ),
            )
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
                        TextButton(onPressed: _load, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _load,
                  child: _requests.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(height: height(context) * 120),
                            Icon(
                              Icons.handyman_outlined,
                              size: height(context) * 48,
                              color: AppColors.navInactive,
                            ),
                            SizedBox(height: height(context) * 12),
                            Text(
                              Strings.noRequests,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: fontSize(context) * 15,
                                color: AppColors.bodyText,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            width(context) * 16,
                            height(context) * 16,
                            width(context) * 16,
                            height(context) * 90,
                          ),
                          itemCount: _requests.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: height(context) * 10),
                          itemBuilder: (context, index) {
                            final item = _requests[index];
                            return Container(
                              padding: EdgeInsets.all(width(context) * 14),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: fontSize(context) * 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.headerText,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width(context) * 8,
                                          vertical: height(context) * 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _statusColor(item.status)
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          item.status,
                                          style: TextStyle(
                                            fontSize: fontSize(context) * 11,
                                            fontWeight: FontWeight.w600,
                                            color: _statusColor(item.status),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height(context) * 6),
                                  Text(
                                    item.category,
                                    style: TextStyle(
                                      fontSize: fontSize(context) * 13,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (item.description.isNotEmpty) ...[
                                    SizedBox(height: height(context) * 6),
                                    Text(
                                      item.description,
                                      style: TextStyle(
                                        fontSize: fontSize(context) * 13,
                                        color: AppColors.bodyText,
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: height(context) * 8),
                                  Text(
                                    '${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                                    style: TextStyle(
                                      fontSize: fontSize(context) * 11,
                                      color: AppColors.navInactive,
                                    ),
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
