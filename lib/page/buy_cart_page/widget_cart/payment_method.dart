import 'package:flutter/material.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';

class PaymentMethod extends StatelessWidget {
  final int selectedValue;
  final ValueChanged<int?> onChanged;

  const PaymentMethod({
    required this.selectedValue,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldDark),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 16),
            child: Text(
              LandingStrings.paymentMethodTitle,
              style: AppTextStyles.text(fontSize: 20, color: isDark ? AppColors.goldHighlightDark : AppColors.primaryTextLight),
            ),
          ),
          _PaymentOption(
            value: 0,
            groupValue: selectedValue,
            label: '•••• 4242',
            iconWidget: _CardLogo('VISA', Colors.blue.shade900, isSelected: selectedValue == 0),
            onChanged: onChanged,
          ),
          _PaymentOption(
            value: 1,
            groupValue: selectedValue,
            label: 'PSE',
            iconWidget: _CardLogo('PSE', Colors.teal, isSelected: selectedValue == 1),
            onChanged: onChanged,
          ),
          _PaymentOption(
            value: 2,
            groupValue: selectedValue,
            label: 'Nequi',
            iconWidget: _CardLogo('nequi', Colors.purple, isSelected: selectedValue == 2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}



class _PaymentOption extends StatelessWidget {
  final int value;
  final int groupValue;
  final String label;
  final Widget iconWidget;
  final ValueChanged<int?> onChanged;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.iconWidget,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              value == groupValue ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: value == groupValue ? AppColors.buttonGreenLight : AppColors.goldDark,
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.text(fontSize: 16, color: isDark ? AppColors.goldHighlightDark : AppColors.primaryTextLight)),
            const Spacer(),
            iconWidget,
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _CardLogo extends StatelessWidget {
  final String text;
  final Color color;
  final bool isSelected;
  const _CardLogo(this.text, this.color, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.buttonGreenLight : Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.bold(
            fontSize: 12, 
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }
}
