import 'package:flutter/material.dart';
import 'package:kotlin_shared_preferences/core/core.dart';

// EN: Screen for saving / loading a number (int).
//     The package had separate prefs.setInt / prefs.getInt, but here Core.set / Core.get covers every type.
// JP: 数値(int)を保存・読み込みする画面。
//     パッケージでは prefs.setInt / prefs.getInt と分かれていたが、ここでは Core.set / Core.get の1組で全ての型を扱う。
class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  int number = 0;

  @override
  void initState() {
    super.initState();

    // EN: Core.get returns dynamic, so the receiving side has to confirm the type once to be safe.
    //     If nothing is saved, an empty string ('') comes back, the if condition becomes false, and number stays 0.
    // JP: Core.get は dynamic を返すので、受け取る側で型を一度確認しておくと安全。
    //     何も保存されていない場合は空文字('')が来て if 条件が false になり、number は 0 のまま。
    Core.get('number').then((value) {
      if (value is int) number = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            IconButton(
              onPressed: () {
                number--;
                // EN: Save the number.
                // JP: 数値を保存する。
                Core.set('number', number);
                setState(() {});
              },
              icon: Icon(Icons.remove),
            ),
            Text(
              number.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                number++;
                // EN: Save the number.
                // JP: 数値を保存する。
                Core.set('number', number);
                setState(() {});
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
