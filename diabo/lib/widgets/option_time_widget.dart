import 'package:diabo/models/option_time.dart';
import 'package:flutter/material.dart';

void optionsTimeWidget({
  required BuildContext context,
  required Function(OptionTime selectedOption) onSave,
}) {
  // สร้างรายการตัวเลือก
  final List<OptionTime> options = [
    OptionTime(id: 1, label: 'มื้อเช้า'),
    OptionTime(id: 2, label: 'มื้อกลางวัน'),
    OptionTime(id: 3, label: 'มื้อเย็น'),
    OptionTime(id: 4, label: 'มื้อว่าง'),
  ];

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            option.isSelected ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          // ทำให้เลือกได้เพียงอันเดียว
                          for (var opt in options) {
                            opt.isSelected = false;
                          }
                          option.isSelected = true;
                        });
                      },
                      child: Text(option.label),
                    ),
                  ),
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      final selectedOption = options.firstWhere(
                          (option) => option.isSelected,
                          orElse: () => OptionTime(id: 0, label: ''));
                      onSave(selectedOption); // ส่งตัวเลือกที่ถูกเลือกกลับไป
                    },
                    child: Text('ถ่ายรูป'),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
