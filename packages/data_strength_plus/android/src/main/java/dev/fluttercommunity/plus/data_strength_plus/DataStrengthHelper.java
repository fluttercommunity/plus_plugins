package dev.fluttercommunity.plus.data_strength_plus;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.telephony.CellInfo;
import android.telephony.CellInfoCdma;
import android.telephony.CellInfoGsm;
import android.telephony.CellInfoLte;
import android.telephony.CellSignalStrength;
import android.telephony.SignalStrength;
import android.telephony.TelephonyManager;

public class DataStrengthHelper {

  Context context;

  DataStrengthHelper(Context mcontext) {
    this.context = mcontext;
  }

  public Integer getMobileSignalStrength() {
    TelephonyManager telephonyManager =
        (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      SignalStrength signalStrength = telephonyManager.getSignalStrength();
      if (signalStrength != null) {
        for (CellSignalStrength cellSignalStrength : signalStrength.getCellSignalStrengths()) {
          return cellSignalStrength.getDbm();
        }
      }
      return null;
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      for (CellInfo cellInfo : telephonyManager.getAllCellInfo()) {
        if (cellInfo instanceof CellInfoGsm) {
          CellSignalStrength gsm = ((CellInfoGsm) cellInfo).getCellSignalStrength();
          if (gsm.getDbm() > 0) return null;
          return gsm.getDbm();
        } else if (cellInfo instanceof CellInfoCdma) {
          CellSignalStrength cdma = ((CellInfoCdma) cellInfo).getCellSignalStrength();
          if (cdma.getDbm() > 0) return null;
          return cdma.getDbm();
        } else if (cellInfo instanceof CellInfoLte) {
          CellSignalStrength lte = ((CellInfoLte) cellInfo).getCellSignalStrength();
          if (lte.getDbm() > 0) return null;
          return lte.getDbm();
        }
      }
      return null;
    }
    return null;
  }

  public Integer getWifiSignalStrength() {
    WifiManager wifiManager =
        (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
    if (wifiManager.isWifiEnabled()) {
      WifiInfo wifiInfo = wifiManager.getConnectionInfo();
      if (wifiInfo != null) {
        return wifiInfo.getRssi();
      }
    }
    return null;
  }

  public Integer getWifiLinkSpeed() {
    WifiManager wifiManager =
        (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
    if (wifiManager.isWifiEnabled()) {
      WifiInfo wifiInfo = wifiManager.getConnectionInfo();
      if (wifiInfo != null) return wifiInfo.getLinkSpeed();
    }
    return null;
  }
}
