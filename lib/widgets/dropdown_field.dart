import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/model/hostel.dart';
import 'package:room_mates/model/sharing_type.dart';
import 'package:room_mates/utils/colors.dart';

class DropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final IconData icon;

  const DropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.icon = Icons.arrow_drop_down_circle_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize(context) * 14,
            fontWeight: FontWeight.w600,
            color: AppColors.headerText,
          ),
        ),
        SizedBox(height: height(context) * 8),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: EdgeInsets.symmetric(
              horizontal: width(context) * 16,
              vertical: height(context) * 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemLabel(item),
                    style: TextStyle(fontSize: fontSize(context) * 15),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class HostelDropdown extends StatelessWidget {
  final Hostel? value;
  final List<Hostel> hostels;
  final ValueChanged<Hostel?> onChanged;

  const HostelDropdown({
    super.key,
    required this.value,
    required this.hostels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownField<Hostel>(
      label: 'Select Hostel',
      hint: 'Choose your hostel in KPHB',
      value: value,
      items: hostels,
      icon: Icons.apartment_outlined,
      itemLabel: (h) => h.name,
      onChanged: onChanged,
    );
  }
}

class SharingDropdown extends StatelessWidget {
  final SharingType? value;
  final List<SharingType> options;
  final ValueChanged<SharingType?> onChanged;

  const SharingDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownField<SharingType>(
      label: 'Sharing Type',
      hint: 'Select room sharing',
      value: value,
      items: options,
      icon: Icons.bed_outlined,
      itemLabel: (s) => '${s.label} — ${s.amountLabel}',
      onChanged: onChanged,
    );
  }
}
