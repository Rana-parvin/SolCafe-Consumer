import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';

class PaymentOptionCard extends StatelessWidget {
  final String value;
  final String groupValue;
  final void Function(String) onChanged;
  final Widget trailing;
  final Color? radioColor;

  const PaymentOptionCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.trailing,
    this.radioColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    final isSelected = value == groupValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Card(
        color: isSelected ? colors.accentGoldSubtle : colors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? colors.accentGold : colors.cardBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: ListTile(
          onTap: () => onChanged(value),
          // ignore: deprecated_member_use
          leading: Radio<String>(
            // ignore: deprecated_member_use
            groupValue: groupValue,
            value: value,
            // ignore: deprecated_member_use
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
            activeColor: colors.accentGold,
          ),

          trailing: trailing,
          title: Text(
            value,
            style: GoogleFonts.readexPro(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
