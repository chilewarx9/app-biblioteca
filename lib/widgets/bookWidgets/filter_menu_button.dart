import 'package:app_tareas/models/book.dart';
import 'package:flutter/material.dart';

class FilterMenuButton extends StatelessWidget {
  const FilterMenuButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final BookFilter value;
  final ValueChanged<BookFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BookFilter>(
      tooltip: "Filtro",
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (_)=> const [
        PopupMenuItem(value: BookFilter.all, child: Text("Todos")),
        PopupMenuItem(value: BookFilter.stored, child: Text("Almacenados")),
        PopupMenuItem(value: BookFilter.borrowed, child: Text("Prestados")),
        PopupMenuItem(value: BookFilter.overdue, child: Text("Retrasados")),
      ],
      icon: const Icon(Icons.filter_list)
    );
  }
}
