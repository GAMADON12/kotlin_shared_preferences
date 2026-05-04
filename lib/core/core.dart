import 'dart:convert';

import 'package:flutter/services.dart';

// EN: A bridge that calls Kotlin's SharedPreferences directly, replacing the shared_preferences package.
//     The package gives you typed methods like setString / getInt, but here we have to build it ourselves,
//     so everything is unified into just set / get.
// JP: shared_preferences パッケージの代わりに、Kotlin 側の SharedPreferences を直接呼び出すための橋渡し役。
//     パッケージなら setString / getInt のように型ごとのメソッドがあるが、ここでは自作するので set / get の2つに統一した。
//
// EN: Core idea —
//   - Kotlin side only handles strings.
//   - Dart converts any value into a string with jsonEncode before sending.
//   - When reading, jsonDecode turns the string back into its original shape (number / list / map).
//   This way the Kotlin code stays the same no matter how many types you add on the Dart side.
// JP: コアアイデア —
//   - Kotlin 側は文字列しか扱わない。
//   - Dart 側では jsonEncode で何でも文字列に変換してから送る。
//   - 読み込む時は jsonDecode で元の形(数値・リスト・マップ)に戻す。
//   こうすれば、型が増えても Kotlin のコードを書き足す必要がない。
class Core {
  // EN: The pipe that lets Dart and Kotlin exchange messages.
  //     The name 'kotlin' must match the name used on the Kotlin side: MethodChannel(messenger, "kotlin").
  // JP: Dart と Kotlin がメッセージをやり取りする通り道。
  //     ここで指定した 'kotlin' は、Kotlin 側の MethodChannel(messenger, "kotlin") と同じ名前にしないと繋がらない。
  static final channel = MethodChannel('kotlin');

  // EN: Replaces calls like prefs.getString(key) from the package.
  //     The package knows the type up front (getString / getInt / getStringList),
  //     but here we don't know what's stored, so we return dynamic and let the caller check the type.
  // JP: パッケージの prefs.getString(key) のような呼び出しの代わり。
  //     パッケージは型が決まっているので getString / getInt / getStringList と分かれているが、
  //     ここでは何が入っているか分からないので dynamic で返し、呼び出し側で型を確認する。
  static Future<dynamic> get(String key) async {
    // EN: Calls the 'get' case in Kotlin. The second-argument Map arrives in Kotlin as call.argument("key").
    //     Kotlin always returns a string, so we cast it to String.
    // JP: Kotlin の 'get' ケースを呼び出す。第2引数の Map が Kotlin 側で call.argument("key") として受け取られる。
    //     Kotlin は常に文字列を返すので String にキャストする。
    final value = await channel.invokeMethod('get', {'key': key}) as String;
    // EN: If the key doesn't exist, Kotlin returns an empty string (""). Passing "" to jsonDecode would crash, so we return it as-is.
    // JP: キーが存在しない場合、Kotlin は空文字("")を返す。空文字を jsonDecode に渡すとエラーになるので、そのまま返す。
    return value.isEmpty ? '' : jsonDecode(value);
  }

  // EN: Replaces calls like prefs.setString(key, value) from the package.
  //     Takes any type and turns it into a string with jsonEncode before sending to Kotlin.
  //     Examples) 1 -> "1", "hi" -> "\"hi\"", [a, b] -> "[\"a\",\"b\"]"
  // JP: パッケージの prefs.setString(key, value) のような呼び出しの代わり。
  //     どんな型でも受け取って、jsonEncode で文字列に変換してから Kotlin に渡す。
  //     例) 1 -> "1"、"hi" -> "\"hi\""、[a, b] -> "[\"a\",\"b\"]"
  static Future set(String key, dynamic value) async {
    channel.invokeMethod('set', {'key': key, 'value': jsonEncode(value)});
  }
}
