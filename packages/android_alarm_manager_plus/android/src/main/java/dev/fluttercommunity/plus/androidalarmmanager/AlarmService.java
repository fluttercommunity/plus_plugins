// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.androidalarmmanager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.AlarmManagerCompat;
import androidx.core.app.JobIntentService;

import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CountDownLatch;

import org.json.JSONException;
import org.json.JSONObject;

public class AlarmService extends JobIntentService {
    protected static final String SHARED_PREFERENCES_KEY =
            "dev.fluttercommunity.plus.android_alarm_manager_plugin";
    private static final String TAG = "AlarmService";
    private static final String PERSISTENT_ALARMS_SET_KEY = "persistent_alarm_ids";
    private static final int JOB_ID = 1984; // Random job ID.
    private static final Object persistentAlarmsLock = new Object();

    // TODO(mattcarroll): make alarmQueue per-instance, not static.
    private static final List<Intent> alarmQueue = Collections.synchronizedList(new LinkedList<>());

    /**
     * Background Dart execution context.
     */
    private static FlutterBackgroundExecutor flutterBackgroundExecutor;

    /**
     * Schedule the alarm to be handled by the {@link AlarmService}.
     */
    public static void enqueueAlarmProcessing(Context context, Intent alarmContext) {
        enqueueWork(context, AlarmService.class, JOB_ID, alarmContext);
    }

    /**
     * Starts the background isolate for the {@link AlarmService}.
     *
     * <p>Preconditions:
     *
     * <ul>
     *   <li>The given {@code callbackHandle} must correspond to a registered Dart callback. If the
     *       handle does not resolve to a Dart callback then this method does nothing.
     *   <li>A static {@link #pluginRegistrantCallback} must exist, otherwise a {@link
     *       PluginRegistrantException} will be thrown.
     * </ul>
     */
    public static void startBackgroundIsolate(Context context, long callbackHandle) {
        if (flutterBackgroundExecutor != null) {
            Log.w(TAG, "Attempted to start a duplicate background isolate. Returning...");
            return;
        }
        flutterBackgroundExecutor = new FlutterBackgroundExecutor();
        flutterBackgroundExecutor.startBackgroundIsolate(context, callbackHandle);
    }

    /**
     * Called once the Dart isolate ({@code flutterBackgroundExecutor}) has finished initializing.
     *
     * <p>Invoked by {@link AndroidAlarmManagerPlugin} when it receives the {@code
     * AlarmService.initialized} message. Processes all alarm events that came in while the isolate
     * was starting.
     */
    /* package */
    static void onInitialized() {
        Log.i(TAG, "AlarmService started!");
        synchronized (alarmQueue) {
            // Handle all the alarm events received before the Dart isolate was
            // initialized, then clear the queue.
            for (Intent intent : alarmQueue) {
                flutterBackgroundExecutor.executeDartCallbackInBackgroundIsolate(intent, null);
            }
            alarmQueue.clear();
        }
    }

    /**
     * Sets the Dart callback handle for the Dart method that is responsible for initializing the
     * background Dart isolate, preparing it to receive Dart callback tasks requests.
     */
    public static void setCallbackDispatcher(Context context, long callbackHandle) {
        FlutterBackgroundExecutor.setCallbackDispatcher(context, callbackHandle);
    }

