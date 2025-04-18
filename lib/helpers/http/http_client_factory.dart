// import 'dart:io';

// import 'package:cronet_http/cronet_http.dart';
// import 'package:cupertino_http/cupertino_http.dart';
// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart';
// import 'package:http/io_client.dart';

// const _maxCacheSize = 2 * 1024 * 1024;

// Client httpClient() {
//   if (Platform.isAndroid) {
//     WidgetsFlutterBinding.ensureInitialized();
//     final engine = CronetEngine.build(
//         cacheMode: CacheMode.memory,
//         cacheMaxSize: _maxCacheSize,
//         userAgent: 'Book Agent');
//     return CronetClient.fromCronetEngine(engine);
//   }
//   if (Platform.isIOS || Platform.isMacOS) {
//     final config = URLSessionConfiguration.ephemeralSessionConfiguration()
//       ..cache = URLCache.withCapacity(memoryCapacity: _maxCacheSize)
//       ..httpAdditionalHeaders = {'User-Agent': 'Book Agent'};
//     return CupertinoClient.fromSessionConfiguration(config);
//   }
//   return IOClient(HttpClient()..userAgent = 'Book Agent');
// }
