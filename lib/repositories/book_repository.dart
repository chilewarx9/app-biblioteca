import 'package:app_tareas/models/book.dart';

class BookRepository {
  BookRepository() {
    _initializeBooks();
  }

  // Lista privada de libros precargados (simulando base de datos local)
  final List<({String id, Book book})> _books = [];
  int _nextId = 6; // Contador para IDs únicos

  // Inicializar con 5 libros precargados según requerimiento del PDF
  void _initializeBooks() {
    final now = DateTime.now();

    _books.addAll([
      (
        id: '1',
        book: Book(
          title: 'Cien años de soledad',
          status: BookStatus.borrowed,
          note: 'Gabriel García Márquez - Editorial Sudamericana',
          returnDate: DateTime(now.year, now.month, now.day + 5),
        ),
      ),
      (
        id: '2',
        book: Book(
          title: 'Don Quijote de la Mancha',
          status: BookStatus.stored,
          note: 'Miguel de Cervantes - Clásico español',
          returnDate: null,
        ),
      ),
      (
        id: '3',
        book: Book(
          title: 'El Principito',
          status: BookStatus.overdue,
          note: 'Antoine de Saint-Exupéry',
          returnDate: DateTime(now.year, now.month, now.day - 3),
        ),
      ),
      (
        id: '4',
        book: Book(
          title: '1984',
          status: BookStatus.stored,
          note: 'George Orwell - Distopía clásica',
          returnDate: null,
        ),
      ),
      (
        id: '5',
        book: Book(
          title: 'Crónica de una muerte anunciada',
          status: BookStatus.borrowed,
          note: 'Gabriel García Márquez',
          returnDate: DateTime(now.year, now.month, now.day + 10),
        ),
      ),
    ]);
  }

  // Crear un nuevo libro
  Future<String> create(Book b) async {
    final id = _nextId.toString();
    _nextId++;

    _books.insert(0, (id: id, book: b));

    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 100));
    return id;
  }

  // Obtener todos los libros
  Future<List<({String id, Book book})>> findAll() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return List.from(_books);
  }

  // Buscar libros con filtros
  Future<List<({String id, Book book})>> findFiltered({
    required BookFilter filter,
    required String query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));

    var filtered = _books.where((item) {
      final book = item.book;

      // Filtrar por estado
      final matchesFilter = switch (filter) {
        BookFilter.all => true,
        BookFilter.stored => book.status == BookStatus.stored,
        BookFilter.borrowed => book.status == BookStatus.borrowed,
        BookFilter.overdue => book.status == BookStatus.overdue,
      };

      // Filtrar por búsqueda de texto
      final searchText = query.trim().toLowerCase();
      final matchesQuery = searchText.isEmpty ||
          book.title.toLowerCase().contains(searchText) ||
          (book.note?.toLowerCase().contains(searchText) ?? false);

      return matchesFilter && matchesQuery;
    }).toList();

    return filtered;
  }

  // Actualizar solo el estado de un libro (para toggle)
  Future<void> updateStatus(String id, BookStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 50));

    final index = _books.indexWhere((item) => item.id == id);
    if (index != -1) {
      _books[index].book.status = newStatus;
    }
  }

  // Eliminar un libro
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _books.removeWhere((item) => item.id == id);
  }

  // Buscar libro por ID
  ({String id, Book book})? findById(String id) {
    try {
      return _books.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
