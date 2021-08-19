// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.androidalarmmanager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import org.json.JSONException;

public class AlarmBroadcastReceiver extends BroadcastReceiver {
  /**
   * Invoked by the OS when a timer goes off.
   *
   * <p>The associated timer was registered in {@link AlarmService}.
   *
   * <p>In Android, timer notifications require a {@link BroadcastReceiver} as the artifact that is
   * notified when the timer goes off. As a result, this method is kept simple, immediately
   * offloading any work to {@link AlarmService#enqueueAlarmProcessing(Context, Intent)}.
   *
   * <p>This method is the beginning of an execution path that will eventually execute a desired
   * Dart callback function, as registed by the Dart side of the android_alarm_manager plugin.
   * However, there may be asynchronous gaps between {@code onReceive()} and the eventual invocation
   * of the Dart callback because {@link AlarmService} may need to spin up a Flutter execution
   * context before the callback can be invoked.
   */
  @Override
  public void onReceive(Context context, Intent intent) {
    AlarmService.enqueueAlarmProcessing(context, intent);
    int requestCode = intent.getIntExtra("id", 0);
    Log.d("Scheduled alarms list", String.valueOf(requestCode));
    // If the alarm being fired is a oneshot alarm, it should be removed from the list of scheduled
    //alarms.
    try {
      ScheduledAlarmsList.removeFromScheduledAlarmsList(requestCode, context, true);
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }
}
