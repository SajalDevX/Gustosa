import 'package:flutter/material.dart';
import 'package:gustosa/app/shared/config/constants/enums.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final TextEditingController controller;
  final String hintText;
  final CustomFormType fieldType;
  final int? maxLines;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool isAuthTextField;
  final TextInputType? textInputType;

  const CustomTextField({
    super.key,
    this.title,
    required this.controller,
    required this.hintText,
    required this.fieldType,
    this.maxLines,
    this.onTap,
    this.isAuthTextField = false,
    this.onChanged,
    this.textInputType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Text(widget.title!),
          const SizedBox(height: 8),
        ],
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: widget.isAuthTextField
                ? Border.all(color: const Color(0xFFD6D6D6))
                : null,
            color: widget.isAuthTextField ? null : const Color(0xFFE8EDF5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    keyboardType: widget.textInputType,
                    onChanged: widget.onChanged,
                    maxLines: widget.maxLines,
                    controller: widget.controller,
                    readOnly: widget.fieldType != CustomFormType.text,
                    onTap: () {
                      if (widget.fieldType == CustomFormType.date) {
                        _selectDate(context);
                      } else if (widget.fieldType == CustomFormType.filter) {
                        _selectFilter(context);
                      } else {
                        widget.onTap?.call();
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: widget.isAuthTextField
                            ? null
                            : const Color(0xFF4A789C),
                      ),
                    ),
                  ),
                ),
              ),
              _getTrailingWidget(),
              const SizedBox(width: 12),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Custom trailing icon based on field type
  Widget _getTrailingWidget() {
    switch (widget.fieldType) {
      case CustomFormType.text:
        return const SizedBox();
      case CustomFormType.date:
        return const Icon(Icons.calendar_today, color: Color(0xFF4A789C));
      case CustomFormType.list:
        return const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A789C));
      case CustomFormType.dateTime:
        return const Icon(Icons.calendar_month_outlined, color: Color(0xFF4A789C));
      case CustomFormType.duration:
        return const Icon(Icons.timelapse_outlined, color: Color(0xFF4A789C));
      case CustomFormType.filter:
        return const Icon(Icons.filter_alt_outlined, color: Color(0xFF4A789C));
      default:
        return const SizedBox();
    }
  }

  // Example date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = picked.toString();
      });
    }
  }

  // Example filter selector
  void _selectFilter(BuildContext context) {
    // Placeholder for filter selection logic
    print("Filter selected");
  }
}

