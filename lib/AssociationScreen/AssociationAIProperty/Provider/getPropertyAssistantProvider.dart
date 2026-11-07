import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/data/model/ResponseModel/getPropertyAssistantModel.dart';

import '../../../Core/AuthService/AuthServiceProvider.dart';

final getPropertyAssistantProvider =
    FutureProvider.autoDispose<GetPropertyAssistantModel>((ref) async {
      final service = ref.read(authServiceProvider);
      return await service.getPropertyAssistant();
    });
