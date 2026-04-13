import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/table.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';
import 'package:responsive_app/services/table_service.dart';
import 'package:responsive_app/services/restaurant_service.dart';

class FloorPlanPage extends StatefulWidget {
  const FloorPlanPage({super.key});

  @override
  State<FloorPlanPage> createState() => _FloorPlanPageState();
}

class _FloorPlanPageState extends State<FloorPlanPage> {
  final TableService _tableService = TableService();
  List<TableModel> _tables = [];
  bool _isLoading = true;
  String _mode = 'DINE_IN'; // DINE_IN, TAKEAWAY, DELIVERY

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  Future<void> _loadTables() async {
    try {
      final restaurantService = RestaurantService();
      final restaurants = await restaurantService.getRestaurants();
      String? restaurantId = restaurants.isNotEmpty ? restaurants.first.id : null;
      
      final tables = await _tableService.getTables(restaurantId: restaurantId);
      if (mounted) {
        setState(() {
          _tables = tables;
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

  void _openPosForTable(TableModel table) {
    context.push('/sales/pos', extra: {
      'orderType': 'DINE_IN',
      'table': table,
    });
  }

  void _openPosForNominal(String orderType) async {
    final nameController = TextEditingController();
    final dinerName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Datos del Cliente', style: AppTextStyles.bold()),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nombre del Cliente / Referencia'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('Aceptar'),
          )
        ],
      ),
    );

    if (dinerName != null && dinerName.isNotEmpty) {
      if (!mounted) return;
      context.push('/sales/pos', extra: {
        'orderType': orderType,
        'dinerName': dinerName,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Selección de Mesa / Orden', style: AppTextStyles.bold(color: Colors.black)),
        leading: PosUserMenu(),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'DINE_IN', label: Text('Comedor'), icon: Icon(Icons.restaurant)),
                ButtonSegment(value: 'TAKEAWAY', label: Text('Para Llevar'), icon: Icon(Icons.takeout_dining)),
                ButtonSegment(value: 'DELIVERY', label: Text('Delivery'), icon: Icon(Icons.delivery_dining)),
              ],
              selected: {_mode},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _mode = newSelection.first;
                });
                
                if (_mode != 'DINE_IN') {
                  _openPosForNominal(_mode);
                  // Resetea a Comedor para la vista subyacente
                  setState(() => _mode = 'DINE_IN'); 
                }
              },
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tables.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.table_restaurant, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('No hay mesas configuradas', style: AppTextStyles.bold(fontSize: 20)),
                      const SizedBox(height: 8),
                      Text(
                        'Si este es un modelo "Feria", utiliza los botones superiores para crear órdenes.',
                        style: AppTextStyles.text(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : Container(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  child: Stack(
                    children: _tables.map((table) {
                      return Positioned(
                        left: table.x,
                        top: table.y,
                        child: GestureDetector(
                          onTap: () => _openPosForTable(table),
                          child: Container(
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
                        ),
                      );
                    }).toList(),
                  ),
                ),
    );
  }
}
