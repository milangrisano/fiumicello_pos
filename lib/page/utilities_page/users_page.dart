import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final DateTime createdAt;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.isActive,
  });
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _searchQuery = '';
  final bool _isViewingAsAdmin = true; // TODO: Mocked admin privilege
  
  final List<UserModel> _allUsers = [
    UserModel(id: '1', name: 'Juan Perez', email: 'juan@fiumicello.com', phone: '+1234567890', role: 'Administrador', createdAt: DateTime.now().subtract(const Duration(days: 300)), isActive: true),
    UserModel(id: '2', name: 'Maria Gonzalez', email: 'maria@fiumicello.com', phone: '+1234567891', role: 'Manager', createdAt: DateTime.now().subtract(const Duration(days: 150)), isActive: true),
    UserModel(id: '3', name: 'Carlos Gomez', email: 'carlos@fiumicello.com', phone: '+1234567892', role: 'Mesero', createdAt: DateTime.now().subtract(const Duration(days: 20)), isActive: true),
    UserModel(id: '4', name: 'Ana Martinez', email: 'ana@fiumicello.com', phone: '+1234567893', role: 'Cajero', createdAt: DateTime.now().subtract(const Duration(days: 10)), isActive: false),
    UserModel(id: '5', name: 'Luis Rodriguez', email: 'luis@fiumicello.com', phone: '+1234567894', role: 'Cocinero', createdAt: DateTime.now().subtract(const Duration(days: 5)), isActive: true),
    UserModel(id: '6', name: 'Roberto Bolaño', email: 'roberto@fiumicello.com', phone: '+1234567895', role: 'Guest', createdAt: DateTime.now().subtract(const Duration(days: 1)), isActive: true),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredUsers = _allUsers.where((user) {
      final query = _searchQuery.toLowerCase();
      return user.name.toLowerCase().contains(query) ||
             user.email.toLowerCase().contains(query) ||
             user.role.toLowerCase().contains(query);
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
          'Directorio de Usuarios',
          style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24),
        ),
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
                  hintText: 'Buscar empleado por nombre, correo o rol...',
                  hintStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.resolveWith(
                          (states) => isDark ? colorScheme.surfaceTint.withValues(alpha: 0.15) : const Color(0xFFF9F9F9),
                        ),
                        dataRowMinHeight: 65,
                        dataRowMaxHeight: 65,
                        horizontalMargin: 32,
                        columnSpacing: 40,
                        columns: [
                          DataColumn(label: Text('Nombre', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                          DataColumn(label: Text('Correo / Teléfono', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                          DataColumn(label: Text('Rol', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                          DataColumn(label: Text('Creación', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                          DataColumn(label: Text('Estado', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                        ],
                        rows: filteredUsers.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                                      child: Text(
                                        user.name.substring(0, 1).toUpperCase(),
                                        style: AppTextStyles.bold(color: colorScheme.primary),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(user.name, style: AppTextStyles.w500(color: colorScheme.onSurface)),
                                  ],
                                ),
                              ),
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(user.email, style: AppTextStyles.text(color: colorScheme.onSurface)),
                                    Text(user.phone, style: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getRoleColor(user.role.toLowerCase(), colorScheme).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getRoleColor(user.role.toLowerCase(), colorScheme),
                                        ),
                                      ),
                                      child: Text(
                                        user.role, 
                                        style: AppTextStyles.bold(
                                          color: _getRoleColor(user.role.toLowerCase(), colorScheme),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    if (_isViewingAsAdmin && user.role.toLowerCase() != 'super admin') ...[
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 16),
                                        color: colorScheme.primary,
                                        onPressed: () => _showEditRoleDialog(context, user),
                                        tooltip: 'Editar Rol',
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              DataCell(
                                Text('${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant)),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: user.isActive ? Colors.green : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(user.isActive ? 'Activo' : 'Inactivo', style: AppTextStyles.text(color: colorScheme.onSurface)),
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
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role, ColorScheme colorScheme) {
    switch (role) {
      case 'administrador':
      case 'super admin':
        return colorScheme.tertiaryContainer;
      case 'manager':
        return Colors.orange;
      case 'guest':
        return colorScheme.outlineVariant;
      default:
        return colorScheme.primary;
    }
  }

  void _showEditRoleDialog(BuildContext context, UserModel user) {
    // Roles available to assign (excluding Admin and Super Admin)
    final List<String> availableRoles = ['Guest', 'Mesero', 'Cajero', 'Cocinero', 'Manager'];
    
    showDialog(
      context: context,
      builder: (context) {
        String selectedRole = availableRoles.contains(user.role) ? user.role : availableRoles.first;
        final colorScheme = Theme.of(context).colorScheme;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Cambiar rol de empleado', style: AppTextStyles.bold(color: colorScheme.onSurface)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selecciona el nuevo rol para ${user.name}:', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRole,
                        isExpanded: true,
                        dropdownColor: Theme.of(context).cardColor,
                        style: AppTextStyles.w500(color: colorScheme.onSurface),
                        items: availableRoles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedRole = value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '* Los roles de "Administrador" solo pueden ser delegados por el Super Administrador.',
                    style: AppTextStyles.text(color: Colors.redAccent, fontSize: 11),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: AppTextStyles.bold(color: colorScheme.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Role changes API here
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: Text('Guardar Cambios', style: AppTextStyles.bold()),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
