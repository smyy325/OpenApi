import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for StoreApi
void main() {
  final instance = Openapi().getStoreApi();

  group(StoreApi, () {
    // Delete purchase order by identifier.
    //
    // For valid response try integer IDs with value < 1000. Anything above 1000 or non-integers will generate API errors.
    //
    //Future deleteOrder(int orderId) async
    test('test deleteOrder', () async {
      // TODO
    });

    // Returns pet inventories by status.
    //
    // Returns a map of status codes to quantities.
    //
    //Future<BuiltMap<String, int>> getInventory() async
    test('test getInventory', () async {
      // TODO
    });

    // Find purchase order by ID.
    //
    // For valid response try integer IDs with value <= 5 or > 10. Other values will generate exceptions.
    //
    //Future<Order> getOrderById(int orderId) async
    test('test getOrderById', () async {
      // TODO
    });

    // Place an order for a pet.
    //
    // Place a new order in the store.
    //
    //Future<Order> placeOrder({ Order order }) async
    test('test placeOrder', () async {
      // TODO
    });

  });
}
