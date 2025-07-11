import 'dart:io';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_plus/shelf_plus.dart';
import 'package:todo_microservice/todo_microservice.dart';

void main() async {
  final handler = init();
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('Server listening on port ${server.port}');
}

Handler init() {
  final app = Router().plus;

  final config = TodoApiConfiguration.withInMemoryRepository();

  app.use(logRequests());

  config.setupRootEndpoint(app);

  config.setupRoutes(app);

  return app.call;
}
