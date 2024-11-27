// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_json/gg_json.dart';
import 'package:test/test.dart';

void main() {
  group('GgJson', () {
    group('example', () {
      test('returns a fine example', () {
        final ggJson = GgJson.example();
        expect(ggJson.data, {
          '@layerA': {
            '3c6tvJzmSXR9CCFF2HpkXf': {
              'keyA': 'valueA',
              '_hash': '3c6tvJzmSXR9CCFF2HpkXf',
            },
            '_hash': 'R8Y5uWj0i2mGfrwXIlFR6d',
          },
          '@layerB': {
            'c9Pss1Pdj9txvVN5Ggy42a': {
              'keyB': 'valueB',
              '@layerA': 'hashA',
              '_hash': 'c9Pss1Pdj9txvVN5Ggy42a',
            },
            '_hash': 'X3Rb2XVflRiySADE946mJl',
          },
          '_hash': '2SZ7uH3EnC2VfYvAGBbIpN',
        });
      });
    });
    group('GgJson(data, validateHashes)', () {
      group('with validateHashes', () {
        group('true', () {
          test('should throw when hashes are not correct', () {
            final json = <String, dynamic>{};
            late String message;
            try {
              GgJson(layers: json, validateHashes: true);
            } catch (e) {
              message = e.toString();
            }

            expect(message, 'Exception: Hash is missing.');
          });
        });
        group('false', () {
          test('should not throw when hashes are not correct', () {
            final json = <String, dynamic>{};
            final ggJson = GgJson(layers: json, validateHashes: false);

            expect(ggJson, isNotNull);
          });
        });
      });
    });

    group('addLayers(jsonData)', () {
      group('throws', () {
        test('when the layer already exists', () {
          final ggJson = GgJson.example();
          late String message;

          try {
            ggJson.addLayers({
              '@layerA': {'keyA': 'valueA'},
            });
          } catch (e) {
            message = e.toString();
          }

          expect(message, 'Exception: Layer with name @layerA already exists');
        });

        test('when a layer name does not start with @', () {
          final ggJson = GgJson.example();
          late String message;

          try {
            ggJson.addLayers({
              'layerC': {'keyA': 'valueA'},
            });
          } catch (e) {
            message = e.toString();
          }

          expect(
            message,
            'Exception: The name "layerC" of a layer must start with an "@".',
          );
        });
      });

      group('adds the layers', () {
        test('and updates the hashes', () {
          final ggJson = GgJson.example();
          ggJson.addLayers({
            '@layerC': {'keyC': 'valueC'},
          });

          expect(ggJson.data['@layerA'], isNotNull);
          expect(ggJson.data['@layerB'], isNotNull);
          expect(ggJson.data['@layerC'], isNotNull);
          expect(ggJson.data['@layerC']!['keyC'], 'valueC');

          ggJson.validate();

          expect(ggJson.data, {
            '@layerA': {
              'hashA': {'keyA': 'valueA', '_hash': '3c6tvJzmSXR9CCFF2HpkXf'},
              '_hash': 'P4p3GYqqSOS2uSdp3z1/6W',
            },
            '@layerB': {
              'hashB': {
                'keyB': 'valueB',
                '@layerA': 'hashA',
                '_hash': 'c9Pss1Pdj9txvVN5Ggy42a',
              },
              '_hash': 'x9mnRn7AQWHzFhairVsqmo',
            },
            '_hash': '8lSWUn/eIXSenjTV2T5vLV',
            '@layerC': {'keyC': 'valueC', '_hash': 'uzBHrzkjg4aZsER4tYoQnU'},
          });
        });
      });
    });
  });
}
