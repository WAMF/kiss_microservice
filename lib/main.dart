import 'package:shelf_plus/shelf_plus.dart';
import 'package:todo_microservice/todo_microservice.dart';

void main() => shelfRun(init);

Handler init() {
  final app = Router().plus;

  final config = TodoApiConfiguration.withInMemoryRepository();

  app.use(logRequests());

  config.setupRootEndpoint(app);

  config.setupRoutes(app);

  return app.call;
}
