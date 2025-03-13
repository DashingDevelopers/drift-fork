// dart format width=80
// ignore_for_file: type=lint
import 'package:drift/drift.dart' as i0;
import 'package:drift/internal/modular.dart' as i1;
import 'package:shared/src/posts.drift.dart' as i2;

class SharedDrift extends i1.ModularAccessor {
  SharedDrift(i0.GeneratedDatabase db) : super(db);
  i2.PostsDrift get postsDrift => this.accessor(i2.PostsDrift.new);
}
