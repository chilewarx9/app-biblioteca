import 'package:app_tareas/controllers/book_controller.dart';
import 'package:app_tareas/utils/date_utils.dart';
import 'package:app_tareas/widgets/bookWidgets/empty_state.dart';
import 'package:app_tareas/widgets/bookWidgets/filter_chips_row.dart';
import 'package:app_tareas/widgets/bookWidgets/filter_menu_button.dart';
import 'package:app_tareas/widgets/bookWidgets/new_book_fab.dart';
import 'package:app_tareas/widgets/bookWidgets/search_field.dart';
import 'package:app_tareas/widgets/bookWidgets/book_list_view.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late final BookController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = BookController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.load();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final items = _ctrl.filtered;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Biblioteca"),
            actions: [
              FilterMenuButton(value: _ctrl.filter, onChanged: _ctrl.setFilter),
            ],
          ),
          floatingActionButton: NewBookFab(
            onSubmit: (title, note, returnDate) =>
                _ctrl.add(title, note: note, returnDate: returnDate),
            onCreated: (ctx) => ScaffoldMessenger.of(
              ctx,
            ).showSnackBar(const SnackBar(content: Text("Libro Agregado"))),
          ),
          body: SafeArea(
            child: Column(
              children: [
                SearchField(onChanged: _ctrl.setQuery),
                FilterChipsRow(
                  value: _ctrl.filter,
                  onChanged: _ctrl.setFilter,
                  color: Colors.red,
                ),
                const Divider(height: 1),
                Expanded(
                  child: items.isEmpty
                      ? const EmptyState()
                      : BookListView(
                          items: items,
                          onStatusChanged: (b, status) => _ctrl.changeStatus(b, status),
                          onDelete: (b) {
                            _ctrl.remove(b);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Libro Eliminado")),
                            );
                          },
                          dateFormatter: formatShortDate,
                          swipeColor: Colors.red,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
