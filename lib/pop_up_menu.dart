import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Расположите диалоговое окно слева
      child: Container(
        height: double.infinity, // Заполните всю высоту экрана
        width: MediaQuery.of(context).size.width * 0.7, // Ширина 70% экрана
        color: Colors.white, // Цвет фона
        child: Stack(
          children: [
            // Ваши пункты меню
            Column(
              children: [
                // Пространство под кнопку "Закрыть"
                const SizedBox(height: 50),  // Задайте нужную высоту в зависимости от размера вашей кнопки
                ListTile(
                  leading: const Icon(Icons.person_2_outlined),
                  title: const Text('Personal Info'),
                  onTap: () {
                    Navigator.pop(context);
                    // Обработка выбора "Пункт 1"
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Пункт 2'),
                  onTap: () {
                    Navigator.pop(context);
                    // Обработка выбора "Пункт 2"
                  },
                ),
                // Можете добавить больше элементов в ваше меню
              ],
            ),
            // Кнопка "Закрыть"
            Positioned(
              bottom: 0, // Позиционирование снизу
              left: 0,  // Позиционирование слева
              right: 0, // Позиционирование справа (для обеспечения полной ширины)
              child: RawMaterialButton(
                onPressed: () {
                  // Этот метод закроет ваше приложение
                  SystemNavigator.pop();
                },
                padding: const EdgeInsets.all(10.0),
                elevation: 2.0,
                fillColor: Colors.red, // Красный фон кнопки
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Без закругления углов
                ),
                child: const Row( // Row для размещения иконки и текста рядом
                  mainAxisSize: MainAxisSize.min, // Занимать минимально возможное пространство
                  mainAxisAlignment: MainAxisAlignment.center, // Центрировать содержимое
                  children: [
                    Icon(
                      Icons.close,
                      size: 20.0,
                      color: Colors.white, // Белый цвет иконки
                    ),
                    SizedBox(width: 10), // Отступ между иконкой и текстом
                    Text(
                      "Close App!",
                      style: TextStyle(
                        color: Colors.white, // Белый цвет текста
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
