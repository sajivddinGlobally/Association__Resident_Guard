import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_association_or_resident/Core/AuthService/AuthServiceProvider.dart';

import '../../../Core/data/model/ResponseModel/getDocumentListModel.dart';

final getDocumentListProvider = FutureProvider.family
    .autoDispose<GetDocumentListModel, ({String category, String search})>(
      (ref, params) async {
        final service = ref.read(authServiceProvider);
        return await service.getDocumentList(
          category: params.category,
          search: params.search,
        );
      },
    );
