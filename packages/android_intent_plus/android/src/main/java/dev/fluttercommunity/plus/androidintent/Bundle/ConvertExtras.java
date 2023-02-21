package dev.fluttercommunity.plus.androidintent.Bundle;

import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBool;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBoolArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutBundle;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutInt;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutIntArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutParcelableArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutString;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArray;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.PutStringArrayList;
import dev.fluttercommunity.plus.androidintent.Bundle.PutClasses.base.PutBase;

public class ConvertExtras {
  public static void convert(android.os.Bundle bundle, PutBase putBase) {
    if (putBase instanceof PutBool) {
      PutBool.convert(bundle, (PutBool) putBase);
    } else if (putBase instanceof PutBoolArray) {
      PutBoolArray.convert(bundle, (PutBoolArray) putBase);
    } else if (putBase instanceof PutBundle) {
      PutBundle.convert(bundle, (PutBundle) putBase);
    } else if (putBase instanceof PutParcelableArray) {
      PutParcelableArray.convert(bundle, (PutParcelableArray) putBase);
    } else if (putBase instanceof PutParcelableArrayList) {
      PutParcelableArrayList.convert(bundle, (PutParcelableArrayList) putBase);
    } else if (putBase instanceof PutInt) {
      PutInt.convert(bundle, (PutInt) putBase);
    } else if (putBase instanceof PutIntArray) {
      PutIntArray.convert(bundle, (PutIntArray) putBase);
    } else if (putBase instanceof PutIntArrayList) {
      PutIntArrayList.convert(bundle, (PutIntArrayList) putBase);
    } else if (putBase instanceof PutString) {
      PutString.convert(bundle, (PutString) putBase);
    } else if (putBase instanceof PutStringArray) {
      PutStringArray.convert(bundle, (PutStringArray) putBase);
    } else if (putBase instanceof PutStringArrayList) {
      PutStringArrayList.convert(bundle, (PutStringArrayList) putBase);
    }
  }
}
