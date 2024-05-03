package dev.fluttercommunity.plus.androidalarmmanager;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

public class AlarmFlagManager {

  private static final String FLUTTER_SHARED_PREFERENCE_KEY = "FlutterSharedPreferences";
  private static final String ALARM_FLAG_KEY = "flutter.alarmFlagKey";

  static public void set(Context context, Intent intent) {
    int alarmId = intent.getIntExtra("id", -1);

    SharedPreferences prefs = context.getSharedPreferences(FLUTTER_SHARED_PREFERENCE_KEY, 0);
    prefs.edit().putLong(ALARM_FLAG_KEY, alarmId).apply();
  }
}
