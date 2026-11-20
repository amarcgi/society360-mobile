import 'package:society360_app/features/screen/dashboard/model/society_dashboard_response.dart';



class SocietyDashboardDetailsStore {
  SocietyDashBoardDetails? _details;

  SocietyDashBoardDetails? get details => _details;

  void save(SocietyDashBoardDetails details) {
    _details = details;
  }

  void clear() {
    _details = null;
  }
}