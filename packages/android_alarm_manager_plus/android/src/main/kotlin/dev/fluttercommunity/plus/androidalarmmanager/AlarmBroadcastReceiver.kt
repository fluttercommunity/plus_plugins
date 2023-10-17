// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package dev.fluttercommunity.plus.androidalarmmanager

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class AlarmBroadcastReceiver : BroadcastReceiver() {
  /**
   * Invoked by the OS when a timer goes off.
   *
   * The associated timer was registered in [AlarmService].
   *
   * In Android, timer notifications require a [BroadcastReceiver] as the artifact that is
   * notified when the timer goes off. As a result, this method is kept simple, immediately
   * offloading any work to [AlarmService.enqueueAlarmProcessing].
   *
   * This method is the beginning of an execution path that will eventually execute a desired
   * Dart callback function, as registered by the Dart side of the android_alarm_manager plugin.
   * However, there may be asynchronous gaps between [onReceive] and the eventual invocation
   * of the Dart callback because [AlarmService] may need to spin up a Flutter execution
   * context before the callback can be invoked.
   */
  override fun onReceive(context: Context, intent: Intent) {
    AlarmService.enqueueAlarmProcessing(context, intent)
  }
}