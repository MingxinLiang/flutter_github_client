// 主题颜色
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';
import '../models/user.dart';
import '../models/cache_config.dart';
import 'package:flutter_github_client/common/git.dart';
import 'package:flutter_github_client/common/cache.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static late SharedPreferences? _prefs;
  static Profile profile = Profile();

  // TODO: 网络缓存对象
  static NetCache netCache = NetCache();

  // 主题列表
  static List<MaterialColor> get themes => _themes;

  // 是否为release 版本
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // init
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs!.getString('profile');
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print("解析失败:" + e.toString());
      }
    } else {
      profile = Profile()..theme = 0;
    }

    // 缓存策略
    profile.cache = CacheConfig(enable: true, maxAge: 3600, maxCount: 100);

    // TODO: 网络请求相关配置
    Git.init();
  }

  // 持久化 profile
  static saveProfile() => _prefs!.setString('profile', jsonEncode(profile));
}

class ProfileChangeNotifier extends ChangeNotifier {
  Profile _profile = Global.profile;
  Profile get profile => _profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}

// 用户登陆状态
class UserModel extends ProfileChangeNotifier {
  User? get user => profile.user;

  // APP 是否有登陆信息
  bool get isLogin => user != null;

  set setUser(User user) {
    if (user.login != profile.user?.login) {
      profile.lastLogin = profile.user?.login;
    }
  }
}

// 主题状态
class ThemeModel extends ProfileChangeNotifier {
  ColorSwatch get theme => Global.themes
      .firstWhere((e) => e.value == profile.theme, orElse: () => Colors.blue);

  // 重新设置主题
  set setTheme(ColorSwatch color) {
    if (color != theme) {
      profile.theme = color[500]?.value;
      notifyListeners();
    }
  }
}

// 语言状态
class LocalModel extends ProfileChangeNotifier {
  // 获取当前local信息，如果为空，则跟随系统信息
  Locale? getLocate() {
    if (profile.locale == null) return null;
    var t = _profile.locale!.split("_");

    return Locale(t[0], t[1]);
  }

  String get locale => profile.locale!;

  set setLocale(String locale) {
    if (locale != profile.locale) {
      profile.locale = locale;
      notifyListeners();
    }
  }
}
