import 'package:app_tareas/models/book.dart';
import 'package:app_tareas/widgets/bookWidgets/swipe_bg.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onStatusChanged,
    required this.onDismissed,
    required this.swipeColor,
    this.dateText,
    this.itemKey,
  });

  final Book book;
  final ValueChanged<BookStatus> onStatusChanged;
  final VoidCallback onDismissed;
  final Color swipeColor;
  final String? dateText;
  final Object? itemKey;

  @override
  Widget build(BuildContext context) {
    final k = itemKey ?? '${book.title}-${book.hashCode}';

    // Determinar color según estado
    Color? statusColor;
    IconData statusIcon;

    switch (book.status) {
      case BookStatus.stored:
        statusColor = Colors.green;
        statusIcon = Icons.book;
        break;
      case BookStatus.borrowed:
        statusColor = Colors.blue;
        statusIcon = Icons.person;
        break;
      case BookStatus.overdue:
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        break;
    }

    return Dismissible(
      key: ValueKey(k),
      background: SwipeBg(alineacion: Alignment.centerLeft, color: swipeColor),
      secondaryBackground: SwipeBg(
        alineacion: Alignment.centerRight,
        color: swipeColor,
      ),
      onDismissed: (_) => onDismissed(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          leading: Icon(statusIcon, color: statusColor, size: 32),
          title: Text(
            book.title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getStatusText(book.status),
                style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
              ),
              if (book.note != null && book.note!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(book.note!),
                ),
              if (dateText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.event, size: 16),
                      const SizedBox(width: 6),
                      Text("Devolución: $dateText"),
                    ],
                  ),
                ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.sync_alt),
            tooltip: "Cambiar estado",
            onPressed: () => _showStatusMenu(context),
          ),
        ),
      ),
    );
  }

  void _showStatusMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Cambiar estado',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.book, color: Colors.green),
                title: const Text('Almacenado'),
                selected: book.status == BookStatus.stored,
                onTap: () {
                  Navigator.pop(context);
                  onStatusChanged(BookStatus.stored);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text('Prestado'),
                selected: book.status == BookStatus.borrowed,
                onTap: () {
                  Navigator.pop(context);
                  onStatusChanged(BookStatus.borrowed);
                },
              ),
              ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: const Text('Retrasado'),
                selected: book.status == BookStatus.overdue,
                onTap: () {
                  Navigator.pop(context);
                  onStatusChanged(BookStatus.overdue);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  String _getStatusText(BookStatus status) {
    switch (status) {
      case BookStatus.stored:
        return "Almacenado";
      case BookStatus.borrowed:
        return "Prestado";
      case BookStatus.overdue:
        return "Retrasado";
    }
  }
}
