import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';

import '../../../Core/data/model/ResponseModel/defaulterListModel.dart';

final getDefaulterListProvider = FutureProvider.autoDispose
    .family<DefaulterListResModel, ({String filter, String search})>((
      ref,
      tuple,
    ) async {
      final service = ref.read(authServiceProvider);
      return await service.getDefaulterList(
        filter: tuple.filter,
        search: tuple.search,
      );
    });
