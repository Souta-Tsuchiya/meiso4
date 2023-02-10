import 'package:meiso/data_model/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const PREFS_KEY_IS_SKIP_INTRO = "is_skip_intro";
const PREFS_KEY_LEVEL_ID = "level_id";
const PREFS_KEY_THEME_ID = "theme_id";
const PREFS_KEY_TIME = "time";

class SharedPrefsRepository {
  Future<void> skipDialog() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(PREFS_KEY_IS_SKIP_INTRO, true);
  }

  Future<bool> isSkipIntro() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PREFS_KEY_IS_SKIP_INTRO) ?? false;
  }

  Future<UserSettings> getUserSettings() async{
    final prefs = await SharedPreferences.getInstance();
    return UserSettings(
      isSkipIntroScreen: prefs.getBool(PREFS_KEY_IS_SKIP_INTRO) ?? false,
      levelId: prefs.getInt(PREFS_KEY_LEVEL_ID) ?? 0,
      themeId: prefs.getInt(PREFS_KEY_THEME_ID) ?? 0,
      timeMinutes: prefs.getInt(PREFS_KEY_TIME) ?? 5,
    );
  }

  Future<void> setLevel(int index) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(PREFS_KEY_LEVEL_ID, index);
  }

  Future<void> setTime(int timeMinutes) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(PREFS_KEY_TIME, timeMinutes);
  }

  Future<void> setTheme(int index) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(PREFS_KEY_THEME_ID, index);
  }

}