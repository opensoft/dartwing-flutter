import 'station_slot_info.dart';

class DeviceSlotsResponse {
  const DeviceSlotsResponse({
    required this.slotCount,
    required this.currentFocusedSlotNumber,
    required this.currentAngleDegrees,
    required this.slots,
  });

  final int slotCount;
  final int? currentFocusedSlotNumber;
  final double? currentAngleDegrees;
  final List<StationSlotInfo> slots;
}
