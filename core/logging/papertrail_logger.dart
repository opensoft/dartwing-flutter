import '../../network/paper_trail.dart';
import 'i_logger.dart';

class PaperTrailLogger implements ILogger {
  @override
  void info(String message) {
    PaperTrailClient.sendInfoMessageToPaperTrail(message);
  }

  @override
  void warning(String message) {
    PaperTrailClient.sendWarningMessageToPaperTrail(message);
  }

  @override
  void critical(String message) {
    PaperTrailClient.sendCriticalErrorMessageToPaperTrail(message);
  }
}
