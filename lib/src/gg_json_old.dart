// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_json_hash/gg_json_hash.dart' as jh;

// .............................................................................
/// The data behind GgJson
typedef GgJsonData = Map<String, dynamic>;

// .............................................................................

/// Manages a bunch of data layers
class GgJsonOld {
  /// Constructor
  GgJsonOld({
    GgJsonData layers = const {
      '_hash': 'RBNvo1WzZ4oRRq0W9+hknp',
    },
    bool validateHashes = true,
  }) {
    addLayers(layers, validateHashes: validateHashes);
    _validateHashes(validateHashes);
  }

  /// The layers of the json
  final GgJsonData data = {};

  // ...........................................................................
  /// Some test method
  void addLayers(
    GgJsonData layers, {
    bool addHashes = true,
    bool validateHashes = true,
  }) {
    if (addHashes) {
      layers = jh.addHashes(layers);
    } else if (validateHashes) {
      jh.JsonHash.validate(layers);
    }

    for (final key in layers.keys) {
      if (key == '_hash') {
        continue;
      }

      if (data.containsKey(key)) {
        throw Exception('Layer with name $key already exists');
      }

      final ggLayer = _GgJsonLayer(
        name: key,
        data: layers[key] as GgJsonData,
      );

      data[key] = ggLayer.data;
    }

    updateHashes(recursive: false);
  }

  // ...........................................................................
  /// Updates the hash
  void updateHashes({bool recursive = false}) {
    jh.addHashes(data, inPlace: true, recursive: recursive);
  }

  // ...........................................................................
  /// Returns the json hash of the data
  String get hash => data['_hash']! as String;

  // ...........................................................................
  /// Throws when data is not valid
  void validate() {
    jh.JsonHash.validate(data);
  }

  // ...........................................................................
  /// Example instance of GgJson
  factory GgJsonOld.example() => GgJsonOld(
        layers: jh.addHashes(
          {
            '@layerA': {
              '3c6tvJzmSXR9CCFF2HpkXf': {
                'keyA': 'valueA',
                '_hash': '3c6tvJzmSXR9CCFF2HpkXf',
              },
              '_hash': 'P4p3GYqqSOS2uSdp3z1/6W',
            },
            '@layerB': {
              'c9Pss1Pdj9txvVN5Ggy42a': {
                'keyB': 'valueB',
                '@layerA': 'hashA',
                '_hash': 'c9Pss1Pdj9txvVN5Ggy42a',
              },
              '_hash': 'x9mnRn7AQWHzFhairVsqmo',
            },
            '_hash': 'LdaiVyanVuCYH53+zrj5bP',
          },
        ),
      );

  // ######################
  // Private
  // ######################

  // ...........................................................................
  void _validateHashes(bool validateHashes) {
    if (!validateHashes) return;
    jh.JsonHash.validate(data);
  }
}

// #############################################################################

// .............................................................................
/// A layer of a GgJson
class _GgJsonLayer {
  /// Constructor
  _GgJsonLayer({required this.name, this.data = const {}}) {
    _checkName();
    _checkData();
  }

  // ...........................................................................
  /// The data of the layer
  final GgJsonData data;

  // ...........................................................................
  /// Returns the name of the layer
  final String name;

  /// Returns the data item with the given hash
  String get hash {
    updateHash();
    return data['_hash']! as String;
  }

  // ...........................................................................
  /// Updates the hash
  void updateHash() {
    if (_hashIsValid) return;
    jh.addHashes(data, inPlace: true, recursive: false);
    _hashIsValid = true;
  }

  // ...........................................................................
  @override
  int get hashCode => hash.hashCode;

  // ...........................................................................
  @override
  bool operator ==(Object other) {
    if (other is _GgJsonLayer) {
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
  void _checkData() {
    for (final key in data.keys) {
      if (key == '_hash') continue;

      final value = data[key] as dynamic;
      if (value is! Map<String, dynamic>) {
        throw Exception(
          'Layer "$name": '
          'The value of the key "$key" must be a map.',
        );
      }

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
