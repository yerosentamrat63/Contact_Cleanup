import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../models/contact_item.dart';

class ContactService {
  static Future<bool> requestPermission() async {
    try {
      if (kIsWeb ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        // Desktop / Web simulated permission
        return true;
      }
      final status = await FlutterContacts.permissions.request(PermissionType.readWrite);
      return status == PermissionStatus.granted || status == PermissionStatus.limited;
    } catch (e) {
      debugPrint('Error requesting contact permission: $e');
      return true; // Fallback for desktop development
    }
  }

  static Future<bool> checkPermission() async {
    try {
      if (kIsWeb ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        return true;
      }
      return await FlutterContacts.permissions.has(PermissionType.read);
    } catch (e) {
      return true;
    }
  }

  static Future<List<ContactItem>> loadContacts() async {
    try {
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)) {
        final hasPermission =
            await FlutterContacts.permissions.has(PermissionType.read);
        if (!hasPermission) {
          final req = await FlutterContacts.permissions.request(PermissionType.readWrite);
          if (req != PermissionStatus.granted && req != PermissionStatus.limited) {
            return [];
          }
        }

        final contacts = await FlutterContacts.getAll(
          properties: {
            ContactProperty.name,
            ContactProperty.phone,
            ContactProperty.email,
          },
        );

        if (contacts.isNotEmpty) {
          final items =
              contacts.map((c) => ContactItem.fromFlutterContact(c)).toList();

          // Sort A to Z by display name
          items.sort((a, b) => a.displayName
              .toLowerCase()
              .compareTo(b.displayName.toLowerCase()));

          return items;
        }
      }
    } catch (e) {
      debugPrint('Error loading device contacts: $e');
    }

    // Fallback sample contacts if empty or running on desktop/web
    final sample = ContactItem.getSampleContacts();
    sample.sort((a, b) =>
        a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
    return sample;
  }

  static Future<int> deleteContacts(List<ContactItem> contactsToDelete) async {
    int deleted = 0;
    for (final item in contactsToDelete) {
      if (item.rawContact != null && item.rawContact!.id != null) {
        try {
          await FlutterContacts.delete(item.rawContact!.id!);
          deleted++;
        } catch (e) {
          debugPrint('Failed to delete contact ${item.displayName}: $e');
        }
      } else {
        // Sample contact deleted in simulation
        deleted++;
      }
    }
    return deleted;
  }
}
