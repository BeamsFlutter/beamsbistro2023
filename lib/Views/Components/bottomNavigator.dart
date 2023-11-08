import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final String mode;
  final Function fnPage;
  final Function fnSave;
  final Function fnEdit;
  final Function fnAdd;
  final Function fnCancel;
  final Function fnDelete;
  final Function? fnSaveas;
  const BottomNavigation(
      {Key? key,
        required this.mode,
        required this.fnPage,
        required this.fnSave,
        required this.fnEdit,
        required this.fnAdd,
        required this.fnCancel,
        required this.fnDelete,
        this.fnSaveas})
      : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  var mode = '';
  var selectedItemV = 0;
  var selectedItemA = 0;
  var selectedItemE = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fnMode() == 'VIEW'
        ? BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.first_page_rounded,
              color: PrimaryColor,
            ),
            label: 'First',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.skip_previous,
              color: PrimaryColor,
            ),
            label: 'Previous',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.skip_next,
              color: PrimaryColor,
            ),
            label: 'Next',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.last_page,
              color: PrimaryColor,
            ),
            label: 'Last',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              color: PrimaryColor,
            ),
            label: 'Add',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.edit,
              color: PrimaryColor,
            ),
            label: 'Edit',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.delete_forever,
              color: PrimaryColor,
            ),
            label: 'Delete',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.copy,
              color: PrimaryColor,
            ),
            label: 'Save As',
            backgroundColor: Colors.white)
      ],
      type: BottomNavigationBarType.shifting,
      currentIndex: selectedItemV,
      selectedItemColor: PrimaryColor,
      iconSize: 25,
      onTap: (index) {
        setState(() {
          selectedItemV = index;
          fnButtonClick(index);
        });
      },
      elevation: 3,
    )
        : BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.save_sharp,
              color: PrimaryColor,
            ),
            label: 'Save',
            backgroundColor: Colors.white),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.cancel,
              color: PrimaryColor,
            ),
            label: 'Cancel',
            backgroundColor: Colors.white),
      ],
      type: BottomNavigationBarType.shifting,
      currentIndex: selectedItemA,
      selectedItemColor: PrimaryColor,
      iconSize: 25,
      onTap: (index) {
        setState(() {
          selectedItemA = index;
          fnButtonClick(index);
        });
      },
      elevation: 3,
    );
  }

  fnMode() {
    var m = '';
    m = widget.mode;
    return m;
  }

  fnButtonClick(index) {
    if (widget.mode == 'VIEW') {
      switch (index) {
        case 0:
          widget.fnPage('FIRST');
          break;
        case 1:
          widget.fnPage('PREVIOUS');
          break;
        case 2:
          widget.fnPage('NEXT');
          break;
        case 3:
          widget.fnPage('LAST');
          break;
        case 4:
          widget.fnAdd();
          break;
        case 5:
          widget.fnEdit();
          break;
        case 6:
          widget.fnDelete();
          break;
        case 7:
          widget.fnSaveas!();
          break;
        default:
          break;
      }
    } else {
      switch (index) {
        case 0:
          widget.fnSave();
          break;
        case 1:
          widget.fnCancel();
          break;
      }
    }
  }
}
