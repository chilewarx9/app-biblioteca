import 'package:flutter/material.dart';

class SwipeBg extends StatelessWidget {
  const SwipeBg({super.key, required this.alineacion, required this.color});
  final Alignment alineacion;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alineacion,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.delete_outlined, color: Colors.white),
          SizedBox(width: 8),
          Text(
            "Eliminar",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
