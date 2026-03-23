import 'package:flutter/material.dart';

import 'package:responsive_app/models/product.dart';
import 'package:responsive_app/services/product_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_sidebar.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_topbar.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_product_grid.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_bottom_bar.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_order_panel.dart';
import 'package:responsive_app/models/pos_order.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

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

  @override
  void initState() {
    super.initState();
    _loadProducts();
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
                                  final newItem = PosCartItem(
                                    product: product, 
                                    selectedSize: product.category == 'Pizzas' && product.type.isNotEmpty ? product.type : null,
                                    quantity: 1,
                                  );
                                  if (_selectedOrderIndex == null) {
                                      _draftItems.add(newItem);
                                  } else {
                                      _openOrders[_selectedOrderIndex!].items.add(newItem);
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
              setState(() {
                if (_selectedOrderIndex == null) {
                  // Mover draft a open orders
                  _openOrders.add(PosOrder(
                    id: '#${451 + _openOrders.length}',
                    name: _draftName,
                    items: List.from(_draftItems),
                  ));
                  _draftItems = [];
                  _draftName = 'Nueva Mesa';
                }
              });
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
