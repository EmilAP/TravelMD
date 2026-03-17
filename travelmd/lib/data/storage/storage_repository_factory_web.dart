import 'package:travelmd/data/storage/storage_repository_base.dart';
import 'package:travelmd/data/storage/storage_repository_web.dart';

Future<StorageRepositoryBase> createStorageRepository() async {
  return MemoryStorageRepository();
}
