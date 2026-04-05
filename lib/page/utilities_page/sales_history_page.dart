import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/sale.dart';
import 'package:responsive_app/services/sales_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';
import 'package:intl/intl.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  String _searchQuery = '';
  List<SaleModel> _allSales = [];
  bool _isLoading = true;
  bool _hasError = false;
  final SalesService _salesService = SalesService();

  @override
  void initState() {
    super.initState();
    _fetchSales();
  }

  Future<void> _fetchSales() async {
    try {
      final sales = await _salesService.getSales();
      if (mounted) {
        setState(() {
          _allSales = sales;
          _hasError = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _allSales = [];
          _hasError = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar historial de ventas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredSales = _allSales.where((sale) {
      final query = _searchQuery.toLowerCase();
      final idMatch = sale.id.toLowerCase().contains(query);
      final customerMatch = (sale.customerName ?? '').toLowerCase().contains(query);
      final methodMatch = (sale.paymentMethod ?? '').toLowerCase().contains(query);
      
      return idMatch || customerMatch || methodMatch;
    }).toList();

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
          'Historial de Ventas',
          style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 32.0),
            child: PosUserMenu(isRightSide: true),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surfaceTint.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? colorScheme.outlineVariant : Colors.black12,
                  width: 1.5,
                ),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: AppTextStyles.text(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Buscar venta por ID, cliente o método de pago...',
                  hintStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            Expanded(
              child: _isLoading 
                ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
                : _hasError
                  ? _buildErrorWidget(colorScheme)
                  : Column(
                      children: [
                        Expanded(
                          child: _buildTableSection(
                            title: 'Registro General de Ventas',
                            sales: filteredSales,
                            colorScheme: colorScheme,
                            isDark: isDark,
                            icon: Icons.receipt_long,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 64, color: colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'No se pudo cargar la información de la base de datos.', 
            style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
              _fetchSales();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.refresh),
            label: Text('Reintentar', style: AppTextStyles.bold()),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSection({
    required String title,
    required List<SaleModel> sales,
    required ColorScheme colorScheme,
    required bool isDark,
    required IconData icon,
  }) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border.all(color: isDark ? colorScheme.outlineVariant : Colors.black12),
          ),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${sales.length} registros',
                  style: AppTextStyles.bold(color: colorScheme.onPrimary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surface : Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(
                left: BorderSide(color: isDark ? colorScheme.outlineVariant : Colors.black12),
                right: BorderSide(color: isDark ? colorScheme.outlineVariant : Colors.black12),
                bottom: BorderSide(color: isDark ? colorScheme.outlineVariant : Colors.black12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: sales.isEmpty 
                ? Center(
                    child: Text(
                      'No hay registros para mostrar',
                      style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                    ),
                  )
                : LayoutBuilder(
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
                                headingRowColor: WidgetStateProperty.resolveWith(
                                  (states) => isDark ? colorScheme.surfaceTint.withValues(alpha: 0.15) : const Color(0xFFF9F9F9),
                                ),
                                dataRowMinHeight: 65,
                                dataRowMaxHeight: 65,
                                horizontalMargin: 32,
                                columnSpacing: 40,
                                columns: [
                                  DataColumn(label: Text('ID Transacción', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                  DataColumn(label: Text('Fecha', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                  DataColumn(label: Text('Cliente', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                  DataColumn(label: Text('M. Pago', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                  DataColumn(label: Text('Estado', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                  DataColumn(
                                    label: Expanded(
                                      child: Text('Total', style: AppTextStyles.bold(color: colorScheme.onSurface), textAlign: TextAlign.right),
                                    ),
                                  ),
                                ],
                                rows: sales.map((sale) {
                                  return DataRow(
                                    key: ValueKey(sale.id),
                                    cells: [
                                      DataCell(
                                        Row(
                                          children: [
                                            Icon(Icons.tag, size: 16, color: colorScheme.primary),
                                            const SizedBox(width: 8),
                                            Text(
                                              sale.id.length > 8 ? sale.id.substring(0, 8) : sale.id, 
                                              style: AppTextStyles.w500(color: colorScheme.onSurface)
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(Text(dateFormatter.format(sale.createdAt), style: AppTextStyles.text(color: colorScheme.onSurfaceVariant))),
                                      DataCell(Text(sale.customerName ?? 'Mostrador', style: AppTextStyles.text(color: colorScheme.onSurface))),
                                      DataCell(
                                        Row(
                                          children: [
                                            Icon(
                                              _getPaymentIcon(sale.paymentMethod), 
                                              size: 16, 
                                              color: colorScheme.onSurfaceVariant
                                            ),
                                            const SizedBox(width: 8),
                                            Text(sale.paymentMethod ?? 'N/A', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant)),
                                          ],
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(sale.status, colorScheme).withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: _getStatusColor(sale.status, colorScheme),
                                            ),
                                          ),
                                          child: Text(
                                            sale.status.toUpperCase(), 
                                            style: AppTextStyles.bold(
                                              color: _getStatusColor(sale.status, colorScheme),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            currencyFormatter.format(sale.total), 
                                            style: AppTextStyles.bold(color: colorScheme.primary, fontSize: 16),
                                            textAlign: TextAlign.right,
                                          ),
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
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'completado':
      case 'pagado':
        return Colors.green;
      case 'pending':
      case 'pendiente':
        return Colors.orange;
      case 'cancelled':
      case 'cancelado':
        return Colors.red;
      default:
        return colorScheme.outlineVariant;
    }
  }

  IconData _getPaymentIcon(String? method) {
    if (method == null) return Icons.money;
    final m = method.toLowerCase();
    if (m.contains('tarjeta') || m.contains('card')) return Icons.credit_card;
    if (m.contains('transferencia') || m.contains('transfer')) return Icons.account_balance;
    return Icons.payments;
  }
}
