import 'package:flutter/material.dart';

enum FieldType { text, number, decimal, dropdown, datetime }

class Textformfield extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? Function(String?)? validator;
  final FieldType fieldtype;
  final List<String>? items;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final DateTime? selectedDate;
  final void Function(DateTime)? onTap;

  const Textformfield({
    super.key,
    this.controller,
    required this.label,
    this.validator,
    required this.fieldtype,
    this.items,
    this.onChanged,
    this.selectedValue,
    this.selectedDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (fieldtype == FieldType.dropdown) {
      return SizedBox(
        width: width * 0.5,
        child: DropdownButtonFormField<String>(
          initialValue: selectedValue,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          items: items?.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      );
    }

    if (fieldtype == FieldType.datetime) {
      return SizedBox(
        width: width * 0.5,
        child: TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: label,
            suffixIcon: Icon(Icons.calendar_month),
          ),
          readOnly: true,

          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              controller?.text =
                  '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
              onTap?.call(pickedDate);
            }
          },
        ),
      );
    }

    TextInputType keyboardType = TextInputType.text;

    if (fieldtype == FieldType.number) {
      keyboardType = TextInputType.number;
    } else if (fieldtype == FieldType.decimal) {
      keyboardType = TextInputType.numberWithOptions(decimal: true);
    }

    return SizedBox(
      width: width * 0.5,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
