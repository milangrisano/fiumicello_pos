import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/content/content_guest.dart';
import 'package:responsive_app/models/restaurant.dart';
import 'package:responsive_app/provider/auth_provider.dart';
import 'package:responsive_app/services/restaurant_service.dart';
import 'package:go_router/go_router.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage>
    with SingleTickerProviderStateMixin {
  final RestaurantService _restaurantService = RestaurantService();
  List<Restaurant> _activeRestaurants = [];
  bool _isLoading = true;
  bool _hasError = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _fetchActiveRestaurants();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchActiveRestaurants() async {
    try {
      final restaurants = await _restaurantService.getRestaurants();
      if (!mounted) return;
      setState(() {
        _activeRestaurants = restaurants.where((r) => r.isActive).toList();
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.goldDark,
                      AppColors.goldHighlightDark,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldDark.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  size: 48,
                  color: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                ),
              ),
              const SizedBox(height: 32),

              // Welcome title
              Text(
                ContentGuest.welcomeTitle,
                style: AppTextStyles.bold(
                  fontSize: 28,
                  color: isDark
                      ? AppColors.primaryTextDark
                      : AppColors.primaryTextLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(
                  ContentGuest.welcomeSubtitle,
                  style: AppTextStyles.text(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.secondaryTextDark
                        : AppColors.secondaryTextLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),

              // Restaurants list / Loading / Error
              if (_isLoading)
                CircularProgressIndicator(color: AppColors.goldDark)
              else if (_hasError)
                _buildErrorState(colorScheme, isDark)
              else
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildRestaurantButtons(isDark),
                ),



              // Logout button
              TextButton.icon(
                onPressed: () async {
                  await AuthProvider.instance.logout();
                  if (!context.mounted) return;
                  context.go('/');
                },
                icon: Icon(Icons.logout_rounded,
                    color: colorScheme.error, size: 18),
                label: Text(
                  ContentGuest.logoutButton,
                  style: AppTextStyles.w500(
                    color: colorScheme.error,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantButtons(bool isDark) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          Text(
            'Sucursales Disponibles',
            style: AppTextStyles.bold(
              fontSize: 16,
              color:
                  isDark ? AppColors.mutedTextDark : AppColors.mutedTextLight,
            ),
          ),
          const SizedBox(height: 20),
          ..._activeRestaurants.map((restaurant) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                child: _RestaurantCard(
                  restaurant: restaurant,
                  isDark: isDark,
                  onTap: () {
                    // Sin función por ahora
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme, bool isDark) {
    return Column(
      children: [
        Icon(Icons.cloud_off, size: 56, color: colorScheme.error),
        const SizedBox(height: 16),
        Text(
          'No se pudieron cargar las sucursales.',
          style: AppTextStyles.text(
            color: isDark
                ? AppColors.secondaryTextDark
                : AppColors.secondaryTextLight,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
            _fetchActiveRestaurants();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.goldDark,
            foregroundColor:
                isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.refresh),
          label: Text('Reintentar', style: AppTextStyles.bold()),
        ),
      ],
    );
  }
}

class _RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final bool isDark;
  final VoidCallback onTap;

  const _RestaurantCard({
    required this.restaurant,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<_RestaurantCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isDark
                  ? [
                      AppColors.cardDefaultStartDark,
                      AppColors.cardDefaultEndDark,
                    ]
                  : [
                      AppColors.cardDefaultStartLight,
                      AppColors.cardDefaultEndLight,
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? AppColors.goldDark
                  : widget.isDark
                      ? AppColors.surfaceDark
                      : AppColors.borderLight,
              width: _isHovered ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.goldDark.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: _isHovered ? 20 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldDark.withValues(alpha: 0.15),
                ),
                child: Icon(
                  Icons.restaurant_rounded,
                  color: AppColors.goldDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurant.name,
                      style: AppTextStyles.bold(
                        fontSize: 16,
                        color: AppColors.primaryTextDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.restaurant.city}${widget.restaurant.address != null ? ' · ${widget.restaurant.address}' : ''}',
                      style: AppTextStyles.text(
                        fontSize: 13,
                        color: AppColors.secondaryTextDark,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color:
                    _isHovered ? AppColors.goldDark : AppColors.mutedTextDark,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
