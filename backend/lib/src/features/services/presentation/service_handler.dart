import 'package:mistrix_backend/src/core/database/mongo_database.dart';
import 'package:mistrix_backend/src/core/http/api_response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class ServiceHandler {
  const ServiceHandler(this._database);

  final MongoDatabase _database;

  Router get router {
    final router = Router();
    router.get('/', _findAll);
    return router;
  }

  Future<Response> _findAll(Request request) async {
    final documents = await _database.services.find().toList();
    final items =
        documents
            .map(
              (document) => {
                'id': document['_id'],
                'name': document['name'],
                'description': document['description'],
                'basePrice': document['basePrice'],
                'isActive': document['isActive'],
              },
            )
            .toList();
    return successResponse({'items': items});
  }
}
