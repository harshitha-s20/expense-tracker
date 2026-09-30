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

  InputDecoration fieldDecoration({Widget? suffixIcon}) {
    return InputDecoration(
      hintText: label,
      hintStyle: TextStyle(color: Color(0xFF5F6570), fontSize: 16),
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 78, 74, 74),
          width: 1.8,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 78, 74, 74),
          width: 1.8,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 78, 74, 74),
          width: 1.8,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1.8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final double menuHeight = isPortrait ? 300 : 200;

    if (fieldtype == FieldType.dropdown) {
      return SizedBox(
        width: width * 0.5,
        child: DropdownButtonFormField<String>(
          menuMaxHeight: menuHeight,
          initialValue: selectedValue,
          decoration: fieldDecoration(),
          dropdownColor: Color(0xFFF9F7FF),
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF5F6570)),
          style: const TextStyle(color: Color(0xFF263B53), fontSize: 16),

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
          decoration: fieldDecoration(
            suffixIcon: Icon(Icons.calendar_month, color: Color(0xFF4B5563)),
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
        decoration: fieldDecoration(),
      ),
    );
  }
}
