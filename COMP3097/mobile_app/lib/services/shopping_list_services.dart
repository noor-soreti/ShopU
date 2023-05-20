import 'package:flutter/foundation.dart';
import 'package:mobile_app/database/user_database.dart';
import 'package:mobile_app/models/shopping_list_model.dart';

class ShoppingListService with ChangeNotifier {
  List<Item> _list = [];
  List<Item> get list => _list;
  List<double> _currentTotal = [];
  List<double> get currentTotal => _currentTotal;

  Future<String> getShoppingList(String username) async {
    try {
      _list = await UserDatabase.instance
          .getShoppingList(username)
          .then((value) => value);
      for (var element in _list) {
        // print(element.quantity);
      }
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return 'ok';
  }

  Future<String> getPrice(String username) async {
    try {
      _currentTotal =
          await UserDatabase.instance.getPrice(username).then((value) => value);
      notifyListeners();
    } catch (e) {
      print("getPrice() - ERR");
      return e.toString();
    }
    return 'ok';
  }

  Future<String> deleteShoppingList(Item shoppingList) async {
    try {
      await UserDatabase.instance.deleteShoppingList(shoppingList);
      // _currentTotal = _currentTotal - shoppingList.price;
    } catch (e) {
      return e.toString();
    }
    String results = await getShoppingList(shoppingList.username);
    return results;
  }

  Future<String> createShoppingList(Item shoppingList) async {
    try {
      await UserDatabase.instance.createShoppingList(shoppingList);
    } catch (e) {
      return e.toString();
    }
    String results = await getShoppingList(shoppingList.username);
    return results;
  }
}
