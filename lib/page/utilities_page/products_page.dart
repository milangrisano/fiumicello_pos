import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/product.dart';
import 'package:responsive_app/models/category.dart';
import 'package:responsive_app/services/product_service.dart';
import 'package:responsive_app/services/category_service.dart';
import 'package:responsive_app/models/restaurant.dart';
import 'package:responsive_app/services/restaurant_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductService _service = ProductService();
  final CategoryService _categoryService = CategoryService();
  final RestaurantService _restaurantService = RestaurantService();
  List<Product> _products = [];
  List<Category> _categories = [];
  List<Restaurant> _restaurants = [];
  bool _isLoading = true;
  bool _hasError = false;

  bool get _hasPermissions {
    final roles = AuthProvider.instance.currentUser?.roles.map((r) => r.toLowerCase()).toList() ?? [];
    return roles.contains('super admin') || roles.contains('admin') || roles.contains('administrador');
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final categoriesData = await _categoryService.getCategories();
      final restaurantsData = await _restaurantService.getRestaurants();
      final data = await _service.getProducts();
      data.sort((a, b) => a.id.compareTo(b.id));
      
      if (mounted) {
        setState(() {
          _categories = categoriesData.where((cat) => cat.isActive).toList();
          _restaurants = restaurantsData.where((r) => r.isActive).toList();
          _products = data;
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
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          'Productos',
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
                          _fetchProducts();
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
                            'Gestión de Productos',
                            style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 20),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showProductDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Nuevo Producto'),
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
                        child: Builder(
                          builder: (context) {
                            // Agrupar usando la lista de restaurantes disponibles
                            final Map<String, List<Product>> groupedProducts = {};
                            for (var r in _restaurants) {
                              groupedProducts[r.name] = [];
                            }
                            
                            // Lista para los que no tienen restaurante asignado
                            const String noRestaurantKey = 'Sin Restaurante Asignado';
                            groupedProducts[noRestaurantKey] = [];

                            for (var product in _products) {
                              final key = product.restaurantName.isNotEmpty ? product.restaurantName : noRestaurantKey;
                              if (!groupedProducts.containsKey(key)) {
                                groupedProducts[key] = [];
                              }
                              groupedProducts[key]!.add(product);
                            }

                            // Filtrar los que no tienen productos si es 'Sin Restaurante Asignado'
                            final keys = groupedProducts.keys.where((k) {
                              if (k == noRestaurantKey) {
                                return groupedProducts[k]!.isNotEmpty;
                              }
                              return true; // Mostrar restaurantes incluso si están vacíos
                            }).toList();

                            return ListView.separated(
                              itemCount: keys.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 32),
                              itemBuilder: (context, index) {
                                final restaurantName = keys[index];
                                final productsList = groupedProducts[restaurantName]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Título del Restaurante
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(134, 155, 126, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        border: Border.all(color: Color.fromRGBO(134, 155, 126, 1),),
                                      ),
                                      // Nombre del restaurante y cantidad de productos
                                      child: Row(
                                        children: [
                                          Icon(Icons.storefront, color: colorScheme.primary),
                                          const SizedBox(width: 12),
                                          Text(
                                            restaurantName,
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
                                              '${productsList.length} productos',
                                              style: AppTextStyles.bold(color: colorScheme.onPrimary, fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Tabla de productos
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                        border: Border(
                                          left: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                                          right: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                                          bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                                        ),
                                      ),
                                      child: productsList.isEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.all(24.0),
                                              child: Center(
                                                child: Text(
                                                  'No hay productos registrados en este restaurante.',
                                                  style: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14),
                                                ),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                bottomRight: Radius.circular(12),
                                              ),
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
                                                            headingRowColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)),
                                                            dataRowColor: WidgetStateProperty.all(Colors.transparent),
                                                            columns: [
                                                              DataColumn(label: Text('Nombre', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                                              DataColumn(label: Text('Categoría', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                                              DataColumn(label: Text('Descripción', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                                              DataColumn(label: Text('Precio', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                                              DataColumn(label: Text('Acciones', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                                            ],
                                                            rows: productsList.map((product) {
                                                              return DataRow(
                                                                key: ValueKey(product.id),
                                                                cells: [
                                                                  DataCell(Text(product.name, style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14))),
                                                                  DataCell(Text(product.category.isNotEmpty ? product.category : 'N/A', style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14))),
                                                                  DataCell(
                                                                    SizedBox(
                                                                      width: 200,
                                                                      child: Text(
                                                                        product.description,
                                                                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14),
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  DataCell(Text(NumberFormat('#,##0.00').format(product.price), style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14))),
                                                                  DataCell(
                                                                    Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        IconButton(
                                                                          icon: const Icon(Icons.edit, size: 20),
                                                                          color: colorScheme.primary,
                                                                          onPressed: () => _showProductDialog(product: product),
                                                                          tooltip: 'Editar',
                                                                        ),
                                                                        IconButton(
                                                                          icon: Icon(
                                                                            product.isActive ? Icons.toggle_on : Icons.toggle_off,
                                                                            size: 24,
                                                                          ),
                                                                          color: product.isActive ? Colors.green : Colors.grey,
                                                                          onPressed: () => _toggleStatus(product),
                                                                          tooltip: product.isActive ? 'Desactivar' : 'Activar',
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
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _showProductDialog({Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final typeController = TextEditingController(text: product?.type ?? 'standard');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    String? selectedCategoryId = product?.categoryId;
    if (selectedCategoryId != null && selectedCategoryId.isEmpty) selectedCategoryId = null;

    String? selectedRestaurantId = product?.restaurantId;
    if (selectedRestaurantId != null && selectedRestaurantId.isEmpty) selectedRestaurantId = null;

    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final colorScheme = Theme.of(context).colorScheme;
            
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              title: Text(
                product == null ? 'Nuevo Producto' : 'Editar Producto',
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
                      DropdownButtonFormField<String>(
                        initialValue: selectedCategoryId,
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                        dropdownColor: colorScheme.surface,
                        decoration: InputDecoration(
                          labelText: 'Categoría',
                          labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.primary)),
                        ),
                        items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                        onChanged: _categories.isEmpty ? null : (val) {
                          setDialogState(() {
                            selectedCategoryId = val;
                          });
                        },
                        hint: Text(_categories.isEmpty ? 'No hay categorías. Crea una en Útiles.' : 'Selecciona una categoría', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14)),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRestaurantId,
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                        dropdownColor: colorScheme.surface,
                        decoration: InputDecoration(
                          labelText: 'Restaurante',
                          labelStyle: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outline)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.primary)),
                        ),
                        items: _restaurants.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList(),
                        onChanged: _restaurants.isEmpty ? null : (val) {
                          setDialogState(() {
                            selectedRestaurantId = val;
                          });
                        },
                        hint: Text(_restaurants.isEmpty ? 'No hay restaurantes.' : 'Selecciona un restaurante', style: AppTextStyles.text(color: colorScheme.onSurfaceVariant, fontSize: 14)),
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
                      const SizedBox(height: 16),
                      TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Precio',
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
                          final type = typeController.text.trim();
                          final categoryId = selectedCategoryId ?? '';
                          final restaurantId = selectedRestaurantId ?? '';
                          final price = double.tryParse(priceController.text.trim()) ?? 0.0;

                          if (name.isEmpty || categoryId.isEmpty || restaurantId.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('El nombre, la categoría y el restaurante son obligatorios')),
                            );
                            return;
                          }

                          setDialogState(() => isSaving = true);
                          try {
                            if (product == null) {
                              await _service.createProduct(name, type, categoryId, price, description, restaurantId);
                            } else {
                              await _service.updateProduct(product.id, name, type, categoryId, price, description, restaurantId);
                            }
                            
                            if (!mounted || !context.mounted) return;
                            
                            Navigator.pop(context);
                            _fetchProducts();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(product == null ? 'Producto creado' : 'Producto actualizado')),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            setDialogState(() => isSaving = false);
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

  Future<void> _toggleStatus(Product product) async {
    final index = _products.indexOf(product);
    if (index == -1) return;

    final newStatus = !product.isActive;
    
    setState(() {
      _products[index] = Product(
        id: product.id,
        name: product.name,
        type: product.type,
        categoryId: product.categoryId,
        category: product.category,
        restaurantId: product.restaurantId,
        restaurantName: product.restaurantName,
        description: product.description,
        price: product.price,
        availability: product.availability,
        isActive: newStatus,
        createdAt: product.createdAt,
        updatedAt: DateTime.now(),
      );
    });

    try {
      await _service.updateProductStatus(product.id, newStatus);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto ${newStatus ? 'activado' : 'desactivado'}')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _products[index] = product;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar estado: $e')),
      );
    }
  }
}
