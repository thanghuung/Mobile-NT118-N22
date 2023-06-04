
import 'package:app/fire_base/categories_controller.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/category_model.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryLoading([]));

  Future<List<CategoryModel>> getData() async {
    emit(const CategoryLoading([]));
    final list = await CategoryController.getListData();
    emit(CategoryData(list));
    return [];
  }

}
