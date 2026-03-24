import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'providers/user_provider.dart';
import 'providers/wine_provider.dart';
import 'providers/vault_provider.dart';
import 'features/context/context_screen.dart';
import 'features/scanner/scanner_screen.dart';
import 'features/vault/vault_screen.dart';

// Web database factory
import 'db_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize web database factory
  await initDatabaseFactory();

  // Load .env (gracefully handle missing file)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    debugPrint('No .env file found, using dart-define for API key');
  }

  runApp(const WineAIApp());
}

class WineAIApp extends StatelessWidget {
  const WineAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    // API key from .env or --dart-define
    final apiKey = dotenv.env['KIMI_API_KEY'] ??
        const String.fromEnvironment('KIMI_API_KEY', defaultValue: '');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => WineProvider(apiKey: apiKey)),
        ChangeNotifierProvider(create: (_) => VaultProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToScan() {
    setState(() => _currentIndex = 1);
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const ContextScreen(),
      const ScannerScreen(),
      VaultScreen(onNavigateToScan: _navigateToScan),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: AppConstants.tabContext,
                  index: 0,
                ),
                _buildScanButton(),
                _buildNavItem(
                  icon: Icons.folder_outlined,
                  activeIcon: Icons.folder,
                  label: AppConstants.tabVault,
                  index: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.accent : AppTheme.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.accent : AppTheme.textTertiary,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    final isActive = _currentIndex == 1;

    return GestureDetector(
      onTap: _navigateToScan,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isActive
                ? [AppTheme.accent, AppTheme.accentLight]
                : [AppTheme.surfaceLight, AppTheme.surfaceLighter],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withAlpha(102),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(
          Icons.document_scanner,
          color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}
