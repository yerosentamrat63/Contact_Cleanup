import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:contact_cleaner/models/contact_item.dart';
import 'package:contact_cleaner/screens/coach_mark_overlay.dart';
import 'package:contact_cleaner/screens/onboarding_screen.dart';
import 'package:contact_cleaner/screens/permission_screen.dart';
import 'package:contact_cleaner/screens/swipe_screen.dart';
import 'package:contact_cleaner/screens/review_screen.dart';
import 'package:contact_cleaner/screens/done_screen.dart';
import 'package:contact_cleaner/widgets/app_buttons.dart';
import 'package:contact_cleaner/widgets/app_checkbox.dart';

void main() {
  final sampleContacts = [
    ContactItem(
      id: 'c1',
      displayName: 'Dawit Alemu',
      phones: ['+251 91 123 4567', '+251 92 888 1234'],
      emails: ['dawit@example.com'],
    ),
    ContactItem(
      id: 'c2',
      displayName: 'Tigist Haile',
      phones: ['+251 91 555 7890'],
      emails: [],
    ),
    ContactItem(
      id: 'c3',
      displayName: 'Yohannes Mengistu',
      phones: ['+251 93 456 7890'],
      emails: ['ymengistu@domain.org'],
    ),
  ];

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Onboarding Screen renders all copy and triggers callback',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool started = false;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(onGetStarted: () => started = true),
      ),
    );

    expect(find.text('Contact Cleaner'), findsOneWidget);
    expect(find.text('HOW IT WORKS'), findsOneWidget);
    expect(find.text('Clean your contacts,\none swipe at a time.'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('Swipe through them'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
    expect(find.text('Review your picks'), findsOneWidget);
    expect(find.text('03'), findsOneWidget);
    expect(find.text('Delete them all'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('NEEDS ACCESS TO YOUR CONTACTS'), findsOneWidget);

    final buttonFinder = find.text('Get started');
    await tester.ensureVisible(buttonFinder);
    await tester.pumpAndSettle();
    await tester.tap(buttonFinder);
    await tester.pump();
    expect(started, isTrue);
  });

  testWidgets('Permission Screen renders copy and triggers callback',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool allowed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionScreen(onAllowAccess: () => allowed = true),
      ),
    );

    expect(find.text('Contacts access needed'), findsOneWidget);
    expect(
      find.text(
        'To show and delete your contacts, the app needs permission to read and edit them.',
      ),
      findsOneWidget,
    );
    expect(find.text('Allow access'), findsOneWidget);

    await tester.tap(find.text('Allow access'));
    await tester.pump();
    expect(allowed, isTrue);
  });

  testWidgets('Swipe Screen displays card details, counter, or swipe hint, and handles action buttons',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool? lastDecision;
    bool undoTapped = false;
    bool reviewNowTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeScreen(
          contacts: sampleContacts,
          currentIndex: 1,
          decisions: const [true], // 1 marked for deletion
          onDecision: (isDelete) => lastDecision = isDelete,
          onUndo: () => undoTapped = true,
          onReviewNow: () => reviewNowTapped = true,
          onFinish: () {},
        ),
      ),
    );

    // Header counter
    expect(find.text('2'), findsOneWidget);
    expect(find.text('OF 3'), findsOneWidget);

    // Front card content for index 1
    expect(find.text('Tigist Haile'), findsOneWidget);
    expect(find.text('+251 91 555 7890'), findsOneWidget);

    // "or swipe" guide text
    expect(find.text('or swipe'), findsOneWidget);

    // "Review (1)" shortcut button
    expect(find.text('Review (1)'), findsOneWidget);
    await tester.tap(find.text('Review (1)'));
    await tester.pump();
    expect(reviewNowTapped, isTrue);

    // Tap Undo
    await tester.tap(find.bySemanticsLabel('Undo last swipe'));
    await tester.pump();
    expect(undoTapped, isTrue);

    // Action buttons
    expect(find.text('KEEP'), findsOneWidget);
    expect(find.text('DELETE'), findsOneWidget);

    // Tap Keep and pump frames through animation
    await tester.tap(find.text('KEEP'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 50));
    expect(lastDecision, isFalse);
  });

  testWidgets('Coach Mark Overlay renders without yellow underlines and dismisses cleanly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool dismissed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoachMarkOverlay(
            onDismiss: () => dismissed = true,
          ),
        ),
      ),
    );

    expect(find.text('QUICK TIP'), findsOneWidget);
    expect(find.text('Swipe to decide'), findsOneWidget);
    expect(
      find.text('Drag a card right to delete, left to keep. Nothing is removed until you confirm.'),
      findsOneWidget,
    );
    expect(find.text('Got it'), findsOneWidget);

    // Verify it is inside Material (no yellow underline issue)
    final textWidget = tester.widget<Text>(find.text('Swipe to decide'));
    expect(textWidget.style?.decoration, isNot(TextDecoration.underline));

    // Tap Got it
    await tester.tap(find.text('Got it'));
    await tester.pump();
    expect(dismissed, isTrue);
  });

  testWidgets('Review Screen toggles checkboxes, live count, and tick-all',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool backTapped = false;
    List<ContactItem>? deletedContacts;

    await tester.pumpWidget(
      MaterialApp(
        home: ReviewScreen(
          markedContacts: [sampleContacts[0], sampleContacts[1]],
          onBackToSwipe: () => backTapped = true,
          onConfirmDelete: (list) => deletedContacts = list,
        ),
      ),
    );

    expect(find.text('Review'), findsOneWidget);
    expect(find.text('UNTICK ANY YOU WANT TO KEEP'), findsOneWidget);
    expect(find.text('2 OF 2 SELECTED'), findsOneWidget);
    expect(find.text('Untick all'), findsOneWidget);
    expect(find.text('Delete 2 contacts'), findsOneWidget);

    // Untick one contact
    await tester.tap(find.byType(AppCheckbox).first);
    await tester.pump();

    expect(find.text('1 OF 2 SELECTED'), findsOneWidget);
    expect(find.text('Tick all'), findsOneWidget);
    expect(find.text('Delete 1 contact'), findsOneWidget);

    // Tap Tick all
    await tester.tap(find.text('Tick all'));
    await tester.pump();

    expect(find.text('2 OF 2 SELECTED'), findsOneWidget);
    expect(find.text('Untick all'), findsOneWidget);

    // Test back button
    await tester.tap(find.bySemanticsLabel('Back to swiping').hitTestable());
    await tester.pump();
    expect(backTapped, isTrue);

    // Test Confirm Deletion Sheet flow
    await tester.tap(find.text('Delete 2 contacts'));
    await tester.pumpAndSettle();

    expect(find.text('Delete 2 contacts?'), findsOneWidget);
    expect(find.text('THIS CANNOT BE UNDONE'), findsOneWidget);

    // Tap Delete inside bottom sheet
    await tester.tap(find.widgetWithText(PrimaryButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(deletedContacts, isNotNull);
    expect(deletedContacts!.length, 2);
  });

  testWidgets('Done Screen displays stats and Start over button',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool startOverTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: DoneScreen(
          deletedCount: 2,
          keptCount: 6,
          onStartOver: () => startOverTapped = true,
        ),
      ),
    );

    expect(find.text('Deleted 2 contacts'), findsOneWidget);
    expect(find.text('YOUR CONTACT LIST IS CLEANER NOW'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('DELETED'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('KEPT'), findsOneWidget);
    expect(find.text('Start over'), findsOneWidget);

    await tester.tap(find.text('Start over'));
    await tester.pump();
    expect(startOverTapped, isTrue);
  });
}
