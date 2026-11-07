import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Core/AuthService/AuthServiceProvider.dart';
import '../../../Core/data/model/ResponseModel/MarkNotificationReadResModel.dart';

final markNotificationReadProvider = FutureProvider.family
    .autoDispose<MarkNotificationReadResModel, String>((ref, id) async {
      final service = ref.read(authServiceProvider);
      return await service.markNotificationRead(id: id);
    });

final markMultipleNotificationsReadProvider = FutureProvider.family
    .autoDispose<MarkNotificationReadResModel?, List<String>>((ref, ids) async {
      final service = ref.read(authServiceProvider);
      return await service.markMultipleNotificationsRead(ids: ids);
    });
