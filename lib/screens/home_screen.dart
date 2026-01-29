import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dirkan/providers/fish_provider.dart';
import 'package:dirkan/theme/app_theme.dart';
import 'package:dirkan/widgets/product_card.dart';
import 'package:dirkan/screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    final fishProvider = Provider.of<FishProvider>(context);
    final allItems = fishProvider.items;

    // Filter items based on category
    final filteredItems = _selectedCategory == 'Semua'
        ? allItems
        : allItems.where((item) => item.category == _selectedCategory).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar & Search
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            title: Row(
              children: [
                const Icon(Icons.set_meal, color: AppTheme.primary, size: 32),
                const SizedBox(width: 8),
                Text(
                  'Ikan Hias',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF234248)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
                      hintText: 'Cari ikan hias favoritmu...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF92C0C9)
                            : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: ['Semua', 'Betta', 'Goldfish', 'Koi', 'Discus', 'Arwana']
                        .map((category) => _buildCategoryChip(category))
                        .toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Banners
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildBanner(
                        'Kontes Betta Nasional 2024',
                        'Daftar sekarang • Jakarta',
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCMxCyEsW4Tric3--Qmm1wdWh4a0xa8QpPT9CHsa-DMZs71GcMLhxZOh1D6VMGKkEXimdIZju0HBsbxZ_o9gsBU2HwcATNZ4JpnbIuWLvXu9b553I3zku9i7lgKedLyy19y_1JelzUWHzacuL97Ws4JMMPQNO1B8xsuGPWZYmu1YSNDDInSBKApZ6cN0IPl2l27F3eb6Fmsq2TRVQ6jvb7YCjKIQubszns5NS0x7vfxYkOI9Le7RWrZLlbobIWzsKJn_5ySXVp2OW4',
                      ),
                      const SizedBox(width: 16),
                      _buildBanner(
                        'Promo Pakan & Vitamin',
                        'Diskon hingga 20%',
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDhv9HyPelfNR99RO8zmHUX44GZSZaK2VMtIqpUN0AcOgCoOgzn2dieX3ai_cgTRnz06PkumMcsp5-8npuAykacfLJWN8ovznYozNbxyVljLxK40OUC3D4-FL0-jaFCb_yypB1R4MbrPYBhdkFnvyfO5wfIvupKd6qVwoA_7a2M7cMXQY3AHcYBm9xrY6aF2KwsewsotUmpv98a7J1jmQY3J2Hz-S6HerUChJ-huvclQIqKWhbRQDvTNtX6HyXOmc6vXeei1UWKsNM',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Eksplorasi Ikan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductCard(
                    fish: filteredItems[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(fish: filteredItems[index]),
                        ),
                      );
                    },
                  );
                },
                childCount: filteredItems.length,
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary
                : Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF234248)
                    : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.transparent
                      : Colors.grey[200]!,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner(String title, String subtitle, String imageUrl) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 158, // Aspect ratio 16:9 approx
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF92C0C9)
                        : Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
