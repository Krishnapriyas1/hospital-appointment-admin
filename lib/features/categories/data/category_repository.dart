import 'package:hospital_appointment_admin/core/constants/api_constant.dart';
import 'package:hospital_appointment_admin/core/network/api_client.dart';

import '../models/category_model.dart';

class CategoryRepository {
  final ApiClient apiClient;

  CategoryRepository({
    required this.apiClient,
  });

  // ===============================
  // GET ALL CATEGORIES
  // ===============================
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get(
      ApiConstants.categories,
    );

    final data = response.data as Map<String, dynamic>;

    final List<dynamic> categories =
        data['categories'] as List<dynamic>? ?? [];

    return categories
        .map(
          (category) => CategoryModel.fromJson(
            category as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // ===============================
  // CREATE CATEGORY
  // ===============================
  Future<CategoryModel> createCategory({
    required String name,
    String image = '',
  }) async {
    final response = await apiClient.post(
      ApiConstants.categories,
      data: {
        'name': name.trim(),
        'image': image.trim(),
      },
    );

    final data = response.data as Map<String, dynamic>;

    return CategoryModel.fromJson(
      data['category'] as Map<String, dynamic>,
    );
  }

  // ===============================
  // UPDATE CATEGORY
  // ===============================
  Future<CategoryModel> updateCategory({
    required String id,
    required String name,
    String image = '',
    required bool isActive,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.categories}/$id',
      data: {
        'name': name.trim(),
        'image': image.trim(),
        'isActive': isActive,
      },
    );

    final data = response.data as Map<String, dynamic>;

    return CategoryModel.fromJson(
      data['category'] as Map<String, dynamic>,
    );
  }

  // ===============================
  // DELETE CATEGORY
  // ===============================
  Future<void> deleteCategory(String id) async {
    await apiClient.delete(
      '${ApiConstants.categories}/$id',
    );
  }
}