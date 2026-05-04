import 'package:flutter/material.dart';
import 'package:kotlin_shared_preferences/core/core.dart';

// EN: Screen for saving / loading a single string.
//     Equivalent to prefs.setString('text', value) / prefs.getString('text') with the package.
// JP: 1つの文字列(String)を保存・読み込みする画面。
//     パッケージで言えば prefs.setString('text', value) / prefs.getString('text') と同じ動作。
class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    // EN: With the package you got a String directly, but here it comes back as dynamic.
    //     We know what's stored under 'text' is a String, so we drop it straight into controller.text.
    // JP: パッケージなら String がそのまま返ってきたが、ここでは dynamic で返ってくる。
    //     'text' に保存されているのが String だと分かっているので、そのまま controller.text に入れる。
    Core.get('text').then((value) {
      controller.text = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: TextField(
            controller: controller,
            // EN: Save the text the user typed.
            // JP: ユーザーが入力したテキストを保存する。
            onChanged: (value) => Core.set('text', value),
          ),
        ),
      ),
    );
  }
}
