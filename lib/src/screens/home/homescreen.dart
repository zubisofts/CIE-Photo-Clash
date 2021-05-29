import 'package:cie_photo_clash/src/repository/auth_repository.dart';
import 'package:cie_photo_clash/src/screens/home/widgets/fab_bottom_bar.dart';
import 'package:cie_photo_clash/src/screens/timeline/timeline_screen.dart';
import 'package:cie_photo_clash/src/screens/upload/upload_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late int activePage;
  List pages = [
    TimelineScreen(),
    Container(),
  ];

  List<String> titles = ['Timeline', 'Gallery'];

  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey fabKey = GlobalKey();

  @override
  void initState() {
    activePage = 0;
    super.initState();
  }

  void _selectedTab(int index) {
    setState(() {
      activePage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).appBarTheme.systemOverlayStyle!);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        title: Image.asset(
          'assets/images/cie_logo.png',
          width: 40.0,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthenticationRepository().logOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      // key: scaffoldKey,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Upload Picture',
          heroTag: 'upload',
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add_a_photo_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UploadScreen(),
            ));
          }),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: '',
        color: Colors.grey,
        selectedColor: Theme.of(context).colorScheme.secondary,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home_outlined, text: 'Home'),
          // FABBottomAppBarItem(
          //     iconData: Icons.analytics_outlined, text: 'Investments'),
          // FABBottomAppBarItem(iconData: Icons.payment_outlined, text: 'Wallet'),
          FABBottomAppBarItem(
              iconData: Icons.history_toggle_off, text: 'Archive'),
        ],
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
      ),
      body: Container(
        child: pages[activePage],
      ),
      // floatingActionButton: activePage == 1
      //     ? FloatingActionButton.extended(
      //         key: fabKey,
      //         onPressed: () {
      //           Navigator.of(context).push(PageTransition(
      //               child: InvestmentSelectionScreen(),
      //               type: PageTransitionType.bottomToTop));
      //         },
      //         label: Text(
      //           'Invest',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //         icon: Icon(
      //           Icons.add,
      //           color: Colors.white,
      //         ),
      //       )
      //     : SizedBox.shrink(),
    );
  }
}
