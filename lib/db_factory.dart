import 'db_factory_stub.dart'
    if (dart.library.html) 'db_factory_web.dart'
    if (dart.library.js_interop) 'db_factory_web.dart';

Future<void> initDatabaseFactory() => initDatabaseFactoryImpl();
