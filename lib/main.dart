import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'l10n/app_localizations.dart';
import 'core/constants/app_constants.dart';
import 'providers/user_provider.dart';
import 'providers/wine_provider.dart';
import 'providers/vault_provider.dart';
import 'providers/language_provider.dart';
import 'features/context/context_screen.dart';
import 'features/scanner/scanner_screen.dart';
import 'features/vault/vault_screen.dart';
import 'features/debug/debug_screen.dart';
import 'ui/components/vivino_components.dart';

// Database
import 'data/repositories/hive_database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await HiveDatabaseHelper().init();

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
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('zh', 'TW'),
            ],
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: VivinoColors.background,
              colorScheme: const ColorScheme.light(
                primary: VivinoColors.primary,
                surface: VivinoColors.surface,
                onSurface: VivinoColors.textPrimary,
                onPrimary: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: VivinoColors.textPrimary),
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: VivinoColors.textPrimary,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: VivinoColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            home: const MainNavigationScreen(),
          );
        },
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

  void _navigateToDebug() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DebugScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const ContextScreen(),
      const ScannerScreen(),
      VaultScreen(onNavigateToScan: _navigateToScan),
    ];

    return Scaffold(
      backgroundColor: VivinoColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _currentIndex == 0 
            ? 'Context' 
            : _currentIndex == 1 
              ? 'Scan Wine' 
              : 'Vault',
          style: const TextStyle(
            color: VivinoColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report, color: VivinoColors.textSecondary),
            onPressed: _navigateToDebug,
            tooltip: 'Debug',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: VivinoColors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
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
              color: isActive ? VivinoColors.primary : VivinoColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? VivinoColors.primary : VivinoColors.textTertiary,
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
                ? [VivinoColors.primary, VivinoColors.primary.withOpacity(0.8)]
                : [VivinoColors.surface, VivinoColors.surfaceLight],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: VivinoColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Icon(
          Icons.document_scanner,
          color: isActive ? Colors.white : VivinoColors.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}
