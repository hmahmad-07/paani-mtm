// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:paani/core/extensions/sizer.dart';

import '../../core/resources/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final String? selectedItem;
  final List<String> menuList;
  final List<IconData>? iconList;
  final void Function(String value) onChange;

  const CustomDropdown({
    super.key,
    required this.hintText,
    required this.selectedItem,
    required this.menuList,
    required this.onChange,
    this.iconList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(3.r),
        border: Border.all(color: AppColor.lightGrey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: menuList.contains(selectedItem) ? selectedItem : null,
          hint: Text(
            hintText,
            style: TextStyle(
              color: AppColor.grey,
              fontSize: 4.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          dropdownColor: AppColor.white,
          isDense: true,
          isExpanded: true,
          borderRadius: BorderRadius.circular(3.r),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColor.darkGrey),
          items: menuList.asMap().entries.map((entry) {
            int index = entry.key;
            String item = entry.value;

            IconData? icon = (iconList != null && iconList!.length > index)
                ? iconList![index]
                : null;

            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: AppColor.appColor1),
                    SizedBox(width: 2.w),
                  ],
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      item,
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChange(newValue);
            }
          },
          menuMaxHeight: 250,
        ),
      ),
    );
  }
}
