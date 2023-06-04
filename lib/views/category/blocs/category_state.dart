part of 'category_cubit.dart';

@immutable
abstract class CategoryState {
  final List<CategoryModel> listData;
  const CategoryState(this.listData);
}

class CategoryData extends CategoryState {
  const CategoryData(super.listData);
}

class CategoryLoading extends CategoryState {
  const CategoryLoading(super.listData);
}