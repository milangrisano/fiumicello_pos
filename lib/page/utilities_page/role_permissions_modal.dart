import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/role.dart';
import 'package:responsive_app/services/role_service.dart';

class RolePermissionsModal extends StatefulWidget {
  final RoleDefinitionModel role;
  final Function(List<String>) onSaved;

  const RolePermissionsModal({
    super.key,
    required this.role,
    required this.onSaved,
  });

  @override
  State<RolePermissionsModal> createState() => _RolePermissionsModalState();
}

class _RolePermissionsModalState extends State<RolePermissionsModal> {
  final RoleService _roleService = RoleService();
  bool _isSaving = false;
  late Set<String> _selectedPermissions;

  final Map<String, List<Map<String, String>>> _permissionModules = {
    'Módulo de Utilidad Global': [
      {'key': 'utilities:access', 'label': 'Acceso al Menú Utilidades'},
      {'key': 'utilities:roles', 'label': 'Gestionar Roles'},
      {'key': 'utilities:users', 'label': 'Gestionar Usuarios'},
      {'key': 'utilities:products', 'label': 'Gestionar Productos'},
      {'key': 'utilities:categories', 'label': 'Gestionar Categorías'},
      {'key': 'utilities:payment_methods', 'label': 'Cajas y Métodos de Pago'},
      {'key': 'utilities:restaurants', 'label': 'Configurar Restaurantes'},
      {'key': 'utilities:terminals', 'label': 'Gestionar Terminales'},
    ],
    'Gestión de Mesas': [
      {'key': 'tables:view', 'label': 'Visualizar Mesas'},
      {'key': 'tables:manage', 'label': 'Editar / Crear Mesas'},
    ],
    'Punto de Venta (Ventas)': [
      {'key': 'sales:manage', 'label': 'Habilitar Creación de Pedidos'},
      {'key': 'sales:manage_active_payments', 'label': 'Revisar y Cobrar Pedidos Activos'},
      {'key': 'sales:view_history', 'label': 'Ver Historial Global'},
    ],
    'Pantalla de Cocina': [
      {'key': 'kitchen:view', 'label': 'Visualización de Comandas (Solo lectura)'},
      {'key': 'kitchen:edit', 'label': 'Habilitar botones "Marcar Listo/En Proceso"'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedPermissions = Set<String>.from(widget.role.permissions);
  }

  void _togglePermission(String key) {
    if (widget.role.name == 'Super Admin') return; // Cannot edit super admin
    setState(() {
      if (_selectedPermissions.contains(key)) {
        _selectedPermissions.remove(key);
      } else {
        _selectedPermissions.add(key);
      }
    });
  }

  Future<void> _savePermissions() async {
    setState(() => _isSaving = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final permList = _selectedPermissions.toList();
      await _roleService.updateRolePermissions(widget.role.id, permList);
      widget.onSaved(permList);
      navigator.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error al guardar permisos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSuperAdmin = widget.role.name == 'Super Admin';

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Permisos: ${widget.role.name}', style: AppTextStyles.bold(color: colorScheme.onSurface)),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: 800,
        height: 600,
        child: Column(
          children: [
            if (isSuperAdmin)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El rol "Super Admin" tiene acceso global estático. Sus permisos no pueden ser removidos.',
                        style: AppTextStyles.text(color: colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _permissionModules.length,
                itemBuilder: (context, index) {
                  final moduleName = _permissionModules.keys.elementAt(index);
                  final permissions = _permissionModules[moduleName]!;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? colorScheme.outlineVariant : Colors.black12),
                    ),
                    color: isDark ? colorScheme.surfaceTint.withValues(alpha: 0.05) : Colors.grey[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            moduleName,
                            style: AppTextStyles.bold(color: colorScheme.primary, fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            children: permissions.map((perm) {
                              final key = perm['key']!;
                              final isSelected = _selectedPermissions.contains(key) || _selectedPermissions.contains('all');
                              return SizedBox(
                                width: 350,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(
                                    perm['label']!,
                                    style: AppTextStyles.w500(color: colorScheme.onSurface),
                                  ),
                                  value: isSelected,
                                  onChanged: isSuperAdmin ? null : (bool? value) => _togglePermission(key),
                                  activeColor: colorScheme.primary,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: AppTextStyles.bold(color: colorScheme.onSurfaceVariant)),
        ),
        if (!isSuperAdmin)
          ElevatedButton(
            onPressed: _isSaving ? null : _savePermissions,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('Guardar Accesos', style: AppTextStyles.bold()),
          ),
      ],
    );
  }
}
