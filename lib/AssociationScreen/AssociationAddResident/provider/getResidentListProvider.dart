import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Core/AuthService/AuthServiceProvider.dart';
import '../../../Core/data/model/ResponseModel/getResidentResModel.dart';

final getResidentListProvider = FutureProvider.autoDispose<GetResidentListModel>((ref) {
  final auth = ref.read(authServiceProvider);
  return auth.getResidentList();
});
