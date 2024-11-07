import 'package:flutter/material.dart';
import 'package:diabo/models/appointment_model.dart';

class AppointmentCardWidget extends StatelessWidget {
  final AppointmentModel appointment;
  final Color color;
  final VoidCallback onDelete;
  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    required this.color,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1),
        ),
        child: Stack(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 40),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('โรงพยาบาล: ${appointment.hospital}',
                                style: const TextStyle(fontSize: 17)),
                            Text('วันที่นัดหมาย: ${appointment.date}',
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, size: 25),
                          const SizedBox(width: 10),
                          Text('วันที่: ${appointment.appointmentDate}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text('หมายเหตุ:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Text('ควรงดอาหาร', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
