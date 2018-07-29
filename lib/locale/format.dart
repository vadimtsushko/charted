/*
 * Copyright 2014 Google Inc. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file or at
 * https://developers.google.com/open-source/licenses/bsd
 */

library charted.locale.format;

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:charted/locale/locale.dart';
import 'package:charted/core/utils.dart';

part 'format/number_format.dart';
part 'format/time_format.dart';

typedef String NumberFormatFunction(num x, [int precision]);

/**
 * Returns a new format function with the given string specifier.
 * The format specifier is modeled after Python 3.1's built-in format
 * specification mini-language.
 *
 * The general form of a specifier is:
 * [​[fill]align][sign][symbol][0][width][,][.precision][type]
 *
 * @see <a href="http://docs.python.org/release/3.1.3/library/string.html#formatspec">Python format specification mini-language</a>
 */
FormatFunction format(String specifier, [Locale locale]) {
  locale ??= new EnUsLocale();
  return locale.numberFormat.format(specifier);
}

/*
 * Class for computing the SI format prefix for the given value.
 */
class FormatPrefix {
  // SI scale units in increments of 1000.
  static const List<String> _unitPrefixes = const [
    "y",
    "z",
    "a",
    "f",
    "p",
    "n",
    "µ",
    "m",
    "",
    "k",
    "M",
    "G",
    "T",
    "P",
    "E",
    "Z",
    "Y"
  ];

  num Function(num) _scale;
  String _symbol;

  FormatPrefix(num value, [int precision = 0]) {
    var i = 0;
    if (value < 0) {
      value *= -1;
    }
    if (precision > 0) {
      value = _roundToPrecision(value, _formatPrecision(value, precision));
    }

    // Determining SI scale of the value in increment of 1000.
    i = 1 + (1e-12 + math.log(value) / math.ln10).floor();
    i = math.max(-24, math.min(24, ((i - 1) / 3).floor() * 3));
    i = 8 + (i / 3).floor();

    // Sets the scale and symbol of the value.
    var k = math.pow(10, (8 - i).abs() * 3);
    _scale = i > 8 ? (d) => d / k : (d) => d * k;
    _symbol = _unitPrefixes[i];
  }

  num _formatPrecision(num x, num p) {
    return p - (x != 0 ? (math.log(x) / math.ln10).ceil() : 1);
  }

  /** Returns the value of x rounded to the nth digit. */
  num _roundToPrecision(num x, num n) {
    return n != 0 ? (x * (n = math.pow(10, n))).round() / n : x.round();
  }

  /** Returns the SI prefix for the value. */
  String get symbol => _symbol;

  /** Returns the scale for the value corresponding to the SI prefix. */
  num Function(num) get scale => _scale;
}
