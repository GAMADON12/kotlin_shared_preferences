package com.example.kotlin_shared_preferences

import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.content.edit

// EN: When using the shared_preferences package in Flutter, you never had to touch this file —
//     the package handled the Kotlin <-> Dart connection internally.
//     When you can't use the package, you have to build that connection yourself, and that's what this file does.
// JP: Flutter で shared_preferences パッケージを使っていた時は、このファイルを触る必要はなかった。
//     パッケージが内部で Kotlin <-> Dart の接続を処理してくれていたから。
//     パッケージが使えない場合は、その接続を自分で作る必要があり、それがこのファイルの役割。
class MainActivity : FlutterActivity() {
  // EN: SharedPreferences is Android's built-in key-value storage.
  //     The shared_preferences package also calls this internally.
  // JP: SharedPreferences は Android が標準で提供するキーバリュー型のストレージ。
  //     shared_preferences パッケージも内部ではこれを呼び出している。
  lateinit var prefs: SharedPreferences

  // EN: Called once when the app starts. We set up here so we're ready to receive calls from Dart.
  // JP: アプリ起動時に一度だけ呼ばれる。ここで Dart からの呼び出しを受ける準備をしておく。
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    // EN: Open a storage file named "prefs". If it doesn't exist, it gets created.
    //     This name is just an identifier — anything works, and it has nothing to do with the Dart side.
    // JP: "prefs" という名前のストレージを開く。なければ新しく作られる。
    //     この名前は単なる識別子なので何でもよく、Dart 側とは無関係。
    prefs = getSharedPreferences("prefs", MODE_PRIVATE)

    val messenger = flutterEngine.dartExecutor.binaryMessenger

    // EN: This pairs with Dart's MethodChannel('kotlin').
    //     When Dart calls channel.invokeMethod('set', ...), the lambda below runs.
    //     call.method tells you which feature was called.
    // JP: Dart 側の MethodChannel('kotlin') と対になる部分。
    //     Dart で channel.invokeMethod('set', ...) を呼ぶと、下のラムダが実行される。
    //     call.method の値で、どの機能が呼ばれたかを判別する。
    MethodChannel(messenger, "kotlin").setMethodCallHandler { call, result ->
      when (call.method) {
        // EN: Where Dart's Core.set arrives.
        // JP: Dart の Core.set が届く場所。
        "set" -> {
          // EN: Pull key and value out of the Map sent from Dart.
          // JP: Dart から送られてきた Map から key と value を取り出す。
          val key = call.argument<String>("key")!!
          val value = call.argument<String>("value")!!

          // EN: Save into SharedPreferences. Since Dart already turned the value into a string with jsonEncode, putString is enough.
          //     If Dart had sent values by type, you'd have to write branches here for putInt, putStringSet, etc.
          // JP: SharedPreferences に保存する。Dart 側で jsonEncode により文字列化済みなので putString だけで十分。
          //     もし Dart が型ごとに送っていたら、ここで putInt や putStringSet の分岐を書く必要があった。
          prefs.edit { putString(key, value) }

          // EN: Signal that completes the Future on the Dart side. If you skip this, Dart waits for a response forever.
          // JP: Dart 側の Future を完了させる合図。これを呼ばないと Dart は応答を永遠に待ち続ける。
          result.success(true)
        }

        // EN: Where Dart's Core.get arrives.
        // JP: Dart の Core.get が届く場所。
        "get" -> {
          val key = call.argument<String>("key")!!
          // EN: The second argument is the default returned when the key doesn't exist.
          //     Using an empty string makes it easy for Dart to treat it as "no value".
          // JP: 第2引数はキーが存在しない時に返されるデフォルト値。
          //     空文字にしておくと Dart 側で「値なし」として扱いやすい。
          val value = prefs.getString(key, "")
          result.success(value)
        }
      }
    }
  }
}
