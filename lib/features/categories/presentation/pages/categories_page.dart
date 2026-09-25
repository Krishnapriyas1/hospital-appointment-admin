import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../data/category_repository.dart';
import '../../models/category_model.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final CategoryRepository _repository;

  List<CategoryModel> _categories = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _repository = CategoryRepository(
      apiClient: ApiClient(),
    );

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categories = await _repository.getCategories();

      if (!mounted) return;

      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
            error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _showCategoryDialog({
    CategoryModel? category,
  }) async {
    final nameController = TextEditingController(
      text: category?.name ?? '',
    );

    final imageController = TextEditingController(
      text: category?.image ?? '',
    );

    bool isActive = category?.isActive ?? true;

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        bool saving = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> save() async {
              if (!formKey.currentState!.validate()) {
                return;
              }

              setDialogState(() {
                saving = true;
              });

              try {
                if (category == null) {
                  await _repository.createCategory(
                    name: nameController.text,
                    image: imageController.text,
                  );
                } else {
                  await _repository.updateCategory(
                    id: category.id,
                    name: nameController.text,
                    image: imageController.text,
                    isActive: isActive,
                  );
                }

                if (!dialogContext.mounted) return;

                Navigator.of(dialogContext).pop(true);
              } catch (error) {
                setDialogState(() {
                  saving = false;
                });

                if (!dialogContext.mounted) return;

                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      error
                          .toString()
                          .replaceFirst('Exception: ', ''),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }

            return AlertDialog(
              title: Text(
                category == null
                    ? 'Add Category'
                    : 'Edit Category',
              ),
              content: SizedBox(
                width: 450,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Category Name',
                          hintText: 'Example: Cardiology',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Category name is required';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: imageController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          hintText: 'Optional',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      if (category != null) ...[
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Active'),
                          value: isActive,
                          onChanged: saving
                              ? null
                              : (value) {
                                  setDialogState(() {
                                    isActive = value;
                                  });
                                },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop(false);
                        },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: saving ? null : save,
                  child: saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          category == null
                              ? 'Create'
                              : 'Update',
                        ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    imageController.dispose();

    if (result == true) {
      await _loadCategories();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            category == null
                ? 'Category created successfully'
                : 'Category updated successfully',
          ),
        ),
      );
    }
  }

  Future<void> _deleteCategory(
    CategoryModel category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text(
            'Are you sure you want to delete "${category.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _repository.deleteCategory(category.id);

      await _loadCategories();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Category deleted successfully',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Manage hospital departments and specialties.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                OutlinedButton.icon(
                  onPressed: _loadCategories,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),

                const SizedBox(width: 12),

                ElevatedButton.icon(
                  onPressed: () {
                    _showCategoryDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Category'),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCategories,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_categories.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 60,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'No categories found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Click "Add Category" to create your first category.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 1,
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) {
          return const Divider(height: 1);
        },
        itemBuilder: (context, index) {
          final category = _categories[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            leading: CircleAvatar(
              backgroundColor:
                  const Color(0xFFE8F0FE),
              child: const Icon(
                Icons.category_outlined,
                color: Color(0xFF2563EB),
              ),
            ),
            title: Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              category.image.isEmpty
                  ? 'No image'
                  : category.image,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  onPressed: () {
                    _showCategoryDialog(
                      category: category,
                    );
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                  ),
                ),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: () {
                    _deleteCategory(category);
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}