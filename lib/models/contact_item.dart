import 'package:flutter_contacts/flutter_contacts.dart';

class ContactItem {
  final String id;
  final String displayName;
  final List<String> phones;
  final List<String> emails;
  final Contact? rawContact;

  ContactItem({
    required this.id,
    required this.displayName,
    required this.phones,
    required this.emails,
    this.rawContact,
  });

  String get initial {
    if (displayName.trim().isNotEmpty) {
      return displayName.trim()[0].toUpperCase();
    }
    return '?';
  }

  factory ContactItem.fromFlutterContact(Contact contact) {
    String name = '';
    if (contact.displayName != null && contact.displayName!.trim().isNotEmpty) {
      name = contact.displayName!.trim();
    } else if (contact.name != null) {
      final first = contact.name!.first ?? '';
      final last = contact.name!.last ?? '';
      name = '$first $last'.trim();
    }

    if (name.isEmpty) {
      name = 'Unnamed Contact';
    }

    final phones = contact.phones
        .map((p) => p.number.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    final emails = contact.emails
        .map((e) => e.address.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return ContactItem(
      id: contact.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      displayName: name,
      phones: phones,
      emails: emails,
      rawContact: contact,
    );
  }

  static List<ContactItem> getSampleContacts() {
    return [
      ContactItem(
        id: 'sample-1',
        displayName: 'Dawit Alemu',
        phones: ['+251 91 123 4567', '+251 92 888 1234'],
        emails: ['dawit.alemu@example.com'],
      ),
      ContactItem(
        id: 'sample-2',
        displayName: 'Tigist Haile',
        phones: ['+251 91 555 7890'],
        emails: [],
      ),
      ContactItem(
        id: 'sample-3',
        displayName: 'Yohannes Mengistu',
        phones: ['+251 93 456 7890', '+251 94 111 2233'],
        emails: ['ymengistu@domain.org'],
      ),
      ContactItem(
        id: 'sample-4',
        displayName: 'Senait Tadesse',
        phones: ['+251 91 222 3344'],
        emails: ['senait@design.co'],
      ),
      ContactItem(
        id: 'sample-5',
        displayName: 'Bereket Bekele',
        phones: ['+251 92 333 4455'],
        emails: [],
      ),
      ContactItem(
        id: 'sample-6',
        displayName: 'Helen Gebre',
        phones: ['+251 91 777 8899', '+251 93 999 0011'],
        emails: ['helen.g@work.et'],
      ),
      ContactItem(
        id: 'sample-7',
        displayName: 'Kassahun Desta',
        phones: ['+251 94 555 6677'],
        emails: ['kassahun@desta.com'],
      ),
      ContactItem(
        id: 'sample-8',
        displayName: 'Lydia Solomon',
        phones: ['+251 91 888 9900'],
        emails: [],
      ),
    ];
  }
}
