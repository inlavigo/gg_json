// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_json/src/gg_json_layer.dart';
import 'package:gg_json_hash/gg_json_hash.dart';

// .............................................................................
/// The data behind GgJson
typedef GgJsonData = Map<String, dynamic>;

// .............................................................................

/// Manages a bunch of data layers
class GgJson {
  /// Constructor
  GgJson({
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
    bool updateHashes = true,
    bool validateHashes = true,
  }) {
    if (validateHashes) {
      JsonHash.validate(layers);
    }

    for (final key in layers.keys) {
      if (key == '_hash') {
        continue;
      }

      if (data.containsKey(key)) {
        throw Exception('Layer with name $key already exists');
      }

      final ggLayer = GgJsonLayer(
        name: key,
        data: layers[key] as GgJsonData,
      );

      data[key] = ggLayer.data;
    }

    if (updateHashes) {
      this.updateHashes(recursive: false);
    }
  }

  // ...........................................................................
  /// Updates the hash
  void updateHashes({bool recursive = false}) {
    addHashes(data, inPlace: true, recursive: recursive);
  }

  // ...........................................................................
  /// Returns the json hash of the data
  String get hash => data['_hash']! as String;

  // ...........................................................................
  /// Throws when data is not valid
  void validate() {
    JsonHash.validate(data);
  }

  // ...........................................................................
  /// Example instance of GgJson
  factory GgJson.example() => GgJson(
        layers: addHashes(
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
    JsonHash.validate(data);
  }
}
