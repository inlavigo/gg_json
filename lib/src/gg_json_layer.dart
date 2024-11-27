// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_json/gg_json.dart';
import 'package:gg_json_hash/gg_json_hash.dart';

// .............................................................................
/// A layer of a GgJson
class GgJsonLayer {
  /// Constructor
  GgJsonLayer({required this.name, this.data = const {}}) {
    _checkName();
    _checkDataKeys();
  }

  // ...........................................................................
  /// The data of the layer
  final GgJsonData data;

  // ...........................................................................
  /// Returns the name of the layer
  final String name;

  // ...........................................................................
  /// Adds a new data item to the layer
  void addItem(GgJsonItem item) {
    data[item.hash] = item.data;
    _hashIsValid = false;
  }

  /// Returns the data item with the given hash
  String get hash {
    updateHash();
    return data['_hash']! as String;
  }

  // ...........................................................................
  /// Updates the hash
  void updateHash() {
    if (_hashIsValid) return;
    addHashes(data, inPlace: true, recursive: false);
    _hashIsValid = true;
  }

  // ...........................................................................
  @override
  int get hashCode => hash.hashCode;

  // ...........................................................................
  @override
  bool operator ==(Object other) {
    if (other is GgJsonLayer) {
      return hash == other.hash;
    }
    return false;
  }

  // ######################
  // Private
  // ######################

  bool _hashIsValid = false;

  // ...........................................................................
  void _checkName() {
    if (name.isEmpty) {
      throw ArgumentError('The name of a GgJsonLayer must not be empty.');
    }

    if (!name.startsWith('@')) {
      throw Exception(
        'The name "$name" of a layer must start with an "@".',
      );
    }
  }

  // ...........................................................................
  void _checkDataKeys() {
    for (final key in data.keys) {
      if (key == '_hash') continue;

      final value = data[key] as dynamic;
      final valueHash = value['_hash'];
      if (valueHash != key) {
        throw Exception(
          'Layer "$name": '
          'The item key "$key" does not match the hash "$hash" of the value.',
        );
      }
    }
  }
}
