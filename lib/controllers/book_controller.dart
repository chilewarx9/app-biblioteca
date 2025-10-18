import 'dart:async';
import 'package:app_tareas/repositories/firestore_book_repository.dart';
import 'package:flutter/foundation.dart';
import '../models/book.dart';

class BookController extends ChangeNotifier {
  BookController({FirestoreBookRepository? repo})
    : _repo = repo ?? FirestoreBookRepository() {
    _initializeAndListen();
  }

  final FirestoreBookRepository _repo;
  StreamSubscription<List<({String id, Book book})>>? _subscription;

  // Mapa para rastrear ID de libros
  final Map<Book, String> _bookIds = {};
  final List<Book> _books = [];

  String _query = '';
  BookFilter _filter = BookFilter.all;

  // Getters
  List<Book> get books => List.unmodifiable(_books);
  String get query => _query;
  BookFilter get filter => _filter;

  List<Book> get filtered {
    // La lista ya viene filtrada del Stream, solo aplicamos búsqueda local si es necesario
    return List.unmodifiable(_books);
  }

  // Inicializar libros precargados y empezar a escuchar
  Future<void> _initializeAndListen() async {
    await _repo.initializeBooksIfNeeded();
    _listenToBooks();
  }

  // Escuchar cambios en tiempo real
  void _listenToBooks() {
    _subscription?.cancel();
    _subscription = _repo
        .streamFilteredBooks(filter: _filter, query: _query)
        .listen((rows) {
          _books.clear();
          _bookIds.clear();

          for (final row in rows) {
            _books.add(row.book);
            _bookIds[row.book] = row.id;
          }

          notifyListeners();
        });
  }

  // Cambiar query de búsqueda
  void setQuery(String value) {
    _query = value;
    _listenToBooks();
  }

  // Cambiar filtro
  void setFilter(BookFilter f) {
    _filter = f;
    _listenToBooks();
  }

  // Cambiar estado de un libro
  Future<void> changeStatus(Book b, BookStatus newStatus) async {
    final id = _bookIds[b];
    if (id != null) {
      await _repo.updateStatus(id, newStatus);
      // El listener actualizará automáticamente la UI
    }
  }

  // Agregar nuevo libro
  Future<void> add(String title, {String? note, DateTime? returnDate}) async {
    final book = Book(title: title, note: note, returnDate: returnDate);
    await _repo.create(book);
    // El listener actualizará automáticamente la UI
  }

  // Eliminar libro
  Future<void> remove(Book b) async {
    final id = _bookIds[b];
    if (id != null) {
      await _repo.delete(id);
      // El listener actualizará automáticamente la UI
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // Mantener compatibilidad con código existente
  Future<void> load() async {
    // Ya no es necesario, pero lo dejamos para no romper nada
  }
}
