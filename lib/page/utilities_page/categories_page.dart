import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/category.dart';
import 'package:responsive_app/services/category_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CategoryService _service = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = true;
  bool _hasError = false;

  bool get _hasPermissions {
    final roles = AuthProvider.instance.currentUser?.roles.map((r) => r.toLowerCase()).toList() ?? [];
    return roles.contains('super admin') || roles.contains('admin') || roles.contains('administrador');
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final data = await _service.getCategories();
      data.sort((a, b) => a.id.compareTo(b.id));
      if (mounted) {
        setState(() {
          _categories = data;
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
          SnackBar(content: Text('Error al cargar categorías: $e')),
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
          'Categorías',
          style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 24),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: PosUserMenu(isRightSide: true),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar la información',
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _hasError = false;
                          });
                          _fetchCategories();
                        },
                        child: Text('Reintentar', style: AppTextStyles.bold(color: colorScheme.onPrimary)),
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Activa o desactiva y edita las categorías para poder asignarlas a los productos.',
                            style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showCategoryDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Categoría'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? colorScheme.surface : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LayoutBuilder(
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
                                          headingRowColor: WidgetStateProperty.all(Color(0xFF869B7E)),
                                          dataRowColor: WidgetStateProperty.all(Colors.transparent),
                                          columns: [
                                            DataColumn(label: Row(
                                              children: [
                                                Icon(Icons.category, color: colorScheme.primary, size: 20),
                                                const SizedBox(width: 8),
                                                Text('Nombre', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14)),
                                              ],
                                            )),
                                            DataColumn(label: Text('Descripción', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                            DataColumn(label: Text('Estado', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                            DataColumn(label: Text('Acciones', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                          ],
                                          rows: _categories.map((category) {
                                            return DataRow(
                                              key: ValueKey(category.id),
                                              cells: [
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(width: 28),
                                                    Text(category.name, style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14)),
                                                  ],
                                                )),
                                                DataCell(Text(category.description ?? '', style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14))),
                                                DataCell(
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: category.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: category.isActive ? Colors.green : Colors.red,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      category.isActive ? 'Activo' : 'Inactivo',
                                                      style: AppTextStyles.bold(
                                                        color: category.isActive ? Colors.green : Colors.red,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                DataCell(
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons.edit, size: 20),
                                                        color: colorScheme.primary,
                                                        onPressed: () => _showCategoryDialog(category: category),
                                                        tooltip: 'Editar',
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          category.isActive ? Icons.toggle_on : Icons.toggle_off,
                                                          size: 24,
                                                        ),
                                                        color: category.isActive ? Colors.green : Colors.grey,
                                                        onPressed: () => _toggleStatus(category),
                                                        tooltip: category.isActive ? 'Desactivar' : 'Activar',
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

  void _showCategoryDialog({Category? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final descriptionController = TextEditingController(text: category?.description ?? '');
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (innerContext, setDialogState) {
            final colorScheme = Theme.of(innerContext).colorScheme;
            
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text(
                category == null ? 'Nueva Categoría' : 'Editar Categoría',
                style: AppTextStyles.bold(color: colorScheme.primary, fontSize: 20),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.primary)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Descripción',
                          labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.primary)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: Text('Cancelar', style: AppTextStyles.bold(color: colorScheme.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final name = nameController.text.trim();
                          final description = descriptionController.text.trim();

                          if (name.isEmpty) {
                            ScaffoldMessenger.of(innerContext).showSnackBar(
                              const SnackBar(content: Text('El nombre es obligatorio')),
                            );
                            return;
                          }

                          setDialogState(() => isSaving = true);
                          try {
                            if (category == null) {
                              await _service.createCategory(name, description);
                            } else {
                              await _service.updateCategory(category.id, name, description);
                            }
                            
                            if (!innerContext.mounted) return;
                            Navigator.pop(innerContext);
                            
                            if (!mounted) return;
                            _fetchCategories();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(category == null ? 'Categoría creada' : 'Categoría actualizada')),
                            );
                          } catch (e) {
                            setDialogState(() => isSaving = false);
                            if (innerContext.mounted) {
                              ScaffoldMessenger.of(innerContext).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text('Guardar', style: AppTextStyles.bold(color: colorScheme.onPrimary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _toggleStatus(Category category) async {
    final index = _categories.indexOf(category);
    if (index == -1) return;

    final newStatus = !category.isActive;
    
    setState(() {
      _categories[index] = Category(
        id: category.id,
        name: category.name,
        description: category.description,
        isActive: newStatus,
        createdAt: category.createdAt,
        updatedAt: DateTime.now(),
      );
    });

    try {
      await _service.updateCategoryStatus(category.id, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Categoría ${newStatus ? 'activada' : 'desactivada'}')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _categories[index] = category;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cambiar estado: $e')),
        );
      }
    }
  }
}
