import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = WindowOptions(
    size: Size(1800, 1000),
    minimumSize: Size(800, 400),
    // center: true,
    // backgroundColor: Colors.transparent,
    // skipTaskbar: false,
    // titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Map<String, Object>> keywords = [
    {
      "name": "Memory",
      "color": Colors.red,
    },
    {
      "name": "Social",
      "color": Colors.blue,
    },
    {
      "name": "Learning",
      "color": Colors.green,
    },
    {
      "name": "Belief",
      "color": Colors.yellow,
    },
    {
      "name": "Money",
      "color": Colors.purple,
    },
    {
      "name": "Politics",
      "color": Colors.orange,
    },
  ];

  final List<Map<String, String>> info = [
    {
      "title": "Fundamental Attribution Error",
      "description":
          "We judge others on their personality or fundamental character, while we judge ourselves on the situation.",
      "imageUrl": "",
      "example":
          "Example: When someone cuts you off in traffic, you think they are a bad driver. When you cut someone off, you think it was because you were running late."
    },
    {
      "title": "Self-Serving Bias",
      "description":
          "Our failures are situational, but our successes are our responsibility.",
      "imageUrl": "",
      "example":
          "Example: When you fail a test, you blame the teacher. When you pass a test, you take all the credit."
    },
    {
      "title": "In-Group Favoritism",
      "description":
          "We favor people who are in our in-group as opposed to those who are in our out-group.",
      "imageUrl": "",
      "example":
          "Example: You are more likely to hire someone who went to the same college as you than someone who went to a different college."
    },
    {
      "title": "Confirmation Bias",
      "description":
          "We seek out information that confirms our beliefs and ignore information that contradicts them.",
      "imageUrl": "",
      "example":
          "Example: You only watch news channels that align with your political beliefs."
    },
    {
      "title": "Halo Effect",
      "description":
          "We assume that people who are good at one thing are good at everything.",
      "imageUrl": "",
      "example":
          "Example: You think someone who is attractive is also smart and kind."
    },
    {
      "title": "Horns Effect",
      "description":
          "We assume that people who are bad at one thing are bad at everything.",
      "imageUrl": "",
      "example":
          "Example: You think someone who is unattractive is also dumb and mean."
    },
    {
      "title": "Anchoring Bias",
      "description":
          "We rely too heavily on the first piece of information we receive.",
      "imageUrl": "",
      "example":
          "Example: You see a shirt that is \$100, but it is on sale for \$50. You think it is a great deal, even though it is still expensive."
    },
    {
      "title": "Availability Heuristic",
      "description":
          "We overestimate the importance of information that is easy to remember.",
      "imageUrl": "",
      "example":
          "Example: You think shark attacks are common because you see them on the news all the time, even though they are rare."
    },
    {
      "title": "Bandwagon Effect",
      "description":
          "We do or believe things because many other people do or believe the same.",
      "imageUrl": "",
      "example":
          "Example: You buy a product because it is popular, even though you don't know anything about it."
    },
    {
      "title": "Dunning-Kruger Effect",
      "description":
          "We overestimate our abilities because we lack the knowledge to know our limitations.",
      "imageUrl": "",
      "example":
          "Example: You think you are a great driver because you have never been in an accident, even though you have been in many near misses."
    },
    {
      "title": "Sunk Cost Fallacy",
      "description":
          "We continue to invest in something because we have already invested in",
      "imageUrl": "",
      "example":
          "Example: You think you are a great driver because you have never been in an accident, even though you have been in many near misses."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cognative Bias',
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
        useMaterial3: true,
      ),
      home: CardGridView(),
    );
    // home: CardGridView(), Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   mainAxisSize: MainAxisSize.max,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         for (var keyword in keywords)
    //           KeywordCard(
    //             keyword: keyword['name'] as String,
    //             color: keyword['color'] as Color,
    //           ),
    //       ],
    //     ),

    //     // GridView.count(
    //     //   shrinkWrap: true,
    //     //   primary: false,
    //     //   padding: const EdgeInsets.all(20),
    //     //   crossAxisCount: 5,
    //     //   children: [
    //     //     for (var item in info)
    //     //       BiasCard(
    //     //         title: item['title']!,
    //     //         description: item['description']!,
    //     //         imageUrl: item['imageUrl']!,
    //     //         example: item['example']!,
    //     //       ),
    //     //   ],
    //     // ),
    //   ],
    // ));
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

class CardGridView extends StatelessWidget {
  const CardGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      int crossAxisCount = (constraints.maxWidth / 200).floor();

      double cardMinWidth = 100;
      double cardMaxWidth = 200;

      // 确保crossAxisCount不超过最大宽度
      crossAxisCount =
          crossAxisCount > (constraints.maxWidth / cardMaxWidth).floor()
              ? (constraints.maxWidth / cardMaxWidth).floor()
              : crossAxisCount;

      return Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 0.7, // 假设Card的宽高比为1
          ),
          itemCount: 50,
          itemBuilder: (context, index) {
            return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              double cardWidth = constraints.maxWidth / crossAxisCount;
              cardWidth = cardWidth.clamp(cardMinWidth, cardMaxWidth);
              return BiasCard(
                width: cardWidth,
                height: cardWidth,
                title: 'Test',
                description: 'Test',
                imageUrl: '',
                example: 'Test',
              );
            });
          },
        ),
      );
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

  const BiasCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.example,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 5, // 阴影高度
      child: Container(
        width: width,
        height: height,
        color: Colors.blueGrey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              description,
            ),
            // Image.network(imageUrl),
            Text(
              example,
            ),
          ],
        ),
      ),
    );
  }
}
