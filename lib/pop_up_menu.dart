import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width * 0.7,
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  leading: const Icon(Icons.person_2_outlined),
                  title: const Text('Personal Info'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Пункт 2'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: RawMaterialButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                padding: const EdgeInsets.all(10.0),
                elevation: 2.0,
                fillColor: Colors.red,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close,
                      size: 20.0,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Close App!",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                elevation: 2.0,
                child: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 20.0,
                ),
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}
