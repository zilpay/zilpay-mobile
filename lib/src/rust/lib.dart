// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.6.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import 'frb_generated.dart';
import 'package:collection/collection.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class U8Array32 extends NonGrowableListView<int> {
  static const arraySize = 32;

  @internal
  Uint8List get inner => _inner;
  final Uint8List _inner;

  U8Array32(this._inner)
      : assert(_inner.length == arraySize),
        super(_inner);

  U8Array32.init() : this(Uint8List(arraySize));
}
