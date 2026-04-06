import 'package:flutter/material.dart';

import 'package:responsive_app/models/product.dart';
import 'package:responsive_app/services/product_service.dart';
import 'package:responsive_app/services/sales_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_sidebar.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_topbar.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_product_grid.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_bottom_bar.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_order_panel.dart';
import 'package:responsive_app/models/pos_order.dart';

class SalesPage extends StatefulWidget {
  final Map<String, dynamic>? orderParams;

  const SalesPage({super.key, this.orderParams});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  String _activeCategory = '';
  
  // Lista de órdenes abiertas
  final List<PosOrder> _openOrders = [];
  
  // Índice de la orden seleccionada (null = borrador)
  int? _selectedOrderIndex;
  
  // Borrador de la nueva orden
  List<PosCartItem> _draftItems = []; 
  String _draftName = 'Nueva Mesa';
  
  // Search state
  String _searchQuery = '';

  // State del backend
  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;
  final ProductService _productService = ProductService();
  final SalesService _salesService = SalesService();

  @override
  void initState() {
    super.initState();
    _initOrderContext();
    _loadProducts();
  }

  void _initOrderContext() {
    if (widget.orderParams != null) {
      final orderType = widget.orderParams!['orderType'] as String?;
      if (orderType == 'DINE_IN' && widget.orderParams!['table'] != null) {
        final table = widget.orderParams!['table'];
        _draftName = 'Mesa: ${table.name}';
      } else if (orderType != null) {
        final dinerName = widget.orderParams!['dinerName'] as String?;
        _draftName = '$orderType - ${dinerName ?? "Sin Nombre"}';
      }
    } else {
      _draftName = 'Venta Directa';
    }
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getProducts();
      final categories = _productService.extractCategories(products);
      if (mounted) {
        setState(() {
          _products = products;
          _categories = ['Todos', ...categories];
          if (_categories.isNotEmpty) {
            _activeCategory = _categories.first;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _submitCurrentOrder() async {
    if (_draftItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay items en la orden')));
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final String orderType = widget.orderParams?['orderType'] ?? 'DINE_IN';
      
      Map<String, dynamic> saleData = {
        'orderType': orderType,
        'dinerName': widget.orderParams?['dinerName'],
      };
      
      if (orderType == 'DINE_IN' && widget.orderParams?['table'] != null) {
        saleData['tableId'] = widget.orderParams!['table'].id;
      }
      
      // 1. Create Sale
      final createdSale = await _salesService.createSale(saleData);
      
      // 2. Add Items
      List<Map<String, dynamic>> itemsMap = _draftItems.map((e) => {
        'productId': e.product.id,
        'quantity': e.quantity,
      }).toList();
      
      await _salesService.addItems(createdSale.id, itemsMap);
      
      // 3. Update Status to COMMANDED
      await _salesService.updateStatus(createdSale.id, 'COMMANDED');
      
      if (mounted) {
         setState(() {
           // Clear draft
           _draftItems.clear();
           _initOrderContext();
         });
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Orden disparada a cocina correctamente')));
      }
    } catch(e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $_errorMessage')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          // Left Sidebar
          PosSidebar(
            categories: _isLoading ? [] : _categories,
            activeCategory: _activeCategory,
            onCategorySelected: (cat) {
              setState(() {
                _activeCategory = cat;
              });
            },
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Navbar
                PosTopbar(
                  isNewOrderSelected: _selectedOrderIndex == null,
                  onSelectNewOrder: () {
                    setState(() {
                      _selectedOrderIndex = null;
                    });
                  },
                  onSearchChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),

                // Active Category Grid
                Expanded(
                  child: _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                          ? Center(child: Text('Error: $_errorMessage'))
                          : PosProductGrid(
                              searchQuery: _searchQuery,
                              category: _activeCategory,
                              products: _products,
                              onAddProduct: (product) {
                                setState(() {
                                  final selectedSize = product.category == 'Pizzas' && product.type.isNotEmpty ? product.type : null;
                                  
                                  void addOrIncrement(List<PosCartItem> items) {
                                    final existingIndex = items.indexWhere((item) => 
                                      item.product.id == product.id && 
                                      item.selectedSize == selectedSize
                                    );
                                    
                                    if (existingIndex != -1) {
                                      items[existingIndex].quantity += 1;
                                    } else {
                                      items.add(PosCartItem(
                                        product: product,
                                        selectedSize: selectedSize,
                                        quantity: 1,
                                      ));
                                    }
                                  }

                                  if (_selectedOrderIndex == null) {
                                    addOrIncrement(_draftItems);
                                  } else {
                                    addOrIncrement(_openOrders[_selectedOrderIndex!].items);
                                  }
                                });
                              },
                            ),
                ),

                // Bottom Bar (Order Type)
                PosBottomBar(
                  openOrders: _openOrders,
                  selectedIndex: _selectedOrderIndex,
                  onSelected: (index) {
                    setState(() {
                      _selectedOrderIndex = index;
                    });
                  },
                ),
              ],
            ),
          ),

          // Right Order Panel (Cart)
          PosOrderPanel(
            orderItems: _selectedOrderIndex == null 
                ? _draftItems 
                : _openOrders[_selectedOrderIndex!].items,
            orderType: _selectedOrderIndex == null 
                ? _draftName 
                : _openOrders[_selectedOrderIndex!].name,
            onNameChanged: (newName) {
              setState(() {
                if (_selectedOrderIndex == null) {
                  _draftName = newName;
                } else {
                  _openOrders[_selectedOrderIndex!].name = newName;
                }
              });
            },
            onPlaceOrder: () {
              if (_selectedOrderIndex == null) {
                _submitCurrentOrder();
              }
            },
            onPayOrder: () {
              setState(() {
                if (_selectedOrderIndex != null) {
                  // Cobra y elimina la orden abierta
                  _openOrders.removeAt(_selectedOrderIndex!);
                  _selectedOrderIndex = null;
                } else {
                  // Cobra y resetea el draft
                  _draftItems = [];
                  _draftName = 'Nueva Mesa';
                }
              });
            },
          ),
        ],
    );
  }
}
