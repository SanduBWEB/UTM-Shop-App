import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utm_app/pop_up_menu.dart';
import 'package:utm_app/category.dart';
import 'package:utm_app/products.dart';
import 'package:utm_app/wish_list.dart';
import 'package:provider/provider.dart';
import 'package:utm_app/product.dart';
import 'cart.dart';
import 'cart_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WishlistProvider(),
      child: const MyApp(),
    ),
  );
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

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late Future<List<Category>> futureCategories;
  String? selectedCategory; // Добавлено для фильтрации
  bool isHorizontalList = true;
  void _toggleListView() {
    setState(() {
      isHorizontalList = !isHorizontalList;
    });
  }
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
    isHorizontalList = true;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();  // Не забудьте освободить ресурсы контроллера
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  int cartCount = 0;
  final Cart cart = Cart();


  @override
  Widget build(BuildContext context) {
    var wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(
        child: PopUpMenu(),
      ),
      body: SafeArea(
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
                  Positioned(
                    top: 20.0,  // отступ сверху, можно регулировать
                    right: 10.0,  // отступ справа, можно регулировать
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[200], // серый фон
                          child: IconButton(
                            icon: const Icon(Icons.shopping_cart, color: Colors.grey),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CartPage(),
                              ));
                            },  // вызовите метод addToCart при нажатии
                          ),
                        ),
                        if (cart.itemCount > 0)  // Если количество товаров больше нуля
                          Positioned(
                            bottom: 0, right: 0,
                            child: CircleAvatar(
                              radius: 10.0,
                              backgroundColor: Colors.red,
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _searchController,
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
                        // Action for microphone
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        elevation: 5,
                      ),
                      child: const Icon(Icons.mic),
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
                      'Choose Category',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: _toggleListView,
                      child: Text(
                        isHorizontalList ? 'View all' : 'Show less',
                        style: const TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Category>>(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data !'));
                  } else {
                    if (isHorizontalList) {
                      return SizedBox(
                        height: 80, // Высота, подходящая для горизонтального списка
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var category = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black, backgroundColor: Colors.white,
                                  elevation: 5, // Тень кнопки
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = category.title;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      category.image,
                                      width: 40,
                                      height: 30,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(
                                          'https://cdn-icons-png.flaticon.com/512/2603/2603910.png',
                                          width: 40,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var category = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category.title;
                                });
                              },
                              leading: Image.network(
                                category.image,
                                width: 40,
                                height: 30,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://cdn-icons-png.flaticon.com/512/2603/2603910.png',
                                    width: 40,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              title: Text(category.title),
                            );
                          },
                        ),
                      );
                    }
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'All Products',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = null;
                        });
                       // print("View all products");
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
              Expanded(
                child: FutureBuilder<List<Products>>(
                  future: fetchProducts(category: selectedCategory),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Ошибка: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Нет данных'));
                    } else {
                      // Фильтрация продуктов по тексту поиска
                      String searchQuery = _searchController.text.trim().toLowerCase();  // текст запроса в нижнем регистре для упрощения сравнения
                      List<Products> products = snapshot.data!;  // список всех продуктов
                      List<Products> filteredProducts = products.where((product) {
                        return product.title.toLowerCase().contains(searchQuery);  // фильтрация по названию продукта
                      }).toList();

                      // Если запрос поиска пустой, показываем все продукты
                      if (searchQuery.isEmpty) {
                        filteredProducts = products;
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.2),
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          var product = filteredProducts[index];

                          bool isInWishlist = wishlistProvider.isInWishlist(product.id);
                          return GestureDetector(
                              onTap: () {
                            // Переход на страницу деталей продукта
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(product: product),  // Передача продукта на новую страницу
                              ),
                            );
                          },
                            child: Card(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 180,
                                        width: double.infinity,
                                        child: Image.network(product.image, fit: BoxFit.cover),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              product.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              product.categoryTitle,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              '\$${product.price}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon: Icon(
                                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                                        color: isInWishlist ? Colors.red : null,
                                      ),
                                      onPressed: () {
                                        if (isInWishlist) {
                                          wishlistProvider.remove(product.id);
                                        } else {
                                          wishlistProvider.add(product.id);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
