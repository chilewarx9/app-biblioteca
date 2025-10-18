import 'package:app_tareas/widgets/new_book_sheet.dart';
import 'package:flutter/material.dart';

class NewBookFab extends StatelessWidget {
  const NewBookFab({
    super.key,
    required this.onSubmit,
    this.onCreated,
    this.labelText = 'Nuevo Libro',
    this.icon = Icons.book,
  });

  final void Function(String title, String? note, DateTime? returnDate)
  onSubmit;
  final void Function(BuildContext context)? onCreated;
  final String labelText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(icon),
      label: Text(labelText),
      onPressed: () async {
        final created = await showModalBottomSheet<bool?>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: NewBookSheet(
              onSubmit: (title, note, returnDate) {
                onSubmit(title, note, returnDate);
                Navigator.pop(ctx, true);
              },
            ),
          ),
        );

        // Chequeo de seguridad: si el contexto ya no está montado, no usarlo.
        if ((created ?? false) && onCreated != null) {
          if (!context.mounted) return;
          onCreated!(context);
        }
      },
    );
  }
}
