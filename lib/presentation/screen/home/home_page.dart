import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lumb/config/colors/app_colors.dart';
import 'package:lumb/presentation/blocs/cubits/bottom_nav_cubit.dart';
import 'package:lumb/presentation/blocs/cubits/scroll_cubit.dart';
import 'package:lumb/presentation/screen/home/views/charts_view.dart';
import 'package:lumb/presentation/screen/home/views/home_view.dart';
import 'package:lumb/presentation/screen/home/views/profile_view.dart';
import 'package:lumb/presentation/screen/home/views/sessions_view.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}
class _MainWrapperState extends State<MainWrapper> {
  late PageController pageController;

  /// Top Level Pages
  final List<Widget> topLevelPages = const [
    HomeView(),
    SessionsView(),
    ChartsView(),
    ProfileView()
  ];

  @override
  void initState() {
    super.initState();
    final initialPage = context.read<BottomNavCubit>().state;
    pageController = PageController(initialPage: initialPage);
  /*   BlocProvider.of<SessionCubit>(context).updateTime(minutes: 0, seconds: 30,);  */
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)  => ScrollCubit()),
      ],
      child:  Scaffold(
        backgroundColor: Colors.white,
        body: _mainWrapperBody(),
        bottomNavigationBar: _mainWrapperBottomNavBar(context),
      ),
    );
  }

  BottomAppBar _mainWrapperBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _bottomAppBarItem(
              context,
              defaultIcon: IconlyLight.home,
              page: 0,
              label: "Home",
              filledIcon: IconlyBold.home,
            ),
            _bottomAppBarItem(
              context,
              defaultIcon: IconlyLight.paper,
              page: 1,
              label: "Sesiones",
              filledIcon: IconlyBold.paper,
            ),
            _bottomAppBarItem(
              context,
              defaultIcon: IconlyLight.graph,
              page: 2,
              label: "Gráficos",
              filledIcon: IconlyBold.graph,
            ),
            _bottomAppBarItem(
              context,
              defaultIcon: IconlyLight.profile,
              page: 3,
              label: "Perfil",
              filledIcon: IconlyBold.profile,
            ),
          ],
        ),
      ),
    );
  }

  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: onPageChanged,
      controller: pageController,
      children: topLevelPages,
    );
  }

  Widget _bottomAppBarItem(
    BuildContext context, {
    required defaultIcon,
    required page,
    required label,
    required filledIcon,
  }) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
        pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              context.watch<BottomNavCubit>().state == page
                  ? filledIcon
                  : defaultIcon,
              color: context.watch<BottomNavCubit>().state == page
                  ? AppColors.primaryColor
                  : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.aBeeZee(
                color: context.watch<BottomNavCubit>().state == page
                    ? AppColors.primaryColor
                    : Colors.grey,
                fontSize: 13,
                fontWeight: context.watch<BottomNavCubit>().state == page
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}