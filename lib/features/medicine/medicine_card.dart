import 'package:flutter/material.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard({required this.name, required this.dosage, super.key});

  final String name;
  final String dosage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(name), subtitle: Text(dosage)),
    );
  }
}
