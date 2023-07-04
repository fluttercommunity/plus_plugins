// coverage:ignore-file
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart';

@visibleForTesting
class TestValues {
  static Bundles get emptyBundle => Bundles(
        bundles: <Bundle>[
          Bundle(
            value: [],
          ),
        ],
      );

  static Bundles get bundleWithBoolean => Bundles(
        bundles: <Bundle>[
          Bundle(
            value: [
              PutBool(
                key: 'key1',
                value: true,
              ),
              PutBool(
                key: 'key2',
                value: false,
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithBooleanArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutBoolArray(key: 'key1', value: <bool>[true, false, true]),
              PutBoolArray(key: 'key2', value: <bool>[false, true, false]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithBundle => Bundles(
        bundles: [
          Bundle(
            value: [
              PutBundle(
                key: 'key1',
                value: [
                  PutString(key: 'subKey1', value: 'value1'),
                  PutInt(key: 'subKey2', value: 1),
                ],
              ),
              PutBundle(
                key: 'key2',
                value: [
                  PutString(key: 'subKey1', value: 'value2'),
                  PutInt(key: 'subKey2', value: 2),
                ],
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithByte => Bundles(
        bundles: [
          Bundle(
            value: [
              PutByte(key: 'key1', value: -128),
              PutByte(key: 'key2', value: 127)
            ],
          ),
        ],
      );

  static Bundles get bundleWithByteInvalidLowerBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutByte(key: 'key1', value: -129),
              PutByte(key: 'key2', value: 127)
            ],
          ),
        ],
      );

  static Bundles get bundleWithByteInvalidUpperBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutByte(key: 'key1', value: -128),
              PutByte(key: 'key2', value: 128)
            ],
          ),
        ],
      );

  static Bundles get bundleWithByteArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutByteArray(key: 'key1', value: [-128, 0, 127]),
              PutByteArray(key: 'key2', value: [127, 0, -128])
            ],
          ),
        ],
      );

  static Bundles get bundleWithChar => Bundles(
        bundles: [
          Bundle(
            value: [
              PutChar(key: 'key1', value: 'a'),
              PutChar(key: 'key2', value: 'b'),
            ],
          ),
        ],
      );

  static Bundles get bundleWithCharInvalidChar => Bundles(
        bundles: [
          Bundle(
            value: [
              PutChar(key: 'key1', value: 'value1'),
              PutChar(key: 'key2', value: 'value2'),
            ],
          ),
        ],
      );

  static Bundles get bundleWithCharArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutCharArray(key: 'key1', value: ['a', 'b', 'c']),
              PutCharArray(key: 'key2', value: ['c', 'b', 'a']),
            ],
          ),
        ],
      );

  static Bundles get bundleWithCharArrayInvalidChar => Bundles(
        bundles: [
          Bundle(
            value: [
              PutCharArray(key: 'key1', value: ['a', 'b', 'c']),
              PutCharArray(key: 'key2', value: ['c', 'b', 'abc']),
            ],
          ),
        ],
      );

  static Bundles get bundleWithCharSequence => Bundles(
        bundles: [
          Bundle(
            value: [
              PutCharSequence(
                key: 'key1',
                value: 'value1',
              ),
              PutCharSequence(
                key: 'key2',
                value: 'value2',
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithCharSequenceArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutCharSequenceArray(
                key: 'key1',
                value: ['value1', 'value2', 'value3'],
              ),
              PutCharSequenceArray(
                key: 'key2',
                value: ['value4', 'value5', 'value6'],
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithCharSequenceArrayList => Bundles(
        bundles: [
          Bundle(
            value: [
              PutCharSequenceArrayList(
                key: 'key1',
                value: ['value1', 'value2', 'value3'],
              ),
              PutCharSequenceArrayList(
                key: 'key2',
                value: ['value4', 'value5', 'value6'],
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithByteArrayInvalidLowerBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutByteArray(key: 'key1', value: [-129, 0, 127]),
              PutByteArray(key: 'key2', value: [127, 0 - 128])
            ],
          ),
        ],
      );

  static Bundles get bundleWithByteArrayInvalidUpperBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutByteArray(key: 'key1', value: [-128, 0, 128]),
              PutByteArray(key: 'key2', value: [127, 0 - 128])
            ],
          ),
        ],
      );

  static Bundles get bundleWithDouble => Bundles(
        bundles: [
          Bundle(
            value: [
              PutDouble(key: 'key1', value: -9.999999e96),
              PutDouble(key: 'key2', value: 1e-101),
              PutDouble(key: 'key3', value: 9.999999e96),
            ],
          ),
        ],
      );

  static Bundles get bundleWithDoubleArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutDoubleArray(
                key: 'key1',
                value: [-9.999999e96, 1e-101, 9.999999e96],
              ),
              PutDoubleArray(
                key: 'key2',
                value: [9.999999e96, 1e-101, -9.999999e96],
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithFloat => Bundles(
        bundles: [
          Bundle(
            value: [
              PutFloat(key: 'key1', value: -3.4028235e+38),
              PutFloat(key: 'key2', value: 1.4e-45),
              PutFloat(key: 'key3', value: 3.4028235e+38),
            ],
          ),
        ],
      );

  static Bundles get bundleWithFloatArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutFloatArray(
                key: 'key1',
                value: [-3.4028235e+38, 1.4e-45, 3.4028235e+38],
              ),
              PutFloatArray(
                key: 'key2',
                value: [3.4028235e+38, 1.4e-45, -3.4028235e+38],
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithInt => Bundles(
        bundles: [
          Bundle(
            value: [
              PutInt(key: 'key1', value: -2147483648),
              PutInt(key: 'key2', value: 2147483647)
            ],
          ),
        ],
      );

  static Bundles get bundleWithIntInvalidLowerBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutInt(key: 'key1', value: -2147483649),
              PutInt(key: 'key2', value: 2147483647)
            ],
          ),
        ],
      );

  static Bundles get bundleWithIntInvalidUpperBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutInt(key: 'key1', value: -2147483648),
              PutInt(key: 'key2', value: 2147483648)
            ],
          ),
        ],
      );

  static Bundles get bundleWithIntArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutIntArray(key: 'key1', value: [-2147483648, 0, 2147483647]),
              PutIntArray(key: 'key2', value: [2147483647, 0, -2147483648]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithIntArrayInvalidLowerBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutIntArray(key: 'key1', value: [-2147483649, 0, 2147483647]),
              PutIntArray(key: 'key2', value: [2147483647, 0, -2147483648]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithIntArrayInvalidUpperBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutIntArray(key: 'key1', value: [-2147483648, 0, 2147483648]),
              PutIntArray(key: 'key2', value: [2147483647, 0, -2147483648]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithIntegerArrayList => Bundles(
        bundles: [
          Bundle(
            value: [
              PutIntegerArrayList(
                  key: 'key1', value: [-2147483648, 0, 2147483647]),
              PutIntegerArrayList(
                  key: 'key2', value: [2147483647, 0, -2147483648]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithIntegerArrayListInvalidLowerBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutIntegerArrayList(
                  key: 'key1', value: [-2147483649, 0, 2147483647]),
              PutIntegerArrayList(
                  key: 'key2', value: [2147483647, 0, -2147483648]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithIntegerArrayListInvalidUpperBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutIntegerArrayList(
                  key: 'key1', value: [-2147483648, 0, 2147483648]),
              PutIntegerArrayList(
                  key: 'key2', value: [2147483647, 0, -2147483648]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithLong => Bundles(
        bundles: [
          Bundle(
            value: [
              PutLong(key: 'key1', value: -9223372036854775808),
              PutLong(key: 'key2', value: 9223372036854775807)
            ],
          ),
        ],
      );

  static Bundles get bundleWithLongArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutLongArray(
                key: 'key1',
                value: [-9223372036854775808, 0, 9223372036854775807],
              ),
              PutLongArray(
                key: 'key2',
                value: [9223372036854775807, 0, -9223372036854775808],
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithParcelable => Bundles(
        bundles: [
          Bundle(
            value: [
              PutParcelable(
                key: 'key1',
                value: Bundle(value: [
                  PutString(key: 'subKey1', value: 'value1'),
                  PutInt(key: 'subKey2', value: 1),
                ]),
              ),
              PutParcelable(
                key: 'key2',
                value: Bundle(value: [
                  PutString(key: 'subKey1', value: 'value2'),
                  PutInt(key: 'subKey2', value: 2),
                ]),
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithParcelableArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutParcelableArray(
                key: 'key1',
                value: [
                  Bundle(value: [
                    PutString(key: 'subKey1', value: 'value1'),
                    PutInt(key: 'subKey2', value: 1),
                  ]),
                  Bundle(value: [
                    PutString(key: 'subKey1', value: 'value2'),
                    PutInt(key: 'subKey2', value: 2),
                  ])
                ],
              ),
              PutParcelableArray(
                key: 'key2',
                value: [
                  Bundle(value: [
                    PutString(key: 'subKey1', value: 'value3'),
                    PutInt(key: 'subKey2', value: 3),
                  ]),
                  Bundle(value: [
                    PutString(key: 'subKey1', value: 'value4'),
                    PutInt(key: 'subKey2', value: 4),
                  ])
                ],
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithParcelableArrayList => Bundles(
        bundles: [
          Bundle(
            value: [
              PutParcelableArrayList(
                key: 'key1',
                value: [
                  Bundle(value: [
                    PutString(key: 'subKey1', value: 'value1'),
                    PutInt(key: 'subKey2', value: 1),
                  ]),
                  Bundle(value: [
                    PutString(key: 'subKey1', value: 'value2'),
                    PutInt(key: 'subKey2', value: 2),
                  ])
                ],
              ),
              PutParcelableArrayList(
                key: 'key2',
                value: [
                  Bundle(value: [
                    PutString(key: 'subKey1', value: 'value3'),
                    PutInt(key: 'subKey2', value: 3),
                  ]),
                  Bundle(value: [
                    PutString(key: 'subKey1', value: 'value4'),
                    PutInt(key: 'subKey2', value: 4),
                  ])
                ],
              ),
            ],
          ),
        ],
      );

  static Bundles get bundleWithShort => Bundles(
        bundles: [
          Bundle(
            value: [
              PutShort(key: 'key1', value: -32768),
              PutShort(key: 'key2', value: 32767)
            ],
          ),
        ],
      );

  static Bundles get bundleWithShortInvalidLowerBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutShort(key: 'key1', value: -32769),
              PutShort(key: 'key2', value: 32767)
            ],
          ),
        ],
      );

  static Bundles get bundleWithShortInvalidUpperBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutShort(key: 'key1', value: -32768),
              PutShort(key: 'key2', value: 32768)
            ],
          ),
        ],
      );

  static Bundles get bundleWithShortArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutShortArray(key: 'key1', value: [-32768, 0, 32767]),
              PutShortArray(key: 'key2', value: [32767, 0, -32768]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithShortArrayInvalidLowerBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutShortArray(key: 'key1', value: [-32769, 0, 32767]),
              PutShortArray(key: 'key2', value: [32767, 0, -32768]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithShortArrayInvalidUpperBound => Bundles(
        bundles: [
          Bundle(
            value: [
              PutShortArray(key: 'key1', value: [-32768, 0, 32768]),
              PutShortArray(key: 'key2', value: [32767, 0, -32768]),
            ],
          ),
        ],
      );

  static Bundles get bundleWithString => Bundles(
        bundles: [
          Bundle(
            value: [
              PutString(key: 'key1', value: "value1"),
              PutString(key: 'key2', value: "value2")
            ],
          ),
        ],
      );

  static Bundles get bundleWithStringArray => Bundles(
        bundles: [
          Bundle(
            value: [
              PutStringArray(
                  key: 'key1', value: ['value1', 'value2', 'value3']),
              PutStringArray(key: 'key2', value: ['value4', 'value5', 'value6'])
            ],
          ),
        ],
      );

  static Bundles get bundleWithStringArrayList => Bundles(
        bundles: [
          Bundle(
            value: [
              PutStringArrayList(
                  key: 'key1', value: ['value1', 'value2', 'value3']),
              PutStringArrayList(
                  key: 'key2', value: ['value4', 'value5', 'value6'])
            ],
          ),
        ],
      );

  static String get bundleWithUnknownPutBaseInBundle => '''
{
  "javaClass": "Bundles",
  "value": [
    {
      "javaClass": "Bundle",
      "value": [
        {
          "key": "key1",
          "javaClass": "PutStringUNKNOWN",
          "value": "value1"
        }
      ]
    }
  ]
}''';

  static String get bundleWithUnknownBundleInParcelable => '''
{
  "javaClass": "Bundles",
  "value": [
    {
      "javaClass": "Bundle",
      "value": [
        {
          "key": "key1",
          "javaClass": "PutParcelable",
          "value": {
            "javaClass": "BundleUNKNOWN",
            "value": []
          }
        }
      ]
    }
  ]
}
''';

  static String get bundleWithUnknownBundleInParcelableArray => '''
{
  "javaClass": "Bundles",
  "value": [
    {
      "javaClass": "Bundle",
      "value": [
        {
          "key": "key1",
          "javaClass": "PutParcelableArray",
          "value": [
            {
              "javaClass": "BundleUNKNOWN",
              "value": []
            }
          ]
        }
      ]
    }
  ]
}
''';

  static String get bundleWithUnknownBundleInParcelableArrayList => '''
{
  "javaClass": "Bundles",
  "value": [
    {
      "javaClass": "Bundle",
      "value": [
        {
          "key": "key1",
          "javaClass": "PutParcelableArrayList",
          "value": [
            {
              "javaClass": "BundleUNKNOWN",
              "value": []
            }
          ]
        }
      ]
    }
  ]
}
''';
}
