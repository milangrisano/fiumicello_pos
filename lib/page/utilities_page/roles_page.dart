import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/role.dart';
import 'package:responsive_app/services/role_service.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  List<RoleDefinitionModel> _allRoles = [];
  bool _isLoading = true;
  final RoleService _roleService = RoleService();

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    try {
      final roles = await _roleService.getRoles();
      if (mounted) {
        setState(() {
          _allRoles = roles;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Si el backend falla, usamos fallback de datos dummy para visualización
      if (mounted) {
        setState(() {
          _allRoles = [
            RoleDefinitionModel(id: '1', name: 'Guest', description: 'Acceso básico al menú y catálogo. Sin privilegios transaccionales.', isActive: true),
            RoleDefinitionModel(id: '2', name: 'Mesero', description: 'Puede crear órdenes, enviarlas a cocina y cobrar en efectivo.', isActive: true),
            RoleDefinitionModel(id: '3', name: 'Cocinero', description: 'Visibilidad de órdenes entrantes, marcado de finalización de platos.', isActive: true),
            RoleDefinitionModel(id: '4', name: 'Cajero', description: 'Gestión exclusiva de la caja registradora, devoluciones y cortes Z.', isActive: true),
            RoleDefinitionModel(id: '5', name: 'Manager', description: 'Supervisor de tienda. Puede promocionar empleados e inventario.', isActive: true),
            RoleDefinitionModel(id: '6', name: 'Administrador', description: 'Acceso total y configuración de tienda (bloqueado para edición).', isActive: true),
          ];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con la API. Mostrando datos locales. $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          'Configuración de Roles',
          style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: ElevatedButton.icon(
              onPressed: () => _showCreateRoleDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add),
              label: Text('Nuevo Rol', style: AppTextStyles.bold()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activa o desactiva los roles en la base de datos para impedir que los managers puedan delegarlos.',
              style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.surface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? colorScheme.outlineVariant : Colors.black12),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _isLoading 
                  ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
                  : SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.resolveWith(
                        (states) => isDark ? colorScheme.surfaceTint.withValues(alpha: 0.15) : const Color(0xFFF9F9F9),
                      ),
                      dataRowMinHeight: 70,
                      dataRowMaxHeight: 70,
                      horizontalMargin: 32,
                      columnSpacing: 48,
                      columns: [
                        DataColumn(label: Text('Nombre del Rol', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                        DataColumn(label: Text('Descripción', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                        DataColumn(label: Text('Estado de Activación', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                      ],
                      rows: _allRoles.map((role) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Icon(Icons.shield, color: colorScheme.primary, size: 20),
                                  const SizedBox(width: 12),
                                  Text(role.name, style: AppTextStyles.bold(color: colorScheme.onSurface)),
                                ],
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 400,
                                child: Text(
                                  role.description, 
                                  style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  role.name.toLowerCase() == 'administrador'
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 14.0),
                                        child: Icon(Icons.lock, color: colorScheme.outlineVariant, size: 20),
                                      )
                                    : Switch(
                                        value: role.isActive,
                                        activeTrackColor: colorScheme.primary.withValues(alpha: 0.5),
                                        activeThumbColor: colorScheme.primary,
                                        onChanged: (bool value) async {
                                          final originalValue = role.isActive;
                                          setState(() => role.isActive = value);
                                          
                                          final scaffoldMessenger = ScaffoldMessenger.of(context);
                                          try {
                                            await _roleService.updateRoleStatus(role.id, value);
                                          } catch (e) {
                                            if (mounted) {
                                              setState(() => role.isActive = originalValue);
                                              scaffoldMessenger.showSnackBar(
                                                SnackBar(content: Text('Error al cambiar estado: $e')),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                  const SizedBox(width: 8),
                                  Text(
                                    role.isActive ? 'Activo' : 'Inactivo',
                                    style: AppTextStyles.w500(
                                      color: role.isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateRoleDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final nameController = TextEditingController();
    final descController = TextEditingController();
    bool isCreating = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text('Crear Nuevo Rol', style: AppTextStyles.bold(color: colorScheme.onSurface)),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: AppTextStyles.text(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        labelText: 'Nombre del Rol',
                        labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: isDark ? colorScheme.outlineVariant : Colors.black12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      style: AppTextStyles.text(color: colorScheme.onSurface),
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Descripción general',
                        labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: isDark ? colorScheme.outlineVariant : Colors.black12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                if (!isCreating)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar', style: AppTextStyles.bold(color: colorScheme.onSurfaceVariant)),
                  ),
                ElevatedButton(
                  onPressed: isCreating ? null : () async {
                    if (nameController.text.trim().isNotEmpty && descController.text.trim().isNotEmpty) {
                      setStateModal(() => isCreating = true);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      
                      try {
                        final newRole = await _roleService.createRole(
                          nameController.text.trim(),
                          descController.text.trim()
                        );
                        
                        if (mounted) {
                          setState(() {
                            _allRoles.insert(0, newRole);
                          });
                        }
                        navigator.pop();
                      } catch (e) {
                         setStateModal(() => isCreating = false);
                         scaffoldMessenger.showSnackBar(
                           SnackBar(content: Text('Error al crear rol: $e')),
                         );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: isCreating 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('Guardar', style: AppTextStyles.bold()),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
