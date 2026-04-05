import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:responsive_app/models/terminal.dart';
import 'package:responsive_app/services/terminal_service.dart';
import 'package:responsive_app/page/sales_pages/widget_pos/pos_user_menu.dart';
import 'package:responsive_app/provider/auth_provider.dart';

class TerminalsPage extends StatefulWidget {
  const TerminalsPage({super.key});

  @override
  State<TerminalsPage> createState() => _TerminalsPageState();
}

class _TerminalsPageState extends State<TerminalsPage> {
  final TerminalService _service = TerminalService();
  List<Terminal> _terminals = [];
  bool _isLoading = true;
  bool _hasError = false;

  bool get _hasPermissions {
    final roles = AuthProvider.instance.currentUser?.roles.map((r) => r.toLowerCase()).toList() ?? [];
    return roles.contains('super admin') || roles.contains('admin') || roles.contains('administrador');
  }

  @override
  void initState() {
    super.initState();
    _fetchTerminals();
  }

  Future<void> _fetchTerminals() async {
    try {
      final data = await _service.getTerminals();
      data.sort((a, b) => a.id.compareTo(b.id));
      if (mounted) {
        setState(() {
          _terminals = data;
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
          SnackBar(content: Text('Error al cargar terminales: $e')),
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
          'Terminales',
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
                          _fetchTerminals();
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
                            'Activa o desactiva las terminales para asignarles permisos para realizar tareas en el sistema.',
                            style: AppTextStyles.text(color: colorScheme.onSurfaceVariant),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showTerminalDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text('Terminal'),
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
                                          headingRowColor: WidgetStatePropertyAll(Color(0xFF869B7E)),
                                          dataRowColor: const WidgetStatePropertyAll(Colors.transparent),
                                          columns: [
                                            DataColumn(label: Row(
                                              children: [
                                                Icon(Icons.point_of_sale, color: colorScheme.primary, size: 20),
                                                const SizedBox(width: 8),
                                                Text('ID', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14)),
                                              ],
                                            )),
                                            DataColumn(label: Text('Nombre', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                            DataColumn(label: Text('Estado', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                            DataColumn(label: Text('Acciones', style: AppTextStyles.bold(color: colorScheme.onSurface, fontSize: 14))),
                                          ],
                                          rows: _terminals.map((terminal) {
                                            return DataRow(
                                              key: ValueKey(terminal.id),
                                              cells: [
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(width: 28),
                                                    Text(terminal.id.toString(), style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14)),
                                                  ],
                                                )),
                                                DataCell(Text(terminal.name, style: AppTextStyles.text(color: colorScheme.onSurface, fontSize: 14))),
                                                DataCell(
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: terminal.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: terminal.isActive ? Colors.green : Colors.red,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      terminal.isActive ? 'Activo' : 'Inactivo',
                                                      style: AppTextStyles.bold(
                                                        color: terminal.isActive ? Colors.green : Colors.red,
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
                                                        onPressed: () => _showTerminalDialog(terminal: terminal),
                                                        tooltip: 'Editar',
                                                      ),
                                                      IconButton(
                                                        icon: Icon(
                                                          terminal.isActive ? Icons.toggle_on : Icons.toggle_off,
                                                          size: 24,
                                                        ),
                                                        color: terminal.isActive ? Colors.green : Colors.grey,
                                                        onPressed: () => _toggleStatus(terminal),
                                                        tooltip: terminal.isActive ? 'Desactivar' : 'Activar',
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

  void _showTerminalDialog({Terminal? terminal}) {
    final nameController = TextEditingController(text: terminal?.name ?? '');
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
                terminal == null ? 'Nuevo Terminal' : 'Editar Terminal',
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

                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('El nombre es obligatorio')),
                            );
                            return;
                          }

                          setDialogState(() => isSaving = true);
                          try {
                            if (terminal == null) {
                              await _service.createTerminal(name);
                            } else {
                              await _service.updateTerminal(terminal.id, name);
                            }
                            
                            if (!mounted || !context.mounted) return;
                            
                            Navigator.pop(context);
                            _fetchTerminals();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(terminal == null ? 'Terminal creado' : 'Terminal actualizado')),
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

  Future<void> _toggleStatus(Terminal terminal) async {
    final index = _terminals.indexOf(terminal);
    if (index == -1) return;

    final newStatus = !terminal.isActive;
    
    setState(() {
      _terminals[index] = Terminal(
        id: terminal.id,
        name: terminal.name,
        isActive: newStatus,
        createdAt: terminal.createdAt,
        updatedAt: DateTime.now(),
      );
    });

    try {
      await _service.updateTerminalStatus(terminal.id, newStatus);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terminal ${newStatus ? 'activado' : 'desactivado'}')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _terminals[index] = terminal;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar estado: $e')),
      );
    }
  }
}
