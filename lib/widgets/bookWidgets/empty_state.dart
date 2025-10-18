import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checklist_rtl, size: 64, color: Colors.red),
            SizedBox(height: 12),
            Text(
              "No hay tareas creadas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "Crea tu primera tareas presionando el botón +",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
