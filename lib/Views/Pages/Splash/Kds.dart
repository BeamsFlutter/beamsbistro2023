
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class KitchenDisplay extends StatefulWidget {
  const KitchenDisplay({Key? key}) : super(key: key);

  @override
  State<KitchenDisplay> createState() => _KitchenDisplayState();
}

class _KitchenDisplayState extends State<KitchenDisplay> {
  @override
  Widget build(BuildContext context) {


    final List<Map<String, dynamic>> _items = List.generate(
        200,
            (index) => {
          "id": index,
          "title": "Item $index",
          "height": Random().nextInt(150) + 50.5
        });


    return Scaffold(
      body: Container(
        child: MasonryGridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemBuilder: (context, index) {
            return Container(

              // Give each item a random background color
              color: Color.fromARGB(
                  Random().nextInt(256),
                  Random().nextInt(256),
                  Random().nextInt(256),
                  Random().nextInt(256)),
              key: ValueKey(_items[index]['id']),
              child: SizedBox(
                height: _items[index]['height'],
                child: Center(
                  child: Text(_items[index]['title']),
                ),
              ),
            );
            }
            ),
        ),
      );
  }
}


