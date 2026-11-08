import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/contact_item.dart';
import 'screens/coach_mark_overlay.dart';
import 'screens/done_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/permission_screen.dart';
import 'screens/review_screen.dart';
import 'screens/swipe_screen.dart';
import 'services/contact_service.dart';
import 'services/preferences_service.dart';
import 'theme/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.bone,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ContactCleanerApp());
}

class ContactCleanerApp extends StatelessWidget {
  const ContactCleanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Cleaner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bone,
        colorScheme: const ColorScheme.light(
          primary: AppColors.oliveDrab,
          surface: AppColors.floralWhite,
        ),
        useMaterial3: true,
      ),
      home: const MainCoordinator(),
    );
  }
}

enum AppStage {
  loading,
  onboarding,
  permission,
  swiping,
  reviewing,
  done,
}

class MainCoordinator extends StatefulWidget {
  const MainCoordinator({super.key});

  @override
  State<MainCoordinator> createState() => _MainCoordinatorState();
}

class _MainCoordinatorState extends State<MainCoordinator> {
  AppStage _stage = AppStage.loading;

  List<ContactItem> _contacts = [];
  int _currentIndex = 0;
  final List<bool> _decisions = [];

  bool _hasSeenOnboarding = false;
  bool _hasSeenCoachMark = false;
  bool _showCoachMarkOverlay = false;

  int _deletedCount = 0;
  int _keptCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeFlow();
  }

  Future<void> _initializeFlow() async {
    _hasSeenOnboarding = await PreferencesService.hasSeenOnboarding();
    _hasSeenCoachMark = await PreferencesService.hasSeenCoachMark();

    if (!_hasSeenOnboarding) {
      setState(() {
        _stage = AppStage.onboarding;
      });
      return;
    }

    final hasPermission = await ContactService.checkPermission();
    if (!hasPermission) {
      setState(() {
        _stage = AppStage.permission;
      });
      return;
    }

    await _loadContactsAndStart();
  }

  Future<void> _loadContactsAndStart() async {
    setState(() {
      _stage = AppStage.loading;
    });

    final contacts = await ContactService.loadContacts();

    if (contacts.isEmpty) {
      setState(() {
        _contacts = [];
        _deletedCount = 0;
        _keptCount = 0;
        _stage = AppStage.done;
      });
      return;
    }

    setState(() {
      _contacts = contacts;
      _currentIndex = 0;
      _decisions.clear();
      _showCoachMarkOverlay = !_hasSeenCoachMark;
      _stage = AppStage.swiping;
    });
  }

  void _onGetStartedFromOnboarding() async {
    await PreferencesService.setOnboardingSeen();
    _hasSeenOnboarding = true;

    final hasPermission = await ContactService.checkPermission();
    if (hasPermission) {
      await _loadContactsAndStart();
    } else {
      setState(() {
        _stage = AppStage.permission;
      });
    }
  }

  void _onAllowAccessFromPermission() async {
    final granted = await ContactService.requestPermission();
    if (granted) {
      await _loadContactsAndStart();
    }
  }

  void _onCoachMarkDismissed() async {
    await PreferencesService.setCoachMarkSeen();
    setState(() {
      _hasSeenCoachMark = true;
      _showCoachMarkOverlay = false;
    });
  }

  void _onDecision(bool isDelete) {
    setState(() {
      _decisions.add(isDelete);
      _currentIndex++;

      if (_currentIndex >= _contacts.length) {
        _stage = AppStage.reviewing;
      }
    });
  }

  void _onUndo() {
    if (_decisions.isNotEmpty && _currentIndex > 0) {
      setState(() {
        _decisions.removeLast();
        _currentIndex--;
      });
    }
  }

  void _onBackFromReview() {
    if (_decisions.isNotEmpty && _currentIndex > 0) {
      setState(() {
        _decisions.removeLast();
        _currentIndex--;
        _stage = AppStage.swiping;
      });
    } else {
      setState(() {
        _stage = AppStage.swiping;
      });
    }
  }

  void _onConfirmDelete(List<ContactItem> toDelete) async {
    setState(() {
      _stage = AppStage.loading;
    });

    final deleted = await ContactService.deleteContacts(toDelete);

    setState(() {
      _deletedCount = deleted;
      _keptCount = _contacts.length - deleted;
      _stage = AppStage.done;
    });
  }

  void _onStartOver() {
    setState(() {
      _currentIndex = 0;
      _decisions.clear();
      _stage = AppStage.swiping;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _buildStageScreen(),
    );
  }

  Widget _buildStageScreen() {
    switch (_stage) {
      case AppStage.loading:
        return const Scaffold(
          backgroundColor: AppColors.bone,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.oliveDrab),
          ),
        );

      case AppStage.onboarding:
        return OnboardingScreen(
          key: const ValueKey('onboarding'),
          onGetStarted: _onGetStartedFromOnboarding,
        );

      case AppStage.permission:
        return PermissionScreen(
          key: const ValueKey('permission'),
          onAllowAccess: _onAllowAccessFromPermission,
        );

      case AppStage.swiping:
        return Stack(
          key: const ValueKey('swiping'),
          children: [
            SwipeScreen(
              contacts: _contacts,
              currentIndex: _currentIndex,
              decisions: _decisions,
              onDecision: _onDecision,
              onUndo: _onUndo,
              onFinish: () {
                setState(() {
                  _stage = AppStage.reviewing;
                });
              },
            ),
            if (_showCoachMarkOverlay)
              CoachMarkOverlay(
                onDismiss: _onCoachMarkDismissed,
              ),
          ],
        );

      case AppStage.reviewing:
        final markedContacts = <ContactItem>[];
        for (int i = 0; i < _decisions.length && i < _contacts.length; i++) {
          if (_decisions[i]) {
            markedContacts.add(_contacts[i]);
          }
        }

        return ReviewScreen(
          key: const ValueKey('reviewing'),
          markedContacts: markedContacts,
          onBackToSwipe: _onBackFromReview,
          onConfirmDelete: _onConfirmDelete,
        );

      case AppStage.done:
        return DoneScreen(
          key: const ValueKey('done'),
          deletedCount: _deletedCount,
          keptCount: _keptCount,
          onStartOver: _onStartOver,
        );
    }
  }
}
