// @license
// Copyright (c) 2019 - 2024 Dr. Gabriel Gatzsche. All Rights Reserved.
//
// Use of this source code is governed by terms that can be
// found in the LICENSE file in the root of this package.

import 'package:gg_json/gg_json.dart';
import 'package:test/test.dart';

void main() {
  group('GgJson', () {
    final ggJson = GgJson.example;

    group('ls()', () {
      test('lists the pathes of all items', () {
        expect(ggJson.ls(), [
          '@layerA/KFQrf4mEz0UPmUaFHwH4T6/keyA0',
          '@layerA/YPw-pxhqaUOWRFGramr4B1/keyA1',
          '@layerB/nmejjLAUhygiT6WFDPPsHy/keyB0',
          '@layerB/dXhIygNwNMVPEqFbsFJkn6/keyB1',
        ]);
      });
    });

    group('fromData(data)', () {
      test('adds hashes to all fields', () {
        final a0 = ggJson.item('@layerA/KFQrf4mEz0UPmUaFHwH4T6/_hash');
        final a1 = ggJson.item('@layerA/YPw-pxhqaUOWRFGramr4B1/_hash');

        expect(a0, 'KFQrf4mEz0UPmUaFHwH4T6');
        expect(a1, 'YPw-pxhqaUOWRFGramr4B1');
      });
    });

    group('query(layer, query)', () {
      test('returns the items that match the query', () {
        final items = ggJson.query(
          layer: '@layerA',
          query: {'keyA0': 'a0'},
        );

        expect(items, [
          {'keyA0': 'a0', '_hash': 'KFQrf4mEz0UPmUaFHwH4T6'},
        ]);
      });

      group('throws', () {
        test('when layer does not exist', () {
          late final Exception exception;

          try {
            ggJson.query(
              layer: '@layerC',
              query: {'keyA0': 'a0'},
            );
          } catch (e) {
            exception = e as Exception;
          }

          expect(exception.toString(), 'Exception: Layer not found: @layerC');
        });
      });
    });

    group('addData(data)', () {
      group('throws', () {
        test('when layer names do not start with @', () {
          late final Exception exception;

          try {
            ggJson.addData({
              'layerA': {'_data': <dynamic>[]},
              'layerB': {'_data': <dynamic>[]},
              'layerC': {'_data': <dynamic>[]},
            });
          } catch (e) {
            exception = e as Exception;
          }

          expect(
            exception.toString(),
            'Exception: Layer name must start with @: layerA',
          );
        });

        test('when layers do not contain a _data object', () {
          late final Exception exception;

          try {
            ggJson.addData({
              '@layerA': <String, dynamic>{},
              '@layerB': <String, dynamic>{},
            });
          } catch (e) {
            exception = e as Exception;
          }

          expect(
            exception.toString(),
            'Exception: _data is missing in layer: @layerA, @layerB',
          );
        });

        test('when layers do not contain a _data that is not a list', () {
          late final Exception exception;

          try {
            ggJson.addData({
              '@layerA': <String, dynamic>{
                '_data': <dynamic>{},
              },
              '@layerB': <String, dynamic>{
                '_data': <dynamic>{},
              },
            });
          } catch (e) {
            exception = e as Exception;
          }

          expect(
            exception.toString(),
            'Exception: _data must be a list in layer: @layerA, @layerB',
          );
        });
      });

      test('adds data to the json', () {
        final ggJson2 = ggJson.addData({
          '@layerA': {
            '_data': [
              {'keyA2': 'a2'},
            ],
          },
        });

        final items = ggJson2.data['@layerA']['_data'] as List<dynamic>;
        expect(items, [
          {'keyA0': 'a0', '_hash': 'KFQrf4mEz0UPmUaFHwH4T6'},
          {'keyA1': 'a1', '_hash': 'YPw-pxhqaUOWRFGramr4B1'},
          {'keyA2': 'a2', '_hash': 'apLP3I2XLnVm13umIZdVhV'},
        ]);
      });

      test('does not cause duplicates', () {
        final ggJson2 = ggJson.addData({
          '@layerA': {
            '_data': [
              {'keyA1': 'a1'},
            ],
          },
        });

        final items = ggJson2.data['@layerA']['_data'] as List<dynamic>;
        expect(items, [
          {'keyA0': 'a0', '_hash': 'KFQrf4mEz0UPmUaFHwH4T6'},
          {'keyA1': 'a1', '_hash': 'YPw-pxhqaUOWRFGramr4B1'},
        ]);
      });
    });

    group('item(path)', () {
      test('returns the item at the path', () {
        final item = ggJson.item('@layerA/KFQrf4mEz0UPmUaFHwH4T6/keyA0');
        expect(item, 'a0');
      });

      group('throws', () {
        test('when layer is not found', () {
          late final Exception exception;

          try {
            ggJson.item('@layerC/KFQrf4mEz0UPmUaFHwH4T6/keyA0');
          } catch (e) {
            exception = e as Exception;
          }

          expect(exception.toString(), 'Exception: Layer not found: @layerC');
        });

        test('when hash is not found', () {
          late final Exception exception;

          try {
            ggJson.item('@layerA/348902384/keyA2');
          } catch (e) {
            exception = e as Exception;
          }

          expect(
            exception.toString(),
            'Exception: Item with hash "348902384" not found.',
          );
        });
      });
    });

    group('checkLinks()', () {
      test('throws when a link is broken', () {});
    });
  });
}
