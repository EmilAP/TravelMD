import 'package:travelmd/data/storage/storage_repository_base.dart';

import 'storage_repository_factory_io.dart'
    if (dart.library.html) 'storage_repository_factory_web.dart' as impl;

Future<StorageRepositoryBase> createStorageRepository() {
  return impl.createStorageRepository();
}
