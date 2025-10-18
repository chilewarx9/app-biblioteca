// a la finales este book repository usamos, el otro de auth_repository.dart lo dejamos como backup nomas v:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book.dart';

class FirestoreBookRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _booksCollection => _db.collection('books');
  String? get _currentUserId => _auth.currentUser?.uid;

  // Inicializar libros precargados
  Future<void> initializeBooksIfNeeded() async {
    if (_currentUserId == null) return;

    final snapshot = await _booksCollection
        .where('userId', isEqualTo: _currentUserId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      await _initializeBooks();
    }
  }

  Future<void> _initializeBooks() async {
    if (_currentUserId == null) return;

    final now = DateTime.now();
    final books = [
      {
        'title': 'Cien años de soledad',
        'status': 'borrowed',
        'note': 'Gabriel García Márquez - Editorial Sudamericana',
        'returnDate': DateTime(
          now.year,
          now.month,
          now.day + 5,
        ).toIso8601String(),
        'userId': _currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Don Quijote de la Mancha',
        'status': 'stored',
        'note': 'Miguel de Cervantes - Clásico español',
        'returnDate': null,
        'userId': _currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'El Principito',
        'status': 'overdue',
        'note': 'Antoine de Saint-Exupéry',
        'returnDate': DateTime(
          now.year,
          now.month,
          now.day - 3,
        ).toIso8601String(),
        'userId': _currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': '1984',
        'status': 'stored',
        'note': 'George Orwell - Distopía clásica',
        'returnDate': null,
        'userId': _currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Crónica de una muerte anunciada',
        'status': 'borrowed',
        'note': 'Gabriel García Márquez',
        'returnDate': DateTime(
          now.year,
          now.month,
          now.day + 10,
        ).toIso8601String(),
        'userId': _currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (var bookData in books) {
      await _booksCollection.add(bookData);
    }
  }

  // Crear libro
  Future<String> create(Book book) async {
    if (_currentUserId == null) throw Exception('Usuario no autenticado');

    final docRef = await _booksCollection.add({
      'title': book.title,
      'status': book.status.name,
      'note': book.note,
      'returnDate': book.returnDate?.toIso8601String(),
      'userId': _currentUserId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  // Stream de libros filtrados (SIN índice compuesto)
  Stream<List<({String id, Book book})>> streamFilteredBooks({
    required BookFilter filter,
    required String query,
  }) {
    if (_currentUserId == null) return Stream.value([]);

    // Consulta simple sin orderBy para evitar índice compuesto
    Query queryRef = _booksCollection.where(
      'userId',
      isEqualTo: _currentUserId,
    );

    // Aplicar filtro de estado si no es "all"
    if (filter != BookFilter.all) {
      final statusName = switch (filter) {
        BookFilter.stored => 'stored',
        BookFilter.borrowed => 'borrowed',
        BookFilter.overdue => 'overdue',
        BookFilter.all => null,
      };
      if (statusName != null) {
        queryRef = queryRef.where('status', isEqualTo: statusName);
      }
    }

    return queryRef.snapshots().map((snapshot) {
      // Mapear documentos con fecha de creación
      var results = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return (
          id: doc.id,
          book: _bookFromMap(data),
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        );
      }).toList();

      // Ordenar localmente por fecha (más reciente primero)
      results.sort((a, b) {
        final dateA = a.createdAt ?? DateTime(2000);
        final dateB = b.createdAt ?? DateTime(2000);
        return dateB.compareTo(dateA);
      });

      // Filtrar por texto localmente
      if (query.trim().isNotEmpty) {
        final searchText = query.trim().toLowerCase();
        results = results.where((item) {
          final book = item.book;
          return book.title.toLowerCase().contains(searchText) ||
              (book.note?.toLowerCase().contains(searchText) ?? false);
        }).toList();
      }

      // Retornar sin el campo createdAt
      return results.map((r) => (id: r.id, book: r.book)).toList();
    });
  }

  // Actualizar estado
  Future<void> updateStatus(String id, BookStatus newStatus) async {
    await _booksCollection.doc(id).update({'status': newStatus.name});
  }

  // Eliminar libro
  Future<void> delete(String id) async {
    await _booksCollection.doc(id).delete();
  }

  // Convertir mapa a Book
  Book _bookFromMap(Map<String, dynamic> data) {
    return Book(
      title: data['title'] as String? ?? '',
      status: _statusFromString(data['status'] as String?),
      note: data['note'] as String?,
      returnDate: data['returnDate'] != null
          ? DateTime.parse(data['returnDate'] as String)
          : null,
    );
  }

  // Convertir string a BookStatus
  BookStatus _statusFromString(String? status) {
    return switch (status) {
      'stored' => BookStatus.stored,
      'borrowed' => BookStatus.borrowed,
      'overdue' => BookStatus.overdue,
      _ => BookStatus.stored,
    };
  }
}
