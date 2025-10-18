import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField(
    {super.key,
    required this.onChanged}
    );

    final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: TextField(
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: "Buscar tareas...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          filled: true 
        ),
      ),
      );
  }
}