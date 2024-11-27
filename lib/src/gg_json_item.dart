// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_json/src/gg_json.dart';
import 'package:gg_json_hash/gg_json_hash.dart';

// .............................................................................
/// A data item of a GgJsonLayer
class GgJsonItem {
  /// Constructor
  GgJsonItem({
    required Map<String, dynamic> data,
  }) : data = addHashes(data);

  /// The json data of the item
  final GgJsonData data;

  /// Returns a new data item with changed data
  GgJsonItem copyAndMergeData(
    Map<String, dynamic> data,
  ) {
    return GgJsonItem(
      data: {...data, ...data},
    );
  }

  /// Returns the json hash of the item
  String get hash => data['_hash']! as String;

  /// Returns the hashcode of the item
  @override
  int get hashCode => data['_hash']!.hashCode;

  /// Compares the item with another item
  @override
  bool operator ==(Object other) {
    if (other is GgJsonItem) {
      return data.hashCode == other.data.hashCode;
    }
    return false;
  }
}
