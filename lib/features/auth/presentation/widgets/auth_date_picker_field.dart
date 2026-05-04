import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:majadigi/core/utils/helpers/input_decoration_helper.dart';

class AuthDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? Function(DateTime?)? validator;

  const AuthDatePickerField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
  });

  void _showDatePicker(BuildContext context) {
    FocusScope.of(context).unfocus();
    DateTime initialDate = selectedDate ?? DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(
                        color: Color(0xFF0066CC),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
            // Date Picker
            Expanded(
              child: SafeArea(
                top: false,
                child: CupertinoDatePicker(
                  initialDateTime: initialDate,
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year,
                  maximumDate: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: onDateSelected,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = selectedDate == null
        ? 'DD/MM/YYYY'
        : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: AbsorbPointer(
            child: TextFormField(
              validator: (_) => validator?.call(selectedDate),
              decoration: InputDecorationHelper.authDecoration(
                context,
                hintText: formattedDate,
                hintColor: selectedDate == null ? Colors.grey : Colors.black87,
                suffixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}