package io.flutter.plugins.androidintentexample;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

public class BarcodeBroadcastReceiver extends BroadcastReceiver {
  @Override
  public void onReceive(Context context, Intent intent) {
    Log.d("BarcodeBroadcastRece...", "Got Intent: " + intent.toString());
    String barcode = intent.getStringExtra("com.symbol.datawedge.data_string");
    Toast.makeText(context, "Barcode scanned: " + barcode, Toast.LENGTH_LONG).show();
  }
}
