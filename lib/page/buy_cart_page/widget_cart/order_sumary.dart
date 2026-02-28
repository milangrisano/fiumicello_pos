import 'package:flutter/material.dart';
import 'package:responsive_app/content/content_landing.dart';
import 'package:responsive_app/shared/app_colors.dart';
import 'package:responsive_app/shared/app_text_styles.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double delivery;
  final double total;

  const OrderSummary({
    required this.subtotal,
    required this.tax,
    required this.delivery,
    required this.total,
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LandingStrings.orderSummary,
            style: AppTextStyles.text(fontSize: 22, color: isDark ? AppColors.goldHighlightDark : AppColors.primaryTextLight),
          ),
          const SizedBox(height: 20),
          _SummaryRow(title: LandingStrings.subtotal, value: '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _SummaryRow(title: LandingStrings.tax, value: '\$${tax.toStringAsFixed(2)}'),
          const SizedBox(height: 12),
          _SummaryRow(title: LandingStrings.delivery, value: '\$${delivery.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.black12, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LandingStrings.total,
                style: AppTextStyles.bold(fontSize: 20, color: isDark ? AppColors.goldHighlightDark : AppColors.primaryTextLight),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: AppTextStyles.bold(fontSize: 20, color: isDark ? AppColors.goldHighlightDark : AppColors.primaryTextLight),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonGreenLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: total == 0 ? null : () {},
              child: Text(
                LandingStrings.btnCheckout,
                style: AppTextStyles.w500(fontSize: 16, color: AppColors.goldHighlightDark),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.text(fontSize: 16, color: isDark ? AppColors.goldHighlightDark : AppColors.primaryTextLight)),
        Text(value, style: AppTextStyles.text(fontSize: 16, color: isDark ? AppColors.goldHighlightDark : AppColors.primaryTextLight)),
      ],
    );
  }
}


