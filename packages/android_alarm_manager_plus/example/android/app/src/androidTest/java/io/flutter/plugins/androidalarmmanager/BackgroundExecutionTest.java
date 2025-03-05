// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.androidalarmmanager;

import static androidx.test.espresso.flutter.EspressoFlutter.onFlutterWidget;
import static androidx.test.espresso.flutter.action.FlutterActions.click;
import static androidx.test.espresso.flutter.matcher.FlutterMatchers.withValueKey;
import static org.junit.Assert.assertEquals;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import androidx.test.InstrumentationRegistry;
import androidx.test.core.app.ActivityScenario;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.rule.ActivityTestRule;

import com.example.example.MainActivity;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

/*
 * To run this test, run:
 * ./gradlew app:connectedAndroidTest -Ptarget=`pwd`/../lib/main_espresso.dart
 */
@RunWith(AndroidJUnit4.class)
public class BackgroundExecutionTest {
    static final String COUNT_KEY = "flutter.count";
    @Rule
    public ActivityTestRule<MainActivity> myActivityTestRule =
            new ActivityTestRule<>(MainActivity.class, true, false);
    private SharedPreferences prefs;

    @Before
    public void setUp() throws Exception {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        prefs.edit().putLong(COUNT_KEY, 0).apply();

        ActivityScenario.launch(MainActivity.class);
    }

    @Test
    public void startBackgroundIsolate() throws Exception {
        Log.d("BackgroundExecutionTest", "Started");

        // Register a one shot alarm which will go off in ~5 seconds.
        onFlutterWidget(withValueKey("RegisterOneShotAlarm")).perform(click());

        // The alarm count should be 0 after installation.
        assertEquals(prefs.getLong(COUNT_KEY, -1), 0);

        // Close the application to background it.
        // @miquelbeltran: Original code contained this line, the test pass but never finish if the
        //                 activity is closed
        // pressBackUnconditionally();
        // Log.d("BackgroundExecutionTest","App closed");

        // The alarm should eventually fire, wake up the application, create a
        // background isolate, and then increment the counter in the shared
        // preferences. Timeout after 20s, just to be safe.
        int tries = 0;
        while ((prefs.getLong(COUNT_KEY, -1) == 0) && (tries < 200)) {
            Thread.sleep(100);
            ++tries;
            Log.d("BackgroundExecutionTest", "Waiting...");
        }
        assertEquals(prefs.getLong(COUNT_KEY, -1), 1);
        Log.d("BackgroundExecutionTest", "Finished");
    }
}
