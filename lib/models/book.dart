// Clase que representa un libro
class Book {
  // Constructor de la clase Book
  Book({
    required this.title, // el título es obligatorio
    this.status = BookStatus.stored,   // por defecto el libro está almacenado
    this.note,           // nota opcional
    this.returnDate,     // fecha opcional de devolución
  });

  String title;      // título del libro
  BookStatus status; // estado: almacenado, prestado o retrasado
  String? note;      // texto con una nota opcional (puede ser null)
  DateTime? returnDate; // fecha límite de devolución opcional (puede ser null)
}

// Enumeración que define estados posibles para los libros
enum BookStatus {
  stored,    // libro almacenado en biblioteca
  borrowed,  // libro prestado
  overdue    // libro retrasado (no devuelto a tiempo)
}

// Enumeración para filtros de vista
enum BookFilter {
  all,      // muestra todos los libros
  stored,   // muestra solo los almacenados
  borrowed, // muestra solo los prestados
  overdue   // muestra solo los retrasados
}
