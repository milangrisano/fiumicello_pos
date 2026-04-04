import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/payment_method.dart';
import 'package:responsive_app/services/payment_method_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final PaymentMethodService _service = PaymentMethodService();
  List<PaymentMethod> _methods = [];
  bool _isLoading = true;
  bool _hasError = false;

  bool get _hasPermissions {
    final roles = AuthProvider.instance.currentUser?.roles.map((r) => r.toLowerCase()).toList() ?? [];
    return roles.contains('super admin') || roles.contains('admin') || roles.contains('administrador');
  }

  @override
  void initState() {
    super.initState();
    _fetchMethods();
  }

  Future<void> _fetchMethods() async {
    try {
      final data = await _service.getPaymentMethods();
      if (mounted) {
        setState(() {
          _methods = data;
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
          SnackBar(content: Text('Error al cargar métodos de pago: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          'Métodos de Pago',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gestión de Métodos de Pago',
                  style: AppTextStyles.w500(color: colorScheme.onSurfaceVariant, fontSize: 16),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showMethodDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text('Crear Método', style: AppTextStyles.bold()),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.surface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? colorScheme.outlineVariant : Colors.black12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
                      : _hasError
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No se pudieron cargar los datos',
                                    style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _isLoading = true;
                                        _hasError = false;
                                      });
                                      _fetchMethods();
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Reintentar'),
                                  )
                                ],
                              ),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                  headingRowColor: WidgetStateProperty.resolveWith(
                                    (states) => isDark
                                        ? colorScheme.surfaceTint.withValues(alpha: 0.15)
                                        : const Color(0xFFF9F9F9),
                                  ),
                                  columns: [
                                    DataColumn(label: Text('ID', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Nombre', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Creación', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Estado', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Acciones', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                  ],
                                  rows: _methods.map((method) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(method.id.toString(), style: AppTextStyles.text(color: colorScheme.onSurfaceVariant))),
                                        DataCell(Text(method.name, style: AppTextStyles.w500(color: colorScheme.onSurface))),
                                        DataCell(Text('${method.createdAt.day}/${method.createdAt.month}/${method.createdAt.year}', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant))),
                                        DataCell(
                                          Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: method.isActive ? Colors.green : Colors.red,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(method.isActive ? 'Activo' : 'Inactivo', style: AppTextStyles.text(color: colorScheme.onSurface)),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, size: 20),
                                                color: colorScheme.primary,
                                                tooltip: 'Editar',
                                                onPressed: () => _showMethodDialog(context, method: method),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  method.isActive ? Icons.toggle_on : Icons.toggle_off,
                                                  size: 28,
                                                ),
                                                color: method.isActive ? Colors.green : Colors.grey,
                                                tooltip: method.isActive ? 'Desactivar' : 'Activar',
                                                onPressed: () => _toggleStatus(method),
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

  void _showMethodDialog(BuildContext context, {PaymentMethod? method}) {
    final isEditing = method != null;
    final nameController = TextEditingController(text: method?.name ?? '');
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        bool isSaving = false;
        
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text(
                isEditing ? 'Editar Método de Pago' : 'Nuevo Método de Pago',
                style: AppTextStyles.bold(color: colorScheme.onSurface),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: AppTextStyles.text(color: colorScheme.primary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.primary, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: AppTextStyles.bold(color: colorScheme.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: isSaving ? null : () async {
                    if (nameController.text.trim().isEmpty) return;

                    setStateModal(() => isSaving = true);
                    try {
                      if (isEditing) {
                        await _service.updatePaymentMethod(method.id, nameController.text.trim());
                      } else {
                        await _service.createPaymentMethod(nameController.text.trim());
                      }
                      Navigator.pop(context);
                      _fetchMethods();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isEditing ? 'Método de pago actualizado' : 'Método de pago creado')),
                      );
                    } catch (e) {
                      setStateModal(() => isSaving = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Guardar', style: AppTextStyles.bold()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _toggleStatus(PaymentMethod method) async {
    try {
      await _service.updatePaymentMethodStatus(method.id, !method.isActive);
      _fetchMethods();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado actualizado satisfactoriamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar estado: $e')),
      );
    }
  }
}
