import 'package:flutter/material.dart';
import 'package:kotlin_shared_preferences/core/core.dart';
import 'package:kotlin_shared_preferences/model/user.dart';

// EN: Screen for saving / loading a model (object).
//     The package can't store objects directly, so the usual workaround was to call jsonEncode(model.toJson()) yourself
//     to make a string and pass it to prefs.setString.
//     Here Core.set runs jsonEncode internally, so you only need to pass model.toJson() and you're done.
// JP: モデル(オブジェクト)を保存・読み込みする画面。
//     パッケージにはオブジェクトをそのまま保存する機能がないので、通常は自分で jsonEncode(model.toJson()) を呼んで
//     文字列を作り、prefs.setString に渡すという形で回避していた。
//     ここでは Core.set が内部で jsonEncode をやってくれるので、model.toJson() を渡すだけで済む。
class ModelScreen extends StatefulWidget {
  const ModelScreen({super.key});

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();

    Core.get('model').then((value) {
      // EN: If nothing is saved we get '', so filter it out before passing it to fromJson.
      // JP: 何も保存されていない時は '' が来るので、fromJson に渡す前に弾いておく。
      if (value.isEmpty) return;

      // EN: value already came back as a Map (jsonDecode handled it). Pass it straight to fromJson.
      // JP: value はすでに jsonDecode を経て Map の形で入ってくる。そのまま fromJson に渡せばよい。
      final model = UserModel.fromJson(value);
      name.text = model.name;
      email.text = model.email;
      password.text = model.password;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              TextField(controller: name),
              TextField(controller: email),
              TextField(controller: password),
              TextButton(
                onPressed: () {
                  final model = UserModel(
                    name: name.text,
                    email: email.text,
                    password: password.text,
                  );
                  // EN: toJson() makes a Map -> jsonEncode inside Core.set turns it into a string -> Kotlin saves it.
                  // JP: toJson() で Map を作る -> Core.set 内部の jsonEncode で文字列に変換 -> Kotlin が保存する。
                  Core.set('model', model.toJson());
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
