import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';

import 'logger.dart' show logger;

class MyModel with ChangeNotifier {
  final List<String> _selectedCategories = [];

  List<String> get selectedCategories => _selectedCategories;

  void addCategory(String category) {
    _selectedCategories.add(category);
    notifyListeners();
  }

  void removeCategory(String category) {
    _selectedCategories.remove(category);
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await windowManager.ensureInitialized();

  // 设置桌面平台的窗口属性
  WindowOptions windowOptions = WindowOptions(
    size: Size(1800, 1000),
    minimumSize: Size(800, 400),
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('zh', 'CN')],
      path: 'assets/translations',
      fallbackLocale: Locale('zh', 'CN'),
      useFallbackTranslations: true,
      child: ChangeNotifierProvider(
        create: (context) => MyModel(),
        child: TestApp(),
      ),
    ),
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: TestHomePage(),
    );
  }
}

class TestHomePage extends StatelessWidget {
  const TestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.setLocale(Locale('zh', 'CN'));
    windowManager.setTitle(context.tr('app_title'));

    filterCards(String s, bool add) {
      final model = Provider.of<MyModel>(context, listen: false);
      if (add) {
        model.addCategory(s);
      } else {
        model.removeCategory(s);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            TitleLabelMark(
              color: Colors.red,
              label: "Memory",
              onTap: (bool add) => filterCards("Memory", add),
              isSelected: false,
            ),
            TitleLabelMark(
              color: Colors.blue,
              label: "Social",
              onTap: (bool add) => filterCards("Social", add),
              isSelected: false,
            ),
            TitleLabelMark(
              color: Colors.green,
              label: "Learning",
              onTap: (bool add) => filterCards("Learning", add),
              isSelected: false,
            ),
            TitleLabelMark(
              color: Colors.orange,
              label: "Belief",
              onTap: (bool add) => filterCards("Belief", add),
              isSelected: false,
            ),
            TitleLabelMark(
              color: Colors.purple,
              label: "Money",
              onTap: (bool add) => filterCards("Money", add),
              isSelected: false,
            ),
            TitleLabelMark(
              color: Colors.pink,
              label: "Politics",
              onTap: (bool add) => filterCards("Politics", add),
              isSelected: false,
            ),
          ],
        ),
      ),
      body: Container(padding: EdgeInsets.all(8), child: CardGridView()),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      color: Colors.redAccent,
      theme: ThemeData(
        primarySwatch: Colors.blue, // 主色调
        visualDensity: VisualDensity.adaptivePlatformDensity, // 视觉密度
        primaryColor: Colors.blue[800],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[800],
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.notoSans(
              fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          displayLarge: GoogleFonts.roboto(fontSize: 34),
          displayMedium: GoogleFonts.roboto(fontSize: 24),
          displaySmall: GoogleFonts.roboto(fontSize: 20),
          titleLarge: GoogleFonts.roboto(
              fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          bodySmall: GoogleFonts.roboto(fontSize: 14),
        ),
        useMaterial3: true,
      ),
      home: TestHomePage(),
    );
  }
}

class KeywordCard extends StatelessWidget {
  final String keyword;
  final Color color;

  const KeywordCard({super.key, required this.keyword, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color, // 设置背景色
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          keyword,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CardGridView extends StatefulWidget {
  const CardGridView({super.key});

  @override
  CardGridState createState() => CardGridState();
}

class CardGridState extends State<CardGridView> {
  List<dynamic> sourceItems = [];

  List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      // 使用rootBundle加载json文件
      final String jsonString = await rootBundle.loadString("assets/data.json");
      sourceItems = json.decode(jsonString);
      _items = sourceItems;
    } catch (e) {
      logger.f('Failed to load items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyModel>(builder: (context, model, child) {
      _items = sourceItems.where((item) {
        if (model.selectedCategories.isEmpty) {
          return true;
        } else {
          return model.selectedCategories.every((element) {
            return item['category'].contains(element);
          });
        }
      }).toList();

      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        int crossAxisCount = (constraints.maxWidth / 200).floor();

        double cardMinWidth = 200;
        double cardMaxWidth = 250;

        // 确保crossAxisCount不超过最大宽度
        crossAxisCount =
            crossAxisCount > (constraints.maxWidth / cardMaxWidth).floor()
                ? (constraints.maxWidth / cardMaxWidth).floor()
                : crossAxisCount;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7, // 假设Card的宽高比为1
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              double cardWidth = constraints.maxWidth / crossAxisCount;
              cardWidth = cardWidth.clamp(cardMinWidth, cardMaxWidth);
              return BiasCard(
                width: cardWidth,
                height: cardWidth,
                title: _items[index]['title'] as String,
                description: _items[index]['desc'] as String,
                imageUrl: '',
                example: _items[index]['example'] as String,
                category: _items[index]['category'] as List,
              );
            });
          },
        );
      });
    });
  }
}

// Card
class BiasCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String example;
  final double width;
  final double height;
  final List category;

  const BiasCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.example,
    required this.width,
    required this.height,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String item in category)
                LabelMark(
                  label: item,
                ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              children: [
                Center(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                // Image.network(imageUrl),
                SizedBox(height: 20),
                Text(
                  example,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class TitleLabelMark extends StatefulWidget {
  final Color color;
  final String label;
  final Function(bool add) onTap;
  final bool isSelected;

  const TitleLabelMark({
    super.key,
    required this.color,
    required this.label,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<TitleLabelMark> createState() => _TitleLabelMarkState();
}

class _TitleLabelMarkState extends State<TitleLabelMark> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onTap(isSelected);
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: isSelected
              ? Color.lerp(widget.color, Colors.black, 0.5)
              : widget.color,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class LabelMark extends StatelessWidget {
  final String label;

  const LabelMark({super.key, required this.label});

  _getLabelColor(String label) {
    switch (label) {
      case 'Memory':
        return Colors.red;
      case 'Social':
        return Colors.blue;
      case 'Learning':
        return Colors.green;
      case 'Belief':
        return Colors.orange;
      case 'Money':
        return Colors.purple;
      case 'Politics':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getLabelColor(label),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      width: 25,
      height: 20,
    );
  }
}
