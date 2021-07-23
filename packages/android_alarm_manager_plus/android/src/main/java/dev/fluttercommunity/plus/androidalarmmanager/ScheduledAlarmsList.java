package dev.fluttercommunity.plus.androidalarmmanager;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashSet;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * This class does not affect the behaviour of the alarms, just lists all the scheduled alarms.
 * All the data is stored as a Set<String>, with each element of this set being a JSONObject which
 * is converted to a string. As data passed from flutter is assigned to PeriodicRequest or
 * OneShotRequest, this class consists an overloaded function which serializes these objects into
 * JSONObjects. This helps while storing data in shared preferences and easy access to the key
 * values of the alarm.
 */

public class ScheduledAlarmsList {
  private static final String TAG = "Scheduled alarms list";
  private static final String SCHEDULED_ALARMS_SP_KEY = "scheduled_alarms_sp_key";
  private static final String SCHEDULED_ALARMS_LIST_KEY = "scheduled_alarms_list_key";

  /**
   * Serializes PeriodicRequest object into json object for easy handling.
   *
   * @param periodicRequest Alarm data passed from the flutter side.
   * @return a json object representation of periodic alarm data.
   * @throws JSONException
   */
  public static JSONObject toJson(AndroidAlarmManagerPlugin.PeriodicRequest periodicRequest) throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("requestCode", periodicRequest.requestCode);
    jsonObject.put("exact", periodicRequest.exact);
    jsonObject.put("wakeup", periodicRequest.wakeup);
    jsonObject.put("startMillis", periodicRequest.startMillis);
    jsonObject.put("intervalMillis", periodicRequest.intervalMillis);
    jsonObject.put("rescheduleOnReboot", periodicRequest.rescheduleOnReboot);
    jsonObject.put("callbackHandle", periodicRequest.callbackHandle);
    jsonObject.put("alarmType", "periodic");
    return jsonObject;
  }

  /**
   * Serializes OneShotRequest object into json object for easy handling.
   *
   * @param oneShotRequest Alarm data passed from the flutter side.
   * @return a json object representation of one shot alarm data.
   * @throws JSONException
   */
  public static JSONObject toJson(AndroidAlarmManagerPlugin.OneShotRequest oneShotRequest) throws JSONException {
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("requestCode", oneShotRequest.requestCode);
    jsonObject.put("alarmClock", oneShotRequest.alarmClock);
    jsonObject.put("allowWhileIdle", oneShotRequest.allowWhileIdle);
    jsonObject.put("exact", oneShotRequest.exact);
    jsonObject.put("wakeup", oneShotRequest.wakeup);
    jsonObject.put("startMillis", oneShotRequest.startMillis);
    jsonObject.put("rescheduleOnReboot", oneShotRequest.rescheduleOnReboot);
    jsonObject.put("callbackHandle", oneShotRequest.callbackHandle);
    jsonObject.put("alarmType", "oneshot");
    return jsonObject;
  }

  /**
   * Adds an alarm to the shared preferences whenever user creates a new alarm.
   *
   * @param jsonObject Data about the type of alarm and its corresponding information.
   * @param context
   */

  public static void addToScheduledAlarmsList(JSONObject jsonObject, Context context) {
    SharedPreferences prefs = context.getSharedPreferences(SCHEDULED_ALARMS_SP_KEY, Context.MODE_PRIVATE);
    Set<String> listFromPrefs = prefs.getStringSet(SCHEDULED_ALARMS_LIST_KEY, null);
    Set<String> scheduledList = new HashSet<>();
    if (listFromPrefs != null)
      scheduledList.addAll(listFromPrefs);
    /*
      We find the following note in the Android API

      "Note that you must not modify the set instance returned by this call. The consistency of the
      stored data is not guaranteed if you do, nor is your ability to modify the instance at all.".

      Hence the list is first fetched from Shared Preferences and then is made a copy of. All
      mutations are done on that copy and is reassigned back to Shared preference in the same key.
      Not doing so throws erroneous results.

     */
    scheduledList.add(jsonObject.toString());
    SharedPreferences.Editor editor = prefs.edit();
    editor.putStringSet(SCHEDULED_ALARMS_LIST_KEY, scheduledList);
    editor.apply();
    Log.d(TAG, "Alarm added");
    getScheduledAlarms(context);
  }

  /**
   * Removes alarm info for a given request code. This function has to handle two cases
   * <ol>
   *   <li>
   *     Oneshot alarms - These alarms will fire only once. Hence the plugin has to remove it from
   *     the list of scheduled alarms as and when it is fired. {@link AlarmBroadcastReceiver}
   *     overrides an {@link AlarmBroadcastReceiver#onReceive(Context, Intent)} which is fired
   *     everytime an alarm is fired, regardless of it being a periodic alarm or oneshot. So in this
   *     case the plugin first checks if alarm data with the same requestCode exists in the
   *     shared preferences. If yes, then it checks whether the alarm data is for a periodic alarm
   *     or an oneshot alarm. If it is oneshot then that data is removed from the set.
   *   </li>
   *   <li>
   *     Periodic alarms- Peroidic alarms can only be removed manualy. This happens when the
   *     {@link AlarmService#cancel(Context, int)} is called from
   *     {@link AndroidAlarmManagerPlugin#onMethodCall(MethodCall, MethodChannel.Result)}. In this
   *     case both oneshot and periodic alarms can be cancelled. Hence the plugin does not check for
   *     the alarm type and removes the alarm data upon getting a match on the requestCode.
   *   </li>
   * </ol>
   * @param requestCode Each alarm is assigned a unique request code as an identifier. This request
   *                    code is required for cancelling an alarm.
   * @param context
   * @param checkForOneShot Depending on from where this method is being called, the plugin needs to
   *                        check for whether an alarm being fired is an oneshot alarm or not.
   * @throws JSONException
   */
  public static void removeFromScheduledAlarmsList(int requestCode, Context context, boolean checkForOneShot) throws JSONException {
    SharedPreferences prefs = context.getSharedPreferences(SCHEDULED_ALARMS_SP_KEY, Context.MODE_PRIVATE);
    Set<String> listFromPrefs = prefs.getStringSet(SCHEDULED_ALARMS_LIST_KEY, null);
    Set<String> scheduledList = new HashSet<>();
    if (listFromPrefs != null)
      scheduledList.addAll(listFromPrefs);

    if (!scheduledList.isEmpty()) {
      JSONObject toRemove = null;
      for (String alarm : scheduledList) {
        JSONObject jsonObject = new JSONObject(alarm);
        if (jsonObject.getInt("requestCode") == requestCode) {
          toRemove = jsonObject;
          break;
        }
      }
      if (toRemove != null) {
        if (checkForOneShot) {
          if (toRemove.getString("alarmType").equalsIgnoreCase("oneshot")) {
            scheduledList.remove(toRemove.toString());
          } else Log.d(TAG, "Fired due to periodic alarm");
        } else {
          // The alarm is cancelled by the user
          scheduledList.remove(toRemove.toString());
        }

      } else
        Log.e(TAG, "Alarm not found");
      SharedPreferences.Editor editor = prefs.edit();
      editor.putStringSet(SCHEDULED_ALARMS_LIST_KEY, scheduledList);
      editor.apply();
    } else
      Log.e(TAG, "No alarms scheduled");
    getScheduledAlarms(context);
  }

  public static String getScheduledAlarms(Context context) {
    SharedPreferences prefs = context.getSharedPreferences(SCHEDULED_ALARMS_SP_KEY, Context.MODE_PRIVATE);
    Set<String> scheduledList = prefs.getStringSet(SCHEDULED_ALARMS_LIST_KEY, null);
    if (scheduledList == null)
      scheduledList = new HashSet<>();
    Log.d(TAG, scheduledList.toString());
    return scheduledList.toString();
  }

}
