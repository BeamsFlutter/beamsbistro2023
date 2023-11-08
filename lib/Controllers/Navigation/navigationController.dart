

import 'package:beamsbistro/Views/Pages/Admin/admin_home.dart';
import 'package:beamsbistro/Views/Pages/Bill/billingPos.dart';
import 'package:beamsbistro/Views/Pages/Bill/salesSummary.dart';
import 'package:beamsbistro/Views/Pages/Home/homePage.dart';
import 'package:beamsbistro/Views/Pages/Home/waiterHomeL.dart';
import 'package:beamsbistro/Views/Pages/Home/waiterMode.dart';
import 'package:beamsbistro/Views/Pages/Kitchen/kitchenScreen.dart';
import 'package:beamsbistro/Views/Pages/Login/clockin.dart';
import 'package:beamsbistro/Views/Pages/Login/ip.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Pages/Master/floorMast.dart';
import 'package:beamsbistro/Views/Pages/Master/masterHome.dart';
import 'package:beamsbistro/Views/Pages/Master/master_home.dart';
import 'package:beamsbistro/Views/Pages/Master/tableMaster.dart';
import 'package:beamsbistro/Views/Pages/Menu/menu.dart';
import 'package:beamsbistro/Views/Pages/Menu/menuL.dart';
import 'package:beamsbistro/Views/Pages/Order/orders.dart';
import 'package:beamsbistro/Views/Pages/QuickBill/quick_home.dart';
import 'package:beamsbistro/Views/Pages/Table/table.dart';
import 'package:flutter/material.dart';

class NavigationController{

  fnRoute(page) {
    switch (page) {
      case 1:
        return MaterialPageRoute(builder: (context) => WaiterHomeL()) ;
        break;
      case 2:
        return MaterialPageRoute(builder: (context) => Home()) ;
        break;
      case 3:
        return MaterialPageRoute(builder: (context) => MasterHome()) ;
        break;
      case 4:
        return MaterialPageRoute(builder: (context) => FloorMast()) ;
        break;
      case 5:
        return MaterialPageRoute(builder: (context) => TableMast()) ;
        break;
      case 6:
        return MaterialPageRoute(builder: (context) => Menu()) ;
        break;
      case 7:
        return MaterialPageRoute(builder: (context) => Tables()) ;
        break;
      case 8:
        return MaterialPageRoute(builder: (context) => Orders()) ;
        break;
      case 9:
        return MaterialPageRoute(builder: (context) => Pos()) ;
        break;
      case 10:
        return MaterialPageRoute(builder: (context) => Kitchen()) ;
        break;
      case 11:
        return MaterialPageRoute(builder: (context) => Login()) ;
        break;
      case 12:
        return MaterialPageRoute(builder: (context) => ClockIn()) ;
        break;
      case 13:
        return MaterialPageRoute(builder: (context) => Home()) ;
        break;
      case 14:
        return MaterialPageRoute(builder: (context) => WaiterHomeL()) ;
        break;
      case 15:
        return MaterialPageRoute(builder: (context) => MenuL()) ;
        break;
      case 16:
        return MaterialPageRoute(builder: (context) => QuickHome());
        break;
      case 17:
        return MaterialPageRoute(builder: (context) => IpConfig()) ;
        break;
      case 18:
        return MaterialPageRoute(builder: (context) => AdminHome()) ;
        break;
      case 19:
        return MaterialPageRoute(builder: (context) => SalesSummary()) ;
        break;
      case 20:
        return MaterialPageRoute(builder: (context) => MasterHomev2());
        break;
      default:
        return MaterialPageRoute(builder: (context) => Waiter()) ;
        break;
    }
  }

}