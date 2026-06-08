// --- MAIN SCREEN ---
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:society360_app/features/screen/accounting/statement_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../core/shared/widgets/app_text_styles.dart';
import 'bloc/accounting_bloc.dart';
import 'bloc/accounting_event.dart';
import 'dues_screen.dart';
import 'society_ledger.dart';

class AccountingMainScreen extends StatefulWidget {
  const AccountingMainScreen({super.key});
  @override
  State<AccountingMainScreen> createState() => _AccountingMainScreenState();
}

class _AccountingMainScreenState extends State<AccountingMainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountingBloc()..add(LoadAccounting()),
      child: Scaffold(
        //backgroundColor: const Color(0xFFF9F9F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D2C54),
          title: const Text('Accounting', style: TextStyle(color: Colors.white, fontSize: 18)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(controller: _tabController,
              labelColor: Colors.white,
              //isScrollable: true,
              unselectedLabelColor: Colors.white60,
              indicatorColor: const Color(0xFF00C2CB),
              tabs: const [Tab(text: "Dues"), Tab(text: "Statement"), Tab(text: "Society Ledger")],
              labelStyle: TextStyle(color: Colors.white, fontSize: 18))
        ),
        body: TabBarView(controller: _tabController, children: const [DuesScreen(), StatementScreen(), ExpensesScreen()]),
      ),
    );
  }
}