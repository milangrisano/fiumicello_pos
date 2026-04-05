import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/role.dart';
import 'package:responsive_app/services/role_service.dart';
import 'package:responsive_app/services/user_service.dart';
import 'package:responsive_app/models/restaurant.dart';
import 'package:responsive_app/services/restaurant_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  String role;
  String? restaurantName;
  final DateTime createdAt;
  bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.restaurantName,
    required this.createdAt,
    required this.isActive,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? restaurantName,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      restaurantName: restaurantName ?? this.restaurantName,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _searchQuery = '';
  final bool _isViewingAsAdmin = true; // TODO: Mocked admin privilege
  List<UserModel> _allUsers = [];
  List<RoleDefinitionModel> _availableRoles = [];
  List<Restaurant> _availableRestaurants = [];
  bool _isLoading = true;
  bool _hasError = false;
  final UserService _userService = UserService();
  final RoleService _roleService = RoleService();
  final RestaurantService _restaurantService = RestaurantService();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _userService.getUsers();
      final roles = await _roleService.getRoles();
      final restaurants = await _restaurantService.getRestaurants();
      if (mounted) {
        setState(() {
          _allUsers = users;
          _availableRoles = roles.where((r) => r.name.toLowerCase() != 'super admin' && r.name.toLowerCase() != 'admin' && r.name.toLowerCase() != 'administrador').toList();
          _availableRestaurants = restaurants.where((r) => r.isActive).toList();
          _hasError = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _allUsers = [];
          _hasError = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos del servidor: $e')),
        );
      }
    }
  }

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
              child: Column(
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
                        Icon(Icons.people, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Usuarios Registrados',
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
                            '${filteredUsers.length} registros',
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
                  child: _isLoading 
                  ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
                  : _hasError
                    ? Center(
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
                                _fetchUsers();
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
                                    DataColumn(label: Text('Nombre', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Correo', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Teléfono', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Sucursal', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Rol', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Creación', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                    DataColumn(label: Text('Estado', style: AppTextStyles.bold(color: colorScheme.onSurface))),
                                  ],
                                  rows: filteredUsers.map((user) {
                                    return DataRow(
                                      key: ValueKey(user.id),
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
                                        DataCell(Text(user.email, style: AppTextStyles.text(color: colorScheme.onSurface))),
                                        DataCell(Text(user.phone.isNotEmpty ? user.phone : 'N/A', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant))),
                                        DataCell(Text(user.restaurantName ?? 'No asignada', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant))),
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
                                          Text('${user.createdAt.day.toString().padLeft(2,'0')}/${user.createdAt.month.toString().padLeft(2,'0')}/${user.createdAt.year}', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant)),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: user.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: user.isActive ? Colors.green : Colors.red,
                                                  ),
                                                ),
                                                child: Text(
                                                  user.isActive ? 'Activo' : 'Inactivo',
                                                  style: AppTextStyles.bold(
                                                    color: user.isActive ? Colors.green : Colors.red,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              if (user.role.toLowerCase() != 'super admin') ...[
                                                const SizedBox(width: 8),
                                                IconButton(
                                                  icon: Icon(
                                                    user.isActive ? Icons.toggle_on : Icons.toggle_off,
                                                    size: 24,
                                                  ),
                                                  color: user.isActive ? Colors.green : Colors.grey,
                                                  onPressed: () => _toggleUserStatus(user),
                                                  tooltip: user.isActive ? 'Desactivar' : 'Activar',
                                                ),
                                              ],
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

  Future<void> _toggleUserStatus(UserModel user) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final newStatus = !user.isActive;
      await _userService.updateUserStatus(user.id, newStatus);

      if (!mounted) return;
      setState(() {
        final index = _allUsers.indexWhere((u) => u.id == user.id);
        if (index != -1) {
          _allUsers[index] = _allUsers[index].copyWith(isActive: newStatus);
        }
      });
      
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Usuario ${user.name} ${newStatus ? 'activado' : 'desactivado'}',
            style: AppTextStyles.text(color: Colors.white),
          ),
          backgroundColor: newStatus ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Error al cambiar estado del usuario',
            style: AppTextStyles.text(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditRoleDialog(BuildContext context, UserModel user) {
    if (_availableRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay roles disponibles')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        String selectedRoleId = _availableRoles.firstWhere(
          (r) => r.name == user.role, 
          orElse: () => _availableRoles.first,
        ).id;
        
        String? selectedRestaurantId;

        bool isSaving = false;
        final colorScheme = Theme.of(context).colorScheme;

        return StatefulBuilder(
          builder: (context, setStateModal) {
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
                        value: selectedRoleId,
                        isExpanded: true,
                        dropdownColor: Theme.of(context).cardColor,
                        style: AppTextStyles.w500(color: colorScheme.onSurface),
                        items: _availableRoles.map((role) {
                          return DropdownMenuItem<String>(
                            value: role.id,
                            child: Text(role.name),
                          );
                        }).toList(),
                        onChanged: isSaving ? null : (value) {
                          if (value != null) {
                            setStateModal(() => selectedRoleId = value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Asignar a Sucursal:', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                       border: Border.all(color: colorScheme.outlineVariant),
                       borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRestaurantId,
                        isExpanded: true,
                        dropdownColor: Theme.of(context).cardColor,
                        style: AppTextStyles.w500(color: colorScheme.onSurface),
                        hint: Text('Selecciona una sucursal', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant)),
                        items: _availableRestaurants.map((res) {
                          return DropdownMenuItem<String>(
                            value: res.id,
                            child: Text(res.name),
                          );
                        }).toList(),
                        onChanged: isSaving ? null : (value) {
                          if (value != null) {
                            setStateModal(() => selectedRestaurantId = value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  onPressed: isSaving ? null : () async {
                    if (selectedRestaurantId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debe seleccionar una sucursal')));
                      return;
                    }
                    setStateModal(() => isSaving = true);
                    try {
                      await _userService.updateUserRole(user.id, selectedRoleId, restaurantId: selectedRestaurantId);
                      
                      if (!mounted || !context.mounted) return;
                      setState(() {
                        user.role = _availableRoles.firstWhere((r) => r.id == selectedRoleId).name;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rol actualizado correctamente')),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      setStateModal(() => isSaving = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al actualizar: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: isSaving 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text('Guardar Cambios', style: AppTextStyles.bold()),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
