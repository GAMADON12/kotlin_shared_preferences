import 'package:flutter/material.dart';
import 'package:kotlin_shared_preferences/core/core.dart';

// EN: Screen for saving / loading a list.
//     The package's prefs.setStringList / prefs.getStringList only handled List<String>,
//     but going through jsonEncode here means any kind of list — List<int>, List<Map>, etc. — works the same way.
// JP: リストを保存・読み込みする画面。
//     パッケージの prefs.setStringList / prefs.getStringList は List<String> しか扱えなかったが、
//     ここでは jsonEncode を経由するので List<int> や List<Map> など、どんなリストでも同じ方法で保存できる。
class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> list = [];

  @override
  void initState() {
    super.initState();

    Core.get('list').then((value) {
      // EN: jsonDecode always returns a list as List<dynamic>.
      //     Since we know we put in a list of strings, we use cast<String>() to fix the type.
      // JP: jsonDecode はリストを必ず List<dynamic> として返す。
      //     入れたのが String のリストだと分かっているので、cast<String>() で型を合わせる。
      if (value is List) list = value.cast<String>();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsetsGeometry.all(24),
          itemCount: list.length,
          itemBuilder: (context, index) => Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Text(list[index]),
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          list.add('item ${list.length}');
          // EN: Save the list.
          // JP: リストを保存する。
          Core.set('list', list);
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
