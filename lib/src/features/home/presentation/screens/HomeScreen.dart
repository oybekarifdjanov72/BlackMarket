import 'dart:async';
import 'package:black_market/src/features/home/presentation/widget/FeaturedProductCard.dart';
import 'package:black_market/src/features/home/presentation/widget/ProductsGridWidget.dart';
import 'package:black_market/src/features/settings/cubit/SettingsCubit.dart';
import 'package:black_market/src/features/settings/cubit/SettingsState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:black_market/src/core/utils/responsive/AppResponsive.dart';
import 'package:black_market/src/core/consts/AppColors.dart';
import 'package:black_market/src/core/consts/AppRouter.dart';
import 'package:black_market/src/core/widget/ShimmerWidget.dart';
import 'package:black_market/src/features/profile/cubit/ProfileCubit.dart';
import 'package:black_market/src/features/profile/cubit/ProfileState.dart';
import '../cubit/HomeCubit.dart';
import '../cubit/HomeState.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final SearchController searchController = SearchController();
  final PageController pageController = PageController(viewportFraction: 0.85);
  Timer? _timer;

  List<TextSpan> _highlightMatch(
    String fullText,
    String query,
    Color themeColor,
  ) {
    if (query.isEmpty) {
      return [
        TextSpan(
          text: fullText,
          style: GoogleFonts.workSans(color: themeColor),
        ),
      ];
    }

    final lowerFullText = fullText.toLowerCase();
    final lowerQuery = query.toLowerCase();

    List<TextSpan> spans = [];
    int start = 0;

    while (true) {
      final index = lowerFullText.indexOf(lowerQuery, start);
      if (index < 0) {
        spans.add(
          TextSpan(
            text: fullText.substring(start),
            style: GoogleFonts.workSans(color: themeColor),
          ),
        );
        break;
      }

      if (index > start) {
        spans.add(
          TextSpan(
            text: fullText.substring(start, index),
            style: GoogleFonts.workSans(color: themeColor),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: fullText.substring(index, index + query.length),
          style: GoogleFonts.workSans(
            color: AppColors.instance.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      start = index + query.length;
    }

    return spans;
  }

  @override
  void initState() {
    super.initState();

    final homeCubit = context.read<HomeCubit>();
    if (homeCubit.state.products.isEmpty) {
      homeCubit.loadMore();
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        context.read<HomeCubit>().loadMore();
      }
    });

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients) {
        int nextPage = (pageController.page?.toInt() ?? 0) + 1;
        final itemCount = context.read<HomeCubit>().state.featuredProducts.length;
        if (itemCount > 0) {
          if (nextPage >= itemCount) nextPage = 0;
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutQuart,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    searchController.dispose();
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.isDarkMode;
        final themeColor = AppColors.instance.getTextPrimary(isDark);
        final bgColor = AppColors.instance.getBackground(isDark);
        final r = AppResponsive.of(context);

        return Scaffold(
          backgroundColor: bgColor,
          body: TapRegion(
            onTapOutside: (_) {
              context.read<HomeCubit>().hideSearchSuggestions();
              FocusScope.of(context).unfocus();
            },
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    RefreshIndicator(
                      color: AppColors.instance.cyanAccent,
                      onRefresh: () => context.read<HomeCubit>().refresh(),
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                        SliverAppBar(
                          floating: true,
                          snap: true,
                          backgroundColor: bgColor,
                          elevation: 0,
                          automaticallyImplyLeading: false,
                          centerTitle: false,
                          title: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              if (state.status == ProfileStatus.loading) {
                                return const ShimmerWidget();
                              }
                              final displayName = state.user?.fullName ?? 'Guest';
                              return Text(
                                'Hi, $displayName',
                                style: GoogleFonts.workSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: r.titleSize(22),
                                  color: themeColor,
                                  shadows: [
                                    Shadow(
                                      color: themeColor.withOpacity(0.8),
                                      blurRadius: 15,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(
                                CupertinoIcons.bell,
                                size: 24,
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(r.pagePadding.left, 6, r.pagePadding.right, 15),
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                context.read<HomeCubit>().search(value);
                                context.read<HomeCubit>().showSearchSuggestions();
                              },
                              onTap: () {
                                context.read<HomeCubit>().showSearchSuggestions();
                              },
                              style: GoogleFonts.workSans(color: themeColor),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                prefixIcon: Icon(
                                  CupertinoIcons.search,
                                  color: themeColor,
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  borderSide: BorderSide(
                                    color: themeColor.withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                labelText: "Tap for Search",
                                labelStyle: GoogleFonts.workSans(
                                  color: themeColor,
                                  shadows: [
                                    Shadow(
                                      color: themeColor.withOpacity(0.5),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    context.read<HomeCubit>().search("");
                                    context
                                        .read<HomeCubit>()
                                        .hideSearchSuggestions();
                                    FocusScope.of(context).unfocus();
                                  },
                                  icon: Icon(
                                    CupertinoIcons.clear,
                                    color: themeColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                          SliverToBoxAdapter(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: r.isTablet ? 24 : 12,
                                  ),

                                  ...[
                                    'All',
                                    'Beauty',
                                    'Daily',
                                    'Fashion',
                                    'Tech',
                                    'Furniture',
                                    'Watches',
                                  ].map((category) {
                                    final isSelected =
                                        state.selectedCategory == category;

                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: r.isTablet ? 8 : 6,
                                      ),
                                      child: ChoiceChip(
                                        label: Text(
                                          category,
                                          style: GoogleFonts.cabin(
                                            fontSize: r.isTablet ? 16 : 14,
                                            color: isSelected
                                                ? Colors.black
                                                : themeColor,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),

                                        selected: isSelected,

                                        onSelected: (_) {
                                          context
                                              .read<HomeCubit>()
                                              .selectCategory(category);
                                        },

                                        selectedColor:
                                        AppColors.instance.cyanAccent,

                                        backgroundColor: isDark
                                            ? AppColors.instance.shadeblack
                                            : Colors.grey[200],

                                        showCheckmark: false,

                                        padding: EdgeInsets.symmetric(
                                          horizontal: r.isTablet ? 14 : 12,
                                          vertical: r.isTablet ? 16 : 13,
                                        ),

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            r.isTablet ? 20 : 16,
                                          ),
                                          side: BorderSide(
                                            color: isSelected
                                                ? AppColors.instance.cyanAccent
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  SizedBox(
                                    width: r.isTablet ? 24 : 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                            child: Text(
                              "Recommendations:",
                              style: GoogleFonts.workSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeColor,
                                shadows: [
                                  Shadow(
                                    color: themeColor.withOpacity(0.8),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: state.featuredProducts.isNotEmpty
                              ? SizedBox(
                            width: double.infinity,
                                  height: r.featuredCarouselHeight,
                                  child: PageView.builder(
                                    controller: pageController,
                                    itemCount: state.featuredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = state.featuredProducts[index];
                                      return FeaturedProductCard(
                                        product: product,
                                        onTap: () {
                                          AppRouter.push(
                                            context,
                                            AppRoutes.sellPage,
                                            arguments: product,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: r.featuredCarouselHeight,
                                  child: PageView.builder(
                                    controller: PageController(viewportFraction: 0.9),
                                    itemCount: 3,
                                    itemBuilder: (context, index) => FeaturedCardShimmer(isDark: isDark),
                                  ),
                                ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                            child: Text(
                              "Best Sellers:",
                              style: GoogleFonts.workSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeColor,
                                shadows: [
                                  Shadow(
                                    color: themeColor.withOpacity(0.8),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(r.pagePadding.left, 0, r.pagePadding.right, 0),
                          sliver: ProductGrid(
                            isDark: isDark,
                            themeColor: themeColor,
                          ),
                        ),
                      ],
                    ),
                    ),
                    if (state.showSuggestions &&
                        state.filteredProducts.isNotEmpty)
                      Positioned(
                        left: 16,
                        right: 16,
                        top: 155,
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 250),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.instance.shadeblack
                                  : AppColors.instance.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: themeColor.withOpacity(0.5),
                              ),
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.filteredProducts.length.clamp(
                                0,
                                10,
                              ),
                              itemBuilder: (context, index) {
                                final item = state.filteredProducts[index];

                                return ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      children: _highlightMatch(
                                        "${item.title} (${item.brand})",
                                        searchController.text,
                                        themeColor,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    final searchText = item.title;

                                    searchController.text = searchText;

                                    context.read<HomeCubit>().search(
                                      searchText,
                                    );

                                    context
                                        .read<HomeCubit>()
                                        .hideSearchSuggestions();

                                    FocusScope.of(context).unfocus();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
