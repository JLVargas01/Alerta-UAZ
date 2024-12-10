abstract class ContactsEvent {}

class LoadContactList extends ContactsEvent {}

class SelectContact extends ContactsEvent {}

class RemoveContact extends ContactsEvent {
  final String idConfianza;
  RemoveContact(this.idConfianza);
}

class AddContact extends ContactsEvent {
  final String phoneNumber;
  final String nameContact;
  AddContact(this.phoneNumber, this.nameContact);
}
