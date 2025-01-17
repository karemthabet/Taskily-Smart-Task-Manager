import 'package:flutter/material.dart';
import 'package:todo_app/UI/utils/app_colors.dart';

class DrobdownCustom extends StatefulWidget {
  const DrobdownCustom({
    super.key,
    required this.initialValue,
    required this.value1,
    required this.value1Key,
    required this.value2,
    required this.value2Key,
    required this.onChanged,
  });

  final String initialValue;
  final String value1;
  final String value1Key;
  final String value2;
  final String value2Key;
  final void Function(String?) onChanged;

  @override
  State<DrobdownCustom> createState() => _DrobdownCustomState();
}

class _DrobdownCustomState extends State<DrobdownCustom> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
      padding: const EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Theme.of(context).colorScheme.onPrimary,
          value: selectedValue,
          isExpanded: true,
          items: [
            DropdownMenuItem<String>(
              value: widget.value1Key,
              child: Text(
                widget.value1,
                style: const TextStyle(color: AppColors.primaryColor, fontSize: 16),
              ),
            ),
            DropdownMenuItem<String>(
              value: widget.value2Key,
              child: Text(
                widget.value2,
                style: const TextStyle(color: AppColors.primaryColor, fontSize: 16),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedValue = value!;
            });
            widget.onChanged(value);
          },
        ),
      ),
    );
  }
}
