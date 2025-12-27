import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';

class CategoryItemViewer extends StatelessWidget {
  const CategoryItemViewer({super.key, required this.item});
  final GroceryItem item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 25, 0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: Container(color: item.category.color),
            ),
          ),

          Text(
            item.name,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.quantity.toString(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
