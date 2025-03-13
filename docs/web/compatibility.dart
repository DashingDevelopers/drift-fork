import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:drift/wasm.dart';
import 'package:web/web.dart';

void main() async {
  window.setProperty(
      'start_compat_check'.toJS,
      () {
        Future(() async {
          final btn = document.querySelector('#drift-compat-btn')!;
          final results =
              document.querySelector('#drift-compat-results') as HTMLElement;

          btn.attributes['disabled'] = 'true'.toJS;
          results.innerText = '';

          try {
            final db = await WasmDatabase.open(
              databaseName: 'test_db',
              // These URLs need to be absolute because we're serving this JS file
              // under `/web`.
              sqlite3Uri: Uri.parse('/sqlite3.wasm'),
              driftWorkerUri: Uri.parse('/drift_worker.dart.js'),
            );

            results.innerText += '''
Chosen implementation: ${db.chosenImplementation}
Features missing: ${db.missingFeatures}
''';
            await db.resolvedExecutor.close();
          } catch (e, s) {
            results.innerText += 'Error: $e, Trace: \n$s';
          } finally {
            btn.attributes['disabled'] = 'false'.toJS;
          }
        });
      }.toJS);
}
