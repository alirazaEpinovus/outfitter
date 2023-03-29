import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:outfitters/UI/Notifiers/CartNotifier.dart';
import 'package:outfitters/UI/Screens/ShoppingBag.dart';
import 'package:provider/provider.dart';

class CartIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShoppingBag(),
                    settings: RouteSettings(name: 'Shopping Bag')));
          },
          child: Consumer(
              builder: (BuildContext context, CartNotifier cartNotifier, _) {
            return Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 50,
                    child: SvgPicture.asset('assets/images/bag.svg',
                        width: 20, color: Theme.of(context).primaryColorLight),
                  ),
                ),
                cartNotifier.totalItems > 0
                    ? Positioned(
                        top: 15,
                        right: 0,
                        child: new Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 2, left: 1, bottom: 1),
                          decoration: new BoxDecoration(
                            color: Color(0xFF66CC99),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: InkWell(
                            child: new Text(
                              '${cartNotifier.totals}',
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            );
          }),
        ));
  }
}
