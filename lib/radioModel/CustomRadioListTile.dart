import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String? leading;
  final Widget? title;
  final ValueChanged<T?> onChanged;
  final MaterialColor colorbackground;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.leading,
    required this.colorbackground,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    // final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: SizedBox(height: 3.h, width: 3.h, child: _customRadioButton),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 1.w),
      decoration: BoxDecoration(
        color: isSelected ? colorbackground : colorbackground,
        shape: BoxShape.circle,
        border: Border.all(
          width: 0.4.h,
          color: isSelected ? Colors.red : Colors.transparent,
        ),
      ),
    );
  }
}
