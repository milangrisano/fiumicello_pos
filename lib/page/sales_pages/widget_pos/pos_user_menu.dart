import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/provider/auth_provider.dart';
import 'package:responsive_app/provider/theme_provider.dart';
import 'package:go_router/go_router.dart';

class PosUserMenu extends StatefulWidget {
  final bool isRightSide;
  const PosUserMenu({super.key, this.isRightSide = false});

  @override
  State<PosUserMenu> createState() => _PosUserMenuState();
}

class _PosUserMenuState extends State<PosUserMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _toggle() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _isOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward();
  }

  void _closeMenu() {
    setState(() {
      _isOpen = false;
    });
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void _handleLogout() {
    final auth = context.read<AuthProvider>();
    context.go('/');
    Future.microtask(() => auth.logout());
  }

  void _handleToggleTheme() {
    context.read<ThemeProvider>().toggleTheme();
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;
    final anchor = Offset(position.dx + size.width / 2 - 22, position.dy + size.height / 2 - 22);
    final bool currentDarkMode = context.read<ThemeProvider>().isDarkMode;

    return OverlayEntry(
      builder: (context) {
        return _RadialMenuOverlay(
          anchor: anchor,
          controller: _controller,
          onClose: _closeMenu,
          onLogout: _handleLogout,
          onToggleTheme: _handleToggleTheme,
          isDarkMode: currentDarkMode,
          isRightSide: widget.isRightSide,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      key: _key,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.onSurfaceVariant,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _toggle,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: _isOpen
                  ? Icon(
                      Icons.close,
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/images/fiumicello_hat.png',
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialMenuOverlay extends StatelessWidget {
  final Offset anchor;
  final AnimationController controller;
  final VoidCallback onClose;
  final VoidCallback onLogout;
  final VoidCallback onToggleTheme;
  final bool isDarkMode;
  final bool isRightSide;

  const _RadialMenuOverlay({
    required this.anchor,
    required this.controller,
    required this.onClose,
    required this.onLogout,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.isRightSide,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onClose,
            child: Container(color: Colors.transparent),
          ),
        ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final items = [
              _ActionItem(icon: Icons.logout, tooltip: 'Logout', action: onLogout),
              _ActionItem(icon: Icons.light_mode_outlined, tooltip: 'Theme', action: onToggleTheme, isThemeToggle: true),
              _ActionItem(
                icon: Icons.settings, 
                tooltip: 'Útiles', 
                action: () => context.go('/utilities'),
              ),
            ];

            return Stack(
              clipBehavior: Clip.none,
              children: [
                for (var i = 0; i < items.length; i++)
                  _buildRadialItem(context, i, items.length, items[i]),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRadialItem(BuildContext context, int index, int total, _ActionItem item) {
    // Si está a la izquierda (isRightSide = false), se despliega de la derecha (0) a abajo (pi/2).
    // Si está a la derecha (isRightSide = true), se despliega de abajo (pi/2) a la izquierda (pi).
    final startAngle = isRightSide ? (math.pi / 2) : 0.0;
    final angle = startAngle + (index / (total - 1)) * (math.pi / 2);
    final distance = 100.0 * Curves.easeOutBack.transform(controller.value);

    final x = math.cos(angle) * distance;
    final y = math.sin(angle) * distance;

    IconData icon = item.icon;
    if (item.isThemeToggle) {
      icon = isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined;
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      left: anchor.dx + x,
      top: anchor.dy + y,
      child: Transform.scale(
        scale: Curves.easeOut.transform(controller.value.clamp(0.0, 1.0)),
        child: Opacity(
          opacity: controller.value.clamp(0.0, 1.0),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: Tooltip(
              message: item.tooltip,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onClose();
                    item.action();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.onSurfaceVariant,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String tooltip;
  final VoidCallback action;
  final bool isThemeToggle;

  _ActionItem({
    required this.icon,
    required this.tooltip,
    required this.action,
    this.isThemeToggle = false,
  });
}
