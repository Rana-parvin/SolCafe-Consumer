import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solcafe/core/theme/solcafe_colors.dart';

class PaymentOptionCard extends StatelessWidget {
  final String value;
  final String subtitle;
  final String groupValue;
  final void Function(String) onChanged;
  final IconData icon;

  const PaymentOptionCard({
    super.key,
    required this.value,
    required this.subtitle,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.solcafeColors;
    final isSelected = value == groupValue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(value),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? colors.accentGold : colors.cardBorder,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Square Icon Container matching reference
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.cardBorder),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? colors.accentGold : colors.textPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: GoogleFonts.readexPro(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing Indicator matching reference
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: colors.accentGold,
                    size: 22,
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: colors.textMuted,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
