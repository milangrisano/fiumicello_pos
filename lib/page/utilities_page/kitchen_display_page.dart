import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:responsive_app/configure/api_config.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/sale.dart';
import 'package:responsive_app/services/sales_service.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class KitchenDisplayPage extends StatefulWidget {
  const KitchenDisplayPage({super.key});

  @override
  State<KitchenDisplayPage> createState() => _KitchenDisplayPageState();
}

class _KitchenDisplayPageState extends State<KitchenDisplayPage> {
  final SalesService _salesService = SalesService();
  List<SaleModel> _sales = [];
  bool _isLoading = true;
  IO.Socket? _socket;

  @override
  void initState() {
    super.initState();
    _fetchSales();
    _initSocket();
  }

  @override
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    super.dispose();
  }

  void _initSocket() {
    _socket = IO.io(ApiConfig.serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.connect();

    _socket?.onConnect((_) {
      print('Kitchen socket connected');
    });

    _socket?.on('saleCreated', (_) {
      _fetchSales(); // Refresh autonomously
    });

    _socket?.on('saleUpdated', (_) {
      _fetchSales();
    });

    _socket?.onDisconnect((_) {
      print('Kitchen socket disconnected');
    });
  }

  Future<void> _fetchSales() async {
    try {
      final sales = await _salesService.getSales();
      if (mounted) {
        setState(() {
          _sales = sales;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching sales for kitchen: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateStatus(String id, String newStatus) async {
    try {
      await _salesService.updateStatus(id, newStatus);
      // We don't fetch immediately here because the socket should notify us,
      // but to feel snappy, we can fetch optimistically.
      _fetchSales();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final commandedSales = _sales.where((s) => s.status == 'COMMANDED').toList();
    final inProgressSales = _sales.where((s) => s.status == 'IN_PROGRESS').toList();
    final readySales = _sales.where((s) => s.status == 'READY').toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Pantalla de Cocina', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/utilities'),
        ),
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),
          child: PosUserMenu(isRightSide: true),
        )],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildColumn('Pendientes (Commanded)', commandedSales, Colors.orange, 'IN_PROGRESS', isDark, colorScheme),
                const SizedBox(width: 16),
                _buildColumn('En Progreso', inProgressSales, Colors.blue, 'READY', isDark, colorScheme),
                const SizedBox(width: 16),
                _buildColumn('Listos para Entregar', readySales, Colors.green, null, isDark, colorScheme),
              ],
            ),
          ),
    );
  }

  Widget _buildColumn(String title, List<SaleModel> sales, Color headerColor, String? nextState, bool isDark, ColorScheme colorScheme) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surfaceVariant.withOpacity(0.3) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: headerColor.withOpacity(0.15),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Text(
                '$title (${sales.length})',
                style: AppTextStyles.bold(color: headerColor, fontSize: 18),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  return _buildTicketCard(sales[index], nextState, isDark, colorScheme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(SaleModel sale, String? nextState, bool isDark, ColorScheme colorScheme) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final canAction = authProvider.currentUser?.hasPermission('kitchen:edit') ?? false;
    
    // Calcula tiempo desde la orden
    final duration = DateTime.now().difference(sale.createdAt);
    final minutes = duration.inMinutes;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: isDark ? 0 : 2,
      color: isDark ? colorScheme.surface : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (sale.orderType == 'DELIVERY') ...[
                        Icon(Icons.two_wheeler, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                      ] else if (sale.orderType == 'TAKEAWAY') ...[
                        Icon(Icons.takeout_dining, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                      ] else ...[
                        Icon(Icons.table_restaurant, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          _getTicketTitle(sale),
                          style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: minutes > 15 ? Colors.red.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$minutes min',
                    style: AppTextStyles.bold(
                      color: minutes > 15 ? Colors.red.shade700 : colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            ...sale.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    '${item.quantity}x',
                    style: AppTextStyles.bold(color: colorScheme.primary, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.productName,
                      style: AppTextStyles.w500(color: colorScheme.onSurface, fontSize: 16),
                    ),
                  ),
                ],
              ),
            )),
            const Divider(),
            if (canAction && nextState != null) ...[
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _updateStatus(sale.id, nextState),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  nextState == 'IN_PROGRESS' ? 'Empezar Preparación' : 'Marcar como Listo',
                  style: AppTextStyles.bold(fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getTicketTitle(SaleModel sale) {
    final invoice = sale.invoiceNumber != null ? '#${sale.invoiceNumber}' : '';
    if (sale.orderType == 'DELIVERY') {
      return 'Delivery $invoice - ${sale.dinerName ?? "Sin Nombre"}';
    } else if (sale.orderType == 'TAKEAWAY') {
      return '${sale.dinerName ?? "Cliente"} $invoice - Para Llevar';
    } else {
      return sale.tableName ?? 'Mesa Desconocida';
    }
  }
}
