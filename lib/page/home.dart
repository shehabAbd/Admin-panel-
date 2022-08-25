import 'package:admin_panal/page/add_ads.dart';
import 'package:admin_panal/page/manage_ads.dart';
import 'package:admin_panal/page/manage_users.dart';
import 'package:admin_panal/page/feedback.dart';
import 'package:admin_panal/page/manage_admin.dart';
import 'package:admin_panal/page/manage_products.dart';
import 'package:admin_panal/page/manage_creatives.dart';
import 'package:admin_panal/page/notifications.dart';
import 'package:admin_panal/page/reports.dart';
import 'package:admin_panal/page/signup.dart';
import 'package:admin_panal/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.id}) : super(key: key);

  final String? id;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController page = PageController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("لوحة التحكم"),
          centerTitle: true,
          backgroundColor: AppColors.blue,
        ),
        body:
    FirebaseAuth.instance.currentUser!.uid.toString()=='57aT40fGJEc1y5UMr0qBigxIii12' ?
        
         Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              controller: page,
              // onDisplayModeChanged: (mode) {
              //   print(mode);
              // },
              style: SideMenuStyle(
                displayMode: SideMenuDisplayMode.auto,
                hoverColor: AppColors.grayshade,
                selectedColor: AppColors.blue,
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: Colors.white,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                // ),
                // backgroundColor: Colors.blueGrey[700]
              ),
              title: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                      maxWidth: 150,
                    ),
                    child: const Text(" "),
                    // Image.asset(
                    //   '/imaes/logo.png',
                    // ),
                  ),
                  const Divider(
                    indent: 8.0,
                    endIndent: 8.0,
                  ),
                ],
              ),
              footer: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Copy Right 2022',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              items: [

                SideMenuItem(
                  priority: 0,
                  title: 'إدارة الحرفيين',
                  onTap: () {
                    page.jumpToPage(0);
                  },
                  icon: const Icon(Icons.home),
                ),
                SideMenuItem(
                  priority: 1,
                  title: 'إدارة المستخدمين',
                  onTap: () {
                    page.jumpToPage(1);
                  },
                  icon: const Icon(Icons.supervisor_account),
                ),
                SideMenuItem(
                  priority: 2,
                  title: 'إدارة الحرف',
                  onTap: () {
                    page.jumpToPage(2);
                  },
                  icon: const Icon(Icons.file_copy_rounded),
                ),
                SideMenuItem(
                  priority: 3,
                  title: 'إدارة الإعلانات',
                  onTap: () {
                    page.jumpToPage(3);
                  },
                  icon: const Icon(Icons.ads_click),
                ),
                SideMenuItem(
                  priority: 4,
                  title: 'إضافة إعلانات',
                  onTap: () {
                    page.jumpToPage(4);
                  },
                  icon: const Icon(Icons.ads_click),
                ),
                SideMenuItem(
                  priority: 5,
                  title: 'التقارير',
                  onTap: () {
                    page.jumpToPage(5);
                  },
                  icon: const Icon(Icons.report),
                ),
                SideMenuItem(
                  priority: 6,
                  title: 'إنشاء حساب مدير',
                  onTap: () {
                    page.jumpToPage(6);
                  },
                  icon: const Icon(Icons.create),
                ),
                SideMenuItem(
                  priority: 7,
                  title: 'إدارة المدراء',
                  onTap: () {
                    page.jumpToPage(7);
                  },
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                ),
                SideMenuItem(
                  priority: 8,
                  title: 'الإشعارات',
                  onTap: () {
                    page.jumpToPage(8);
                  },
                  icon: const Icon(Icons.notifications),
                ),
                SideMenuItem(
                  priority: 9,
                  title: 'الشكاوي',
                  onTap: () {
                    page.jumpToPage(9);
                  },
                  icon: const Icon(Icons.feedback),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: page,
                children: const [
                  Manage_CreativeScreen(),
                  Manage_UserScreen(),
                  Manage_ProductsScreen(),
                  Manage_AdsScreen(),
                  Add_Ads_Screen(),
                  ReportsScreen(),
                  SignUpAdminScreen(),
                  AdminScreen(),
                  NotificationScreen(),
                  FeedBackScreen(),
                ],
              ),
            ),
          ],
        ):  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              controller: page,
              // onDisplayModeChanged: (mode) {
              //   print(mode);
              // },
              style: SideMenuStyle(
                displayMode: SideMenuDisplayMode.auto,
                hoverColor: AppColors.grayshade,
                selectedColor: AppColors.blue,
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: Colors.white,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.all(Radius.circular(10)),
                // ),
                // backgroundColor: Colors.blueGrey[700]
              ),
              title: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                      maxWidth: 150,
                    ),
                    child: const Text(" "),
                    // Image.asset(
                    //   '/imaes/logo.png',
                    // ),
                  ),
                  const Divider(
                    indent: 8.0,
                    endIndent: 8.0,
                  ),
                ],
              ),
              footer: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Copy Right 2022',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              items: [

                SideMenuItem(
                  priority: 0,
                  title: 'إدارة الحرفيين',
                  onTap: () {
                    page.jumpToPage(0);
                  },
                  icon: const Icon(Icons.home),
                ),
                SideMenuItem(
                  priority: 1,
                  title: 'إدارة المستخدمين',
                  onTap: () {
                    page.jumpToPage(1);
                  },
                  icon: const Icon(Icons.supervisor_account),
                ),
                SideMenuItem(
                  priority: 2,
                  title: 'إدارة الحرف',
                  onTap: () {
                    page.jumpToPage(2);
                  },
                  icon: const Icon(Icons.file_copy_rounded),
                ),
                SideMenuItem(
                  priority: 3,
                  title: 'إدارة الإعلانات',
                  onTap: () {
                    page.jumpToPage(3);
                  },
                  icon: const Icon(Icons.ads_click),
                ),
                SideMenuItem(
                  priority: 4,
                  title: 'إضافة إعلانات',
                  onTap: () {
                    page.jumpToPage(4);
                  },
                  icon: const Icon(Icons.ads_click),
                ),
                SideMenuItem(
                  priority:5,
                  title: 'التقارير',
                  onTap: () {
                    page.jumpToPage(5);
                  },
                  icon: const Icon(Icons.report),
                ),
                SideMenuItem(
                  priority: 6,
                  title: 'إنشاء حساب مدير',
                  onTap: () {
                    page.jumpToPage(6);
                  },
                  icon: const Icon(Icons.create),
                ),
                // SideMenuItem(
                //   priority: 6,
                //   title: 'إدارة المدراء',
                //   onTap: () {
                //     page.jumpToPage(6);
                //   },
                //   icon: const Icon(Icons.admin_panel_settings_outlined),
                // ),
                SideMenuItem(
                  priority: 7,
                  title: 'الإشعارات',
                  onTap: () {
                    page.jumpToPage(7);
                  },
                  icon: const Icon(Icons.notifications),
                ),
                SideMenuItem(
                  priority: 8,
                  title: 'الشكاوي',
                  onTap: () {
                    page.jumpToPage(8);
                  },
                  icon: const Icon(Icons.feedback),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: page,
                children: const [
                  Manage_CreativeScreen(),
                  Manage_UserScreen(),
                  Manage_ProductsScreen(),
                  Manage_AdsScreen(),
                  Add_Ads_Screen(),
                  ReportsScreen(),
                  SignUpAdminScreen(),
                  // AdminScreen(),
                  NotificationScreen(),
                  FeedBackScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