    private static void scheduleAlarm(
            Context context,
            int requestCode,
            boolean alarmClock,
            boolean allowWhileIdle,
            boolean repeating,
            boolean exact,
            boolean wakeup,
            long startMillis,
            long intervalMillis,
            boolean rescheduleOnReboot,
            long callbackHandle,
            JSONObject params) {
        if (rescheduleOnReboot) {
            addPersistentAlarm(
                    context,
                    requestCode,
                    alarmClock,
                    allowWhileIdle,
                    repeating,
                    exact,
                    wakeup,
                    startMillis,
                    intervalMillis,
                    callbackHandle,
                    params);
        }

        // Create an Intent for the alarm and set the desired Dart callback handle.
        Intent alarm = new Intent(context, AlarmBroadcastReceiver.class);
        alarm.putExtra("id", requestCode);
        alarm.putExtra("callbackHandle", callbackHandle);
        alarm.putExtra("params", params == null ? null : params.toString());
        PendingIntent pendingIntent =
                PendingIntent.getBroadcast(
                        context,
                        requestCode,
                        alarm,
                        (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ? PendingIntent.FLAG_IMMUTABLE : 0)
                                | PendingIntent.FLAG_UPDATE_CURRENT);

        // Use the appropriate clock.
        int clock = AlarmManager.RTC;
        if (wakeup) {
            clock = AlarmManager.RTC_WAKEUP;
        }

        // Schedule the alarm.
        AlarmManager manager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

        if (alarmClock) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !manager.canScheduleExactAlarms()) {
                Log.e(TAG, "Can`t schedule exact alarm due to revoked SCHEDULE_EXACT_ALARM permission");
            } else {
                PendingIntent showPendingIntent = createShowPendingIntent(context, requestCode, params);
                AlarmManagerCompat.setAlarmClock(
                        manager, startMillis,
                        showPendingIntent, pendingIntent);
            }
            return;
        }

        if (exact) {
            if (repeating) {
                manager.setRepeating(clock, startMillis, intervalMillis, pendingIntent);
            } else {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !manager.canScheduleExactAlarms()) {
                    Log.e(TAG, "Can`t schedule exact alarm due to revoked SCHEDULE_EXACT_ALARM permission");
                } else {
                    if (allowWhileIdle) {
                        AlarmManagerCompat.setExactAndAllowWhileIdle(
                                manager, clock, startMillis, pendingIntent);
                    } else {
                        AlarmManagerCompat.setExact(manager, clock, startMillis, pendingIntent);
                    }
                }
            }
        } else {
            if (repeating) {
                manager.setInexactRepeating(clock, startMillis, intervalMillis, pendingIntent);
            } else {
                if (allowWhileIdle) {
                    AlarmManagerCompat.setAndAllowWhileIdle(manager, clock, startMillis, pendingIntent);
                } else {
                    manager.set(clock, startMillis, pendingIntent);
                }
            }
        }
    }

    /**
     * Schedules a one-shot alarm to be executed once in the future.
     */
    public static void setOneShot(Context context, AndroidAlarmManagerPlugin.OneShotRequest request) {
        final boolean repeating = false;
        scheduleAlarm(
                context,
                request.requestCode,
                request.alarmClock,
                request.allowWhileIdle,
                repeating,
                request.exact,
                request.wakeup,
                request.startMillis,
                0,
                request.rescheduleOnReboot,
                request.callbackHandle,
                request.params);
    }

    /**
     * Schedules a periodic alarm to be executed repeatedly in the future.
     */
    public static void setPeriodic(
            Context context, AndroidAlarmManagerPlugin.PeriodicRequest request) {
        final boolean repeating = true;
        final boolean alarmClock = false;
        scheduleAlarm(
                context,
                request.requestCode,
                alarmClock,
                request.allowWhileIdle,
                repeating,
                request.exact,
                request.wakeup,
                request.startMillis,
                request.intervalMillis,
                request.rescheduleOnReboot,
                request.callbackHandle,
                request.params);
    }

    /**
     * Cancels an alarm with ID {@code requestCode}.
     */
    public static void cancel(Context context, int requestCode) {
        // Clear the alarm if it was set to be rescheduled after reboots.
        clearPersistentAlarm(context, requestCode);

        // Cancel the alarm with the system alarm service.
        Intent alarm = new Intent(context, AlarmBroadcastReceiver.class);
        PendingIntent existingIntent =
                PendingIntent.getBroadcast(
                        context,
                        requestCode,
                        alarm,
                        (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ? PendingIntent.FLAG_IMMUTABLE : 0)
                                | PendingIntent.FLAG_NO_CREATE);
        if (existingIntent == null) {
            Log.i(TAG, "cancel: broadcast receiver not found");
            return;
        }
        AlarmManager manager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        manager.cancel(existingIntent);
    }

    private static String getPersistentAlarmKey(int requestCode) {
        return "android_alarm_manager/persistent_alarm_" + requestCode;
    }

    private static void addPersistentAlarm(
            Context context,
            int requestCode,
            boolean alarmClock,
            boolean allowWhileIdle,
            boolean repeating,
            boolean exact,
            boolean wakeup,
            long startMillis,
            long intervalMillis,
            long callbackHandle,
            JSONObject params) {
        HashMap<String, Object> alarmSettings = new HashMap<>();
        alarmSettings.put("alarmClock", alarmClock);
        alarmSettings.put("allowWhileIdle", allowWhileIdle);
        alarmSettings.put("repeating", repeating);
        alarmSettings.put("exact", exact);
        alarmSettings.put("wakeup", wakeup);
        alarmSettings.put("startMillis", startMillis);
        alarmSettings.put("intervalMillis", intervalMillis);
        alarmSettings.put("callbackHandle", callbackHandle);
        alarmSettings.put("params", params);
        JSONObject obj = new JSONObject(alarmSettings);
        String key = getPersistentAlarmKey(requestCode);
        SharedPreferences prefs = context.getSharedPreferences(SHARED_PREFERENCES_KEY, 0);

        synchronized (persistentAlarmsLock) {
            Set<String> persistentAlarms =
                    new HashSet<>(prefs.getStringSet(PERSISTENT_ALARMS_SET_KEY, new HashSet<>()));
            if (persistentAlarms.isEmpty()) {
                RebootBroadcastReceiver.enableRescheduleOnReboot(context);
            }
            persistentAlarms.add(Integer.toString(requestCode));
            prefs
                    .edit()
                    .putString(key, obj.toString())
                    .putStringSet(PERSISTENT_ALARMS_SET_KEY, persistentAlarms)
                    .apply();
        }
    }

    private static void clearPersistentAlarm(Context context, int requestCode) {
        SharedPreferences prefs = context.getSharedPreferences(SHARED_PREFERENCES_KEY, 0);
        synchronized (persistentAlarmsLock) {
            Set<String> persistentAlarms =
                    new HashSet<>(prefs.getStringSet(PERSISTENT_ALARMS_SET_KEY, new HashSet<>()));
            if (!persistentAlarms.contains(Integer.toString(requestCode))) {
                return;
            }
            persistentAlarms.remove(Integer.toString(requestCode));
            String key = getPersistentAlarmKey(requestCode);
            prefs.edit().remove(key).putStringSet(PERSISTENT_ALARMS_SET_KEY, persistentAlarms).apply();

            if (persistentAlarms.isEmpty()) {
                RebootBroadcastReceiver.disableRescheduleOnReboot(context);
            }
        }
    }

    public static void reschedulePersistentAlarms(Context context) {
        synchronized (persistentAlarmsLock) {
            SharedPreferences prefs = context.getSharedPreferences(SHARED_PREFERENCES_KEY, 0);
            Set<String> persistentAlarms = prefs.getStringSet(PERSISTENT_ALARMS_SET_KEY, null);
            // No alarms to reschedule.
            if (persistentAlarms == null) {
                return;
            }

            for (String persistentAlarm : persistentAlarms) {
                int requestCode = Integer.parseInt(persistentAlarm);
                String key = getPersistentAlarmKey(requestCode);
                String json = prefs.getString(key, null);
                if (json == null) {
                    Log.e(TAG, "Data for alarm request code " + requestCode + " is invalid.");
                    continue;
                }
                try {
                    JSONObject alarm = new JSONObject(json);
                    boolean alarmClock = alarm.getBoolean("alarmClock");
                    boolean allowWhileIdle = alarm.getBoolean("allowWhileIdle");
                    boolean repeating = alarm.getBoolean("repeating");
                    boolean exact = alarm.getBoolean("exact");
                    boolean wakeup = alarm.getBoolean("wakeup");
                    long startMillis = alarm.getLong("startMillis");
                    long intervalMillis = alarm.getLong("intervalMillis");
                    long callbackHandle = alarm.getLong("callbackHandle");
                    JSONObject params = alarm.getJSONObject("params");
                    scheduleAlarm(
                            context,
                            requestCode,
                            alarmClock,
                            allowWhileIdle,
                            repeating,
                            exact,
                            wakeup,
                            startMillis,
                            intervalMillis,
                            false,
                            callbackHandle,
                            params);
                } catch (JSONException e) {
                    Log.e(TAG, "Data for alarm request code " + requestCode + " is invalid: " + json);
                }
            }
        }
    }

    private static PendingIntent createShowPendingIntent(
            Context context, int requestCode, JSONObject params) {
        PackageManager packageManager = context.getPackageManager();
        String appId = context.getPackageName();
        Intent launchIntent = packageManager.getLaunchIntentForPackage(appId);
        launchIntent.putExtra("id", requestCode);
        launchIntent.putExtra("params", params == null ? null : params.toString());
        return PendingIntent.getActivity(
                context,
                requestCode,
                launchIntent,
                (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M ? PendingIntent.FLAG_IMMUTABLE : 0)
                        | PendingIntent.FLAG_UPDATE_CURRENT);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (flutterBackgroundExecutor == null) {
            flutterBackgroundExecutor = new FlutterBackgroundExecutor();
        }
        Context context = getApplicationContext();
        flutterBackgroundExecutor.startBackgroundIsolate(context);
    }

    /**
     * Executes a Dart callback, as specified within the incoming {@code intent}.
     *
     * <p>Invoked by our {@link JobIntentService} superclass after a call to {@link
     * JobIntentService#enqueueWork(Context, Class, int, Intent);}.
     *
     * <p>If there are no pre-existing callback execution requests, other than the incoming {@code
     * intent}, then the desired Dart callback is invoked immediately.
     *
     * <p>If there are any pre-existing callback requests that have yet to be executed, the incoming
     * {@code intent} is added to the {@link #alarmQueue} to invoked later, after all pre-existing
     * callbacks have been executed.
     */
    @Override
    protected void onHandleWork(@NonNull final Intent intent) {
        // If we're in the middle of processing queued alarms, add the incoming
        // intent to the queue and return.
        synchronized (alarmQueue) {
            if (!flutterBackgroundExecutor.isRunning()) {
                Log.i(TAG, "AlarmService has not yet started.");
                alarmQueue.add(intent);
                return;
            }
        }

        // There were no pre-existing callback requests. Execute the callback
        // specified by the incoming intent.
        final CountDownLatch latch = new CountDownLatch(1);
        new Handler(getMainLooper())
                .post(
                        () -> flutterBackgroundExecutor.executeDartCallbackInBackgroundIsolate(intent, latch));

        try {
            latch.await();
        } catch (InterruptedException ex) {
            Log.i(TAG, "Exception waiting to execute Dart callback", ex);
        }
    }
}
