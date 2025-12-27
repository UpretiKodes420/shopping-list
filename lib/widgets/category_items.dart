import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/category_item.dart';

class CategoryItems extends StatefulWidget {
  const CategoryItems({super.key});

  @override
  State<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  List<GroceryItem> itemSet = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadScreen();
  }

  void _loadScreen() async {
    var url = Uri.https(
      "shopping-list-f9d11-default-rtdb.firebaseio.com",
      "shopping-list.json",
    );
    var response = await http.get(url);
    Map<String, dynamic> dbFetchedData = json.decode(response.body);
    List<GroceryItem> loadedItems = [];
    for (final item in dbFetchedData.entries) {
      Category cat = categories.entries
          .firstWhere(
            (categoryItem) =>
                item.value["category"] == categoryItem.value.title,
          )
          .value;
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: cat,
        ),
      );
    }
    setState(() {
      itemSet = loadedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "Oops No Groceries Items added yet..",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push<GroceryItem>(
                MaterialPageRoute(builder: (ctx) => NewItem()),
              );
              _loadScreen();
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: Text(
          "Your Groceries",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: itemSet.isEmpty
          ? content
          : ListView.builder(
              itemCount: itemSet.length,
              // scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Dismissible(
                key: ValueKey(itemSet[index].id),
                direction: DismissDirection.startToEnd,
                child: CategoryItemViewer(item: itemSet[index]),
                onDismissed: (direction) async {
                  var url = Uri.https(
                    "shopping-list-f9d11-default-rtdb.firebaseio.com",
                    "shopping-list/${itemSet[index].id}.json",
                  );
                  var response = await http.delete(url);
                  String Message = "";

                  if (response.statusCode >= 200 && response.statusCode < 300) {
                    setState(() {
                      itemSet.remove(itemSet[index]);
                    });

                    Message = "Sucessfully deleted grocery Item from list";
                  } else {
                    Message =
                        "Some Error occured while deleting the item from list";
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${response.statusCode} $Message"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
