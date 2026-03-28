import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/database_helper.dart';
import '../../data/repositories/hive_database_helper.dart';
import '../../data/models/wine_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/search_history_model.dart';
import '../../ui/components/vivino_components.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  
  // Data holders
  List<Wine> _wines = [];
  List<SearchHistory> _searchHistory = [];
  User? _user;
  VaultStats? _vaultStats;
  String _dbType = 'Unknown';
  Map<String, dynamic> _hiveStats = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    
    try {
      // Determine which database is being used
      if (kIsWeb) {
        _dbType = 'SQLite (Web/IndexedDB)';
      } else {
        _dbType = 'SQLite (Native)';
      }

      // Load from primary database
      final dbHelper = DatabaseHelper();
      _wines = await dbHelper.getAllWines();
      _searchHistory = await dbHelper.getSearchHistory(limit: 100);
      _user = await dbHelper.getUser();
      _vaultStats = await dbHelper.getVaultStats();

      // Load Hive stats (backup/cache database)
      final hiveHelper = HiveDatabaseHelper();
      _hiveStats = await hiveHelper.getStats();
      
    } catch (e) {
      debugPrint('Error loading debug data: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text('This will delete all wines, search history, and user settings. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: VivinoColors.primary),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await DatabaseHelper().clearAll();
        await HiveDatabaseHelper().clearAll();
        await _loadAllData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All data cleared')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error clearing data: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VivinoColors.background,
      appBar: AppBar(
        title: const Text('Database Debug'),
        backgroundColor: Colors.white,
        foregroundColor: VivinoColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: _clearAllData,
            tooltip: 'Clear All Data',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: VivinoColors.primary,
          unselectedLabelColor: VivinoColors.textSecondary,
          indicatorColor: VivinoColors.primary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Wines'),
            Tab(text: 'History'),
            Tab(text: 'User'),
            Tab(text: 'Raw JSON'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildWinesTab(),
                _buildHistoryTab(),
                _buildUserTab(),
                _buildRawJsonTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: 'Database Info',
            children: [
              _buildInfoRow('Database Type', _dbType),
              _buildInfoRow('Platform', kIsWeb ? 'Web (IndexedDB)' : 'Native'),
              const Divider(),
              _buildInfoRow('Total Wines', _wines.length.toString()),
              _buildInfoRow('Search History', _searchHistory.length.toString()),
              _buildInfoRow('User Configured', _user != null ? 'Yes' : 'No'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Vault Stats',
            children: [
              _buildInfoRow('Total Scans', (_vaultStats?.totalScans ?? 0).toString()),
              _buildInfoRow('Total Face Earned', (_vaultStats?.totalFaceEarned ?? 0).toStringAsFixed(1)),
              _buildInfoRow('Total Value', '\$${(_vaultStats?.totalScannedValue ?? 0).toStringAsFixed(0)}'),
              _buildInfoRow('Top Cuisine', _vaultStats?.mostScannedCuisine ?? '-'),
              _buildInfoRow('Consumption Tier', _vaultStats?.topConsumptionTier ?? '-'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Hive Cache Stats',
            children: [
              _buildInfoRow('Cached Wines', (_hiveStats['cachedWines'] ?? 0).toString()),
              _buildInfoRow('History Items', (_hiveStats['historyCount'] ?? 0).toString()),
              _buildInfoRow('User Cached', (_hiveStats['hasUser'] ?? false) ? 'Yes' : 'No'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWinesTab() {
    if (_wines.isEmpty) {
      return const Center(
        child: Text(
          'No wines saved yet',
          style: TextStyle(color: VivinoColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: _wines.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final wine = _wines[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(
              wine.identity.fullName.isNotEmpty ? wine.identity.fullName : 'Unknown Wine',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${wine.identity.region} • ${wine.identity.wineType}',
              style: const TextStyle(fontSize: 12, color: VivinoColors.textSecondary),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('ID', wine.id ?? '-'),
                    _buildInfoRow('Fingerprint', wine.fingerprint),
                    _buildInfoRow('Producer', wine.identity.producer),
                    _buildInfoRow('Vintage', wine.identity.vintage),
                    _buildInfoRow('Grapes', wine.identity.grapes.join(', ')),
                    _buildInfoRow('Price', '\$${wine.benchmarks.averagePrice.toStringAsFixed(0)} ${wine.benchmarks.priceCurrency}'),
                    _buildInfoRow('Global Rank', 'Top ${wine.benchmarks.globalTopPercent}%'),
                    _buildInfoRow('Created', wine.createdAt?.toString() ?? '-'),
                    const SizedBox(height: 8),
                    const Text('Full JSON:', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        const JsonEncoder.withIndent('  ').convert(wine.toJson()),
                        style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    if (_searchHistory.isEmpty) {
      return const Center(
        child: Text(
          'No search history yet',
          style: TextStyle(color: VivinoColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchHistory.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final history = _searchHistory[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: VivinoColors.primary.withValues(alpha: 0.1),
              child: Text(
                '${index + 1}',
                style: TextStyle(color: VivinoColors.primary, fontSize: 12),
              ),
            ),
            title: Text(
              history.wineName ?? 'Unknown Wine',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cuisine: ${history.cuisineContext ?? '-'} • Budget: \$${history.budgetContext ?? '-'}',
                  style: const TextStyle(fontSize: 11),
                ),
                Text(
                  'Face: ${history.faceEarned?.toStringAsFixed(1) ?? '0.0'} • ${history.scannedAt.toString().substring(0, 16)}',
                  style: const TextStyle(fontSize: 11, color: VivinoColors.textSecondary),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildUserTab() {
    if (_user == null) {
      return const Center(
        child: Text(
          'No user configured yet',
          style: TextStyle(color: VivinoColors.textSecondary),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSectionCard(
            title: 'User Profile',
            children: [
              _buildInfoRow('ID', _user!.id.toString()),
              _buildInfoRow('Occupation', _user!.occupation),
              _buildInfoRow('Typical Budget', '\$${_user!.typicalBudget}'),
              _buildInfoRow('Consumption Tier', _user!.consumptionTier),
              _buildInfoRow('Created', _user!.createdAt?.toString() ?? '-'),
              _buildInfoRow('Updated', _user!.updatedAt?.toString() ?? '-'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            title: 'Raw User JSON',
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  const JsonEncoder.withIndent('  ').convert(_user!.toJson()),
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRawJsonTab() {
    final allData = {
      'databaseType': _dbType,
      'platform': kIsWeb ? 'web' : 'native',
      'timestamp': DateTime.now().toIso8601String(),
      'wines': _wines.map((w) => w.toJson()).toList(),
      'searchHistory': _searchHistory.map((h) => h.toJson()).toList(),
      'user': _user?.toJson(),
      'vaultStats': _vaultStats != null ? {
        'totalScans': _vaultStats!.totalScans,
        'totalFaceEarned': _vaultStats!.totalFaceEarned,
        'totalScannedValue': _vaultStats!.totalScannedValue,
        'mostScannedCuisine': _vaultStats!.mostScannedCuisine,
        'topConsumptionTier': _vaultStats!.topConsumptionTier,
        'recentScansCount': _vaultStats!.recentScans.length,
      } : null,
      'hiveStats': _hiveStats,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Copy to clipboard would go here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('JSON copied to clipboard (simulated)')),
                  );
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy All JSON'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(allData),
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                color: Colors.greenAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: VivinoColors.primary,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: VivinoColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
