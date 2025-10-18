import 'package:app_tareas/models/book.dart';
import 'package:app_tareas/widgets/bookWidgets/book_card.dart';
import 'package:flutter/material.dart';

class BookListView extends StatelessWidget {
  const BookListView({
    super.key,
    required this.items,
    required this.onStatusChanged,
    required this.onDelete,
    required this.dateFormatter,
    required this.swipeColor,
    this.empty,
    this.itemKeyOf,
  });

  final List<Book> items;
  final void Function(Book book, BookStatus status) onStatusChanged;
  final void Function(Book book) onDelete;
  final String Function(DateTime) dateFormatter;
  final Color swipeColor;

  final Widget? empty;

  final Object? Function(Book book)? itemKeyOf;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return empty ?? const SizedBox.shrink();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final book = items[i];
        return BookCard(
          book: book,
          itemKey: itemKeyOf?.call(book),
          dateText: book.returnDate != null ? dateFormatter(book.returnDate!) : null,
          onStatusChanged: (status) => onStatusChanged(book, status),
          onDismissed: () => onDelete(book),
          swipeColor: swipeColor,
        );
      },
    );
  }
}
