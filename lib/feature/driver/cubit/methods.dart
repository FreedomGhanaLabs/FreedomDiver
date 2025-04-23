import 'package:freedom_driver/feature/driver/cubit/driver_state.dart';
import 'package:freedom_driver/feature/driver/driver.model.dart';

void emitIfChanged(
  Driver? cachedDriver,
  Driver updated,
  void Function(DriverState state) emit,
) {
  if (cachedDriver != updated) {
   final cachedDriver0 = updated;
    emit(DriverLoaded(cachedDriver0));
  }
}
