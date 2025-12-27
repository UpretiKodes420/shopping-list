import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    Map<String, Map<String, dynamic>> itemResponse = json.decode(response.body);
    print(itemResponse);
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
                onDismissed: (direction) {
                  setState(() {
                    itemSet.remove(itemSet[index]);
                  });
                },
              ),
            ),
    );
  }
}
