import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_github_client/common/global.dart';

void main() {
  Global.init().then((e) => runApp(MyApp()));
}

// 顶层Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeModel()),
          ChangeNotifierProvider(create: (_) => UserModel()),
          ChangeNotifierProvider(create: (_) => LocalModel()),
        ],
        child: Consumer2<ThemeModel, LocalModel>(
            builder: (BuildContext context, themeModel, localModel, child) {
              return MaterialApp(
                theme: ThemeData(
                  primarySwatch: themeModel.theme
                ),
                // TODO: 国际化
                onGenerateTitle: () {
                  return GmLocalizations.of(context).title;
                }
                home: HomeRoute(),
                supportedLocales: [
                    const Locale("en", "US"),
                    const Locale("zh", "CN"),
                    // 更多语言
                ],
                localizationsDelegates: [
                    // 本地化的代理类
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GmLocalizationsDelegate()
                ],
                localeResolutionCallback: (_locale, supportedLocales) {
                  if (localModel.getLocate() != null) {
                    return localModel.getLocate();
                  } else {
                    // 跟随系统
                    Locale locale;
                    if (supportedLocales.contains(_locale)) {
                      locale = _locale;
                    } else {
                      locale = Locale("en", "US");
                    }
                    return locale;
                  }
                },
                routes: <String, WidgetBuilder> {
                  "login": (context) => Login

                },
                );
            }));
  }
}
