import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../controllers/shift_controller.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'home_screen.dart';
import 'calendar_screen.dart';
import 'reports_screen.dart';

class MainScreen extends StatefulWidget {
  final ShiftController? controller;

  const MainScreen({
    super.key,
    this.controller,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final ShiftController _controller;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ShiftController();
    _controller.addListener(_onControllerUpdate);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onControllerUpdate);
    }
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomeScreen(
            controller: _controller,
            onOpenCalendar: () => _onTabTapped(1),
          ),
          CalendarScreen(
            controller: _controller,
            onBack: () => _onTabTapped(0),
          ),
          ReportsScreen(
            controller: _controller,
            onBack: () => _onTabTapped(0),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
