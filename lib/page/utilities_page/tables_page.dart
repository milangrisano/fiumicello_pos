import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/table.dart';
import 'package:responsive_app/services/table_service.dart';
import 'package:responsive_app/services/restaurant_service.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  final TableService _tableService = TableService();

  List<TableModel> _tables = [];
  bool _isLoading = true;
  String? _restaurantId;

  // Track dragging state locally for fluid UI before saving
  Map<int, Offset> _dragOffsets = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      
      // We will just use the first available restaurant for simplicity, 
      // or no restaurant if none available (though backend might require it).
      // Future improvement: Add a dropdown to select the restaurant workspace.
      final restaurantService = RestaurantService();
      final restaurants = await restaurantService.getRestaurants();
      if (restaurants.isNotEmpty) {
        _restaurantId = restaurants.first.id;
      }
      
      final tables = await _tableService.getTables();
      
      if (mounted) {
        setState(() {
          _tables = tables;
          _dragOffsets.clear();
          for (var t in _tables) {
            _dragOffsets[t.id] = Offset(t.x, t.y);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar mesas: $e')));
      }
    }
  }

  Future<void> _addTable() async {
    if (_restaurantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: No estás asignado a un restaurante.')));
      return;
    }

    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Mesa / Ubicación'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Ej. Mesa 1, Barra, Terraza 3'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      try {
        final newTable = await _tableService.createTable(name, _restaurantId!, 50, 50); // Mínimo margen
        setState(() {
          _tables.add(newTable);
          _dragOffsets[newTable.id] = const Offset(50, 50);
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al crear mesa: $e')));
        }
      }
    }
  }

  Future<void> _deleteTable(int id) async {
    try {
      await _tableService.deleteTable(id);
      setState(() {
        _tables.removeWhere((t) => t.id == id);
        _dragOffsets.remove(id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mesa eliminada')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar mesa: $e')));
      }
    }
  }

  Future<void> _saveLayout() async {
    try {
      setState(() => _isLoading = true);
      // Actualizamos todas las mesas que cambiaron de posición
      for (final table in _tables) {
        final offset = _dragOffsets[table.id] ?? Offset(table.x, table.y);
        // Sólo guarda si varió algo para optimizar peticiones
        if (offset.dx != table.x || offset.dy != table.y) {
          await _tableService.updateTable(table.id, offset.dx, offset.dy);
        }
      }
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plano guardado exitosamente.')));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar plano: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Distribución de Mesas', style: AppTextStyles.bold()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/utilities'),
        ),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveLayout,
            icon: const Icon(Icons.save),
            label: const Text('Guardar Plano'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _isLoading ? null : _addTable,
            icon: const Icon(Icons.add),
            label: const Text('Añadir Mesa'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3), // Tapiz visual del restaurante
              child: Stack(
                children: _tables.map((table) {
                  final pos = _dragOffsets[table.id] ?? const Offset(0, 0);

                  return Positioned(
                    left: pos.dx,
                    top: pos.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          // Snapping to grid 20x20
                          final dx = (pos.dx + details.delta.dx);
                          final dy = (pos.dy + details.delta.dy);
                          // Magnetic snapping for visual cleanliness
                          final snappedDx = (dx / 20).round() * 20.0;
                          final snappedDy = (dy / 20).round() * 20.0;

                          _dragOffsets[table.id] = Offset(
                              snappedDx.clamp(0.0, MediaQuery.of(context).size.width - 100),
                              snappedDy.clamp(0.0, MediaQuery.of(context).size.height - 100));
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: colorScheme.primary, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(4, 4),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                table.name,
                                style: AppTextStyles.bold(color: colorScheme.primary, fontSize: 16),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -10,
                            right: -10,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.error,
                                foregroundColor: colorScheme.onError,
                              ),
                              iconSize: 16,
                              icon: const Icon(Icons.close),
                              onPressed: () => _deleteTable(table.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
