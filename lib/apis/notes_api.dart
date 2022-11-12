import 'package:testingbloc_practice/models.dart';

abstract class NotesApiProtocol {
  NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}

class NotesApi implements NotesApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => loginHandle == LoginHandle.fooBar() ? mockNotes : null,
    );
  }
}
