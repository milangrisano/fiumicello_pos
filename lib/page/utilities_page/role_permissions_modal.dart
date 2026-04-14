import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/role.dart';
import 'package:responsive_app/services/role_service.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class RolePermissionsModal extends StatefulWidget {
  final RoleDefinitionModel role;
  final Function(List<String>, String?) onSaved;

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
  String? _selectedDefaultRoute;

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

  final List<Map<String, String>> _availableRoutes = [
    {'path': '/utilities', 'label': 'Configuración y Utilidades'},
    {'path': '/sales', 'label': 'Punto de Venta / Mesas'},
    {'path': '/kitchen', 'label': 'Pantalla de Cocina'},
    {'path': '/guest', 'label': 'Pantalla de Invitado'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedPermissions = Set<String>.from(widget.role.permissions);
    _selectedDefaultRoute = widget.role.defaultRoute;
  }

  bool _canEditRoles() {
    final currentUser = AuthProvider.instance.currentUser;
    if (currentUser == null) return false;
    return currentUser.roles.contains('Super Admin') || currentUser.roles.contains('Admin');
  }

  void _togglePermission(String key) {
    if (widget.role.name == 'Super Admin') return; // Cannot edit super admin
    if (!_canEditRoles()) return;
    
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
      await _roleService.updateRolePermissions(widget.role.id, permList, defaultRoute: _selectedDefaultRoute);
      widget.onSaved(permList, _selectedDefaultRoute);
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
    final isSuperAdminRole = widget.role.name == 'Super Admin';
    final canEdit = _canEditRoles() && !isSuperAdminRole;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSuperAdminRole)
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
              
            if (!_canEditRoles())
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.error),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lock, color: colorScheme.onErrorContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'No tienes permisos suficientes (Super Admin o Admin) para modificar roles.',
                        style: AppTextStyles.text(color: colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),

            // Dropdown para Pantalla de Inicio (Landing Page)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isDark ? colorScheme.outlineVariant : Colors.black12),
              ),
              color: isDark ? colorScheme.surfaceTint.withValues(alpha: 0.05) : Colors.blue.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.home, color: colorScheme.primary),
                    const SizedBox(width: 16),
                    Text('Pantalla de Inicio:', style: AppTextStyles.bold(color: colorScheme.onSurface)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedDefaultRoute,
                          hint: Text('Selecciona una ruta...', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant)),
                          items: _availableRoutes.map((route) {
                            return DropdownMenuItem<String>(
                              value: route['path'],
                              child: Text(route['label']!, style: AppTextStyles.text()),
                            );
                          }).toList(),
                          onChanged: canEdit ? (String? newValue) {
                            setState(() {
                              _selectedDefaultRoute = newValue;
                            });
                          } : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Divider(),
            const SizedBox(height: 8),
            
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
                                  onChanged: canEdit ? (bool? value) => _togglePermission(key) : null,
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
          child: Text(canEdit ? 'Cancelar' : 'Cerrar', style: AppTextStyles.bold(color: colorScheme.onSurfaceVariant)),
        ),
        if (canEdit)
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
