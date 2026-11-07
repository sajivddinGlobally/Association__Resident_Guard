import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Core/AuthService/AuthServiceProvider.dart';
import '../../../Core/data/model/ResponseModel/GetNotificaionListModel.dart';

final getNotificaionListProvider = FutureProvider.family
    .autoDispose<GetNotificaionListModel, String>((ref, filter) async {
      final service = ref.read(authServiceProvider);
      return await service.getNotificaionList(filter: filter);
    });
