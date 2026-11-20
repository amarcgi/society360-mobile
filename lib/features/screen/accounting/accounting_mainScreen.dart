// --- MAIN SCREEN ---
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society360_app/features/screen/accounting/statement_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../core/shared/widgets/app_bar.dart';
import '../../../core/shared/widgets/app_text_styles.dart';
import '../../../injection.dart';
import '../dashboard/model/society_dashboard_details_store.dart';
import 'bloc/accounting_bloc.dart';
import 'bloc/accounting_event.dart';
import 'dues_screen.dart';
import 'society_ledger.dart';

class AccountingMainScreen extends StatefulWidget {
  //final Map<String, dynamic> dashboardData;

  const AccountingMainScreen({
    super.key,
    //this.dashboardData = const {},
  });

  @override
  State<AccountingMainScreen> createState() => _AccountingMainScreenState();
}

class _AccountingMainScreenState extends State<AccountingMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AccountingBloc _accountingBloc;
  //final details = sl<SocietyDashboardDetailsStore>().details;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _accountingBloc = sl<AccountingBloc>();

    final details = sl<SocietyDashboardDetailsStore>().details;
    if (details != null) {
      _accountingBloc.add(
        LoadAccounting(
          flatId: details.flatId.toString(),
          societyId: details.societyId,
          buildingId: details.buildingId.toString(),
          mobileNo: details.registeredMobileNo,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _accountingBloc.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _accountingBloc,
      child: Scaffold(
        appBar: CustomAppBars.customAppBar(
          //backgroundColor: const Color(0xFF0D2C54),
          title:'Accounting',
          context: context,
          bottom: TabBar(controller: _tabController,
                labelColor: Colors.white,
                //isScrollable: true,
                unselectedLabelColor: Colors.white60,
                indicatorColor: const Color(0xFF00C2CB),
                tabs: const [Tab(text: "Dues"), Tab(text: "Statement"), Tab(text: "Society Ledger")],
                labelStyle: TextStyle(color: Colors.white, fontSize: 18))
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DuesScreen(accountingBloc: _accountingBloc),
             StatementScreen(accountingBloc: _accountingBloc),
             ExpensesScreen(accountingBloc: _accountingBloc),
          ],
        ),
      ),
    );
  }
}