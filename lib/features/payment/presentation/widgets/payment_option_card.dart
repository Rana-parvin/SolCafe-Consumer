import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentOptionCard extends StatelessWidget {
  final String value;
  final String groupValue;
  final void Function(String) onChanged;
  final Widget trailing;
  final Color radioColor;

  const PaymentOptionCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.trailing,
    required this.radioColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 17, right: 17, bottom: 6),
      child: InkWell(
        onTap: () => onChanged(value),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: const Color.fromARGB(255, 252, 247, 239),
          child: ListTile(
            leading: Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
              fillColor: WidgetStatePropertyAll(radioColor),
            ),
            trailing: trailing,
            title: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.brown[900],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
