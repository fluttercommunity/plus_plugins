package io.flutter.plugins.androidintentexample;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

public class MyBroadcastReceiver extends BroadcastReceiver {
  @Override
  public void onReceive(Context context, Intent intent) {
    Log.d("MyBroadcastReceiver", "Got Intent: " + intent.toString());
    Toast.makeText(context, "Broadcast Received!", Toast.LENGTH_LONG).show();
  }
}
