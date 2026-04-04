import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/restaurant.dart';
import 'package:responsive_app/services/restaurant_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  final RestaurantService _service = RestaurantService();
  List<Restaurant> _restaurants = [];
  bool _isLoading = true;
  bool _hasError = false;

  bool get _hasPermissions {
    final roles = AuthProvider.instance.currentUser?.roles.map((r) => r.toLowerCase()).toList() ?? [];
    return roles.contains('super admin') || roles.contains('admin') || roles.contains('administrador');
  }

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    try {
      final data = await _service.getRestaurants();
      if (mounted) {
        setState(() {
          _restaurants = data;
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar restaurantes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_hasPermissions) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () => context.go('/utilities'),
          ),
          title: Text(
            'Acceso Denegado',
            style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24),
          ),
        ),
        body: Center(
          child: Text(
            'No tienes los permisos necesarios para ver esta página.',
            style: AppTextStyles.text(color: colorScheme.error, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/utilities'),
          tooltip: 'Volver a Útiles',
        ),
        title: Text(
          'Restaurantes',
          style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: PosUserMenu(isRightSide: true),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar la información',
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _hasError = false;
                          });
                          _fetchRestaurants();
                        },
                        child: Text('Reintentar', style: AppTextStyles.bold(color: colorScheme.onPrimary)),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gestión de Restaurantes',
                            style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 20),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showRestaurantDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Nuevo Restaurante'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                        child: DataTable(
                                          headingRowColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest.withOpacity(0.3)),
                                          dataRowColor: WidgetStateProperty.all(Colors.transparent),
                                          columns: [
                                            DataColumn(label: Text('Nombre', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                            DataColumn(label: Text('Ciudad', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                            DataColumn(label: Text('Dirección', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                            DataColumn(label: Text('Estado', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                            DataColumn(label: Text('Acciones', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                          ],
                                          rows: _restaurants.map((restaurant) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(restaurant.name, style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14))),
                                                DataCell(Text(restaurant.city.isNotEmpty ? restaurant.city : 'N/A', style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14))),
                                                DataCell(Text(restaurant.address ?? 'N/A', style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14))),
                                                DataCell(
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: restaurant.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: restaurant.isActive ? Colors.green : Colors.red,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      restaurant.isActive ? 'Activo' : 'Inactivo',
                                                      style: AppTextStyles.bold(
                                                        color: restaurant.isActive ? Colors.green : Colors.red,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons.edit, size: 20),
                                                        color: colorScheme.primary,
                                                        onPressed: () => _showRestaurantDialog(restaurant: restaurant),
                                                        tooltip: 'Editar',
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          restaurant.isActive ? Icons.toggle_on : Icons.toggle_off,
                                                          size: 24,
                                                        ),
                                                        color: restaurant.isActive ? Colors.green : Colors.grey,
                                                        onPressed: () => _toggleStatus(restaurant),
                                                        tooltip: restaurant.isActive ? 'Desactivar' : 'Activar',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _showRestaurantDialog({Restaurant? restaurant}) {
    final nameController = TextEditingController(text: restaurant?.name ?? '');
    final cityController = TextEditingController(text: restaurant?.city ?? '');
    final addressController = TextEditingController(text: restaurant?.address ?? '');
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final colorScheme = Theme.of(context).colorScheme;
            
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text(
                restaurant == null ? 'Nuevo Restaurante' : 'Editar Restaurante',
                style: AppTextStyles.bold(color: colorScheme.primary, fontSize: 20),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.primary)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: cityController,
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Ciudad',
                          labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.primary)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: addressController,
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Dirección (opcional)',
                          labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.primary)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: Text('Cancelar', style: AppTextStyles.bold(color: colorScheme.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final name = nameController.text.trim();
                          final city = cityController.text.trim();
                          final address = addressController.text.trim().isEmpty ? null : addressController.text.trim();

                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('El nombre es obligatorio')),
                            );
                            return;
                          }

                          setDialogState(() => isSaving = true);
                          try {
                            if (restaurant == null) {
                              await _service.createRestaurant(name, city, address);
                            } else {
                              await _service.updateRestaurant(restaurant.id, name, city, address);
                            }
                            if (mounted) {
                              Navigator.pop(context);
                              _fetchRestaurants();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(restaurant == null ? 'Restaurante creado' : 'Restaurante actualizado')),
                              );
                            }
                          } catch (e) {
                            setDialogState(() => isSaving = false);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text('Guardar', style: AppTextStyles.bold(color: colorScheme.onPrimary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _toggleStatus(Restaurant restaurant) async {
    final newStatus = !restaurant.isActive;
    try {
      await _service.updateRestaurantStatus(restaurant.id, newStatus);
      _fetchRestaurants();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restaurante ${newStatus ? 'activado' : 'desactivado'}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cambiar estado: $e')),
        );
      }
    }
  }
}
