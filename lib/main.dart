import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utm_app/pop_up_menu.dart'; // Импортируйте ваш новый виджет меню
import 'package:utm_app/category.dart';
import 'package:utm_app/products.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

final buttonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.blue, // background color
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
);

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late Future<List<Category>> futureCategories;

  @override
  Widget build(BuildContext context) {
    futureCategories = fetchCategories();
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(
        child: PopUpMenu(),
      ),
      body: SafeArea(  // Добавлено для учета выступов экрана, например, выреза.
      child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  elevation: 2.0,
                  fillColor: Colors.grey[200],
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.list,
                    size: 30.0,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    // Обработчик события при нажатии на правую кнопку
                  },
                  elevation: 2.0,
                  fillColor: Colors.grey[200],
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.shopping_cart,
                    size: 30.0,
                  ),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Welcome to UTM Shop",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(  // Внешний отступ для строки поиска
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Действие для микрофона
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // цвет содержимого кнопки
                      shape: RoundedRectangleBorder( // создает прямоугольник с закругленными углами
                        borderRadius: BorderRadius.circular(10), // радиус закругления углов
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // отступы внутри кнопки
                      elevation: 5, // тень под кнопкой
                    ),
                    child: const Icon(Icons.mic), // иконка микрофона
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Chose Category',
                    style: TextStyle(fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("View all pased");
                    },
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ... ваш предыдущий код ...

            SizedBox(
              height: 80,
              child: FutureBuilder<List<Category>>(
                future: futureCategories, // используйте переменную future, которую вы определили ранее
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Нет данных'));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var category = snapshot.data![index];
                        return SizedBox(
                          width: 200, // или необходимая ширина
                          child: ListTile(
                            title: Text(category.title, overflow: TextOverflow.ellipsis),  // использовать overflow для длинных текстов
                            leading: SizedBox(
                              width: 50,  // это предотвращает ошибку, о которой мы говорили
                              height: 50,
                              child: Image.network(
                                category.image,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  // Здесь мы используем другой URL для изображения, которое должно быть показано в случае ошибки
                                  return Image.network(
                                    'https://imgtr.ee/images/2023/10/05/4a6340905a491959c13d707d31114eac.png',  // Укажите URL вашего альтернативного изображения
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            onTap: () {
                              // Ваш обработчик нажатий здесь
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'All Products',
                    style: TextStyle(fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("View all products");
                    },
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),Expanded(  // Оберните ваш GridView в Expanded
              child: FutureBuilder<List<Products>>(
                future: fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Нет данных'));
                  } else {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Два элемента в ряду
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.2), // Высота каждого элемента
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data![index];
                        return Card(
                          child: Column(
                            children: <Widget>[
                              SizedBox(  // Используйте Container или SizedBox для контроля размера изображения
                                height: 200, // желаемая высота
                                width: double.infinity, // занимает всю ширину карточки
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),  // Отступ между изображением и текстом
                              Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(product.categoryTitle, style: const TextStyle(color: Colors.grey)),
                              Text('\$${product.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      ),
    );
  }
}
