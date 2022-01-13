import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/extensions/context_extension.dart';
import 'package:qchat/core/extensions/string_extension.dart';
import 'package:qchat/core/init/services/helper_service.dart';
import 'package:qchat/view/home/chat/chat_list_page.dart';
import 'package:qchat/view/home/discover/discover_page.dart';
import 'package:qchat/view/home/people/people_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selected = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
          height: context.height,
          width: context.width,
          child: _selected == 0
              ? const ChatListPage()
              : _selected == 1
                  ? const PeoplePage()
                  : const DiscoverPage()),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          HelperService.boxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.25),
              blur: 2,
              spread: 0,
              x: 0,
              y: 0)
        ]),
        child: BottomNavigationBar(
          backgroundColor: AppColors.white,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          elevation: 0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "chat_tab".toSVG,
                  color: _selected == 0 ? AppColors.primary : null,
                ),
                label: ''

                // backgroundColor: AppColors.cream,
                ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "people_tab".toSVG,
                  color: _selected == 1 ? AppColors.primary : null,
                ),
                label: ''

                // backgroundColor: Colors.white,
                ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "discover_tab".toSVG,
                  color: _selected == 2 ? AppColors.primary : null,
                ),
                label: ''

                // backgroundColor: Colors.green,
                ),
          ],
          currentIndex: _selected,
          selectedItemColor: AppColors.secondary,
          onTap: (val) {
            setState(() {
              _selected = val;
            });
          },
        ),
      ),
    );
  }
}
