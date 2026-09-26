import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollCubit extends Cubit<int?> {
  ScrollCubit() : super(null);

  void setFocusedIndex(int index) => emit(index);
}
