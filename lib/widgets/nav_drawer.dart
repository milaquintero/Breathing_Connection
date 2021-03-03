import 'package:flutter/material.dart';
import 'package:breathing_connection/widgets/nav_link.dart';
class NavDrawer extends StatelessWidget {
  final String headerImg;
  final List<NavLink> navLinks;
  NavDrawer({this.headerImg, this.navLinks});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
          itemCount: navLinks.length == 0 ? 1 : navLinks.length + 1,
          itemBuilder: (context, index){
            if(index == 0){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Image(
                  image: AssetImage(this.headerImg),
                ),
              );
            }
            index -= 1;
            return ListTile(
              leading: Icon(navLinks[index].icon),
              title: Text(navLinks[index].title),
              onTap: (){
                Navigator.pushNamed(context, navLinks[index].route);
              },
            );
          },
      ),
    );
  }
}
