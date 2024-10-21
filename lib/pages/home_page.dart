import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_kent/Utils/CustomAppBar.dart';
import 'package:permission_handler/permission_handler.dart';



class HomePage extends StatelessWidget {
  final StatefulNavigationShell statefulNavigationShell;
  HomePage({required this.statefulNavigationShell});

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    selectedIndex= statefulNavigationShell.currentIndex;
    return Scaffold(
        appBar: CustomAppBar(),
        body: statefulNavigationShell, // Seçilen sayfayı göster
        bottomNavigationBar: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: NavigationBar(
            selectedIndex: statefulNavigationShell.currentIndex,
            onDestinationSelected: (value) => statefulNavigationShell.goBranch(value),
            backgroundColor: Theme.of(context).colorScheme.primary,
              indicatorColor: Theme.of(context).colorScheme.surface,
              destinations: [
            _buildNavBarItem(iconData: Icons.home_outlined,index: 0,currentIndex:statefulNavigationShell.currentIndex ,context:context ),
                _buildNavBarItem(iconData: Icons.navigation_outlined,index: 1,currentIndex:statefulNavigationShell.currentIndex,context: context ),
                _buildNavBarItem(iconData: Icons.health_and_safety_outlined,index: 2,currentIndex:statefulNavigationShell.currentIndex,context:context ),
                _buildNavBarItem(iconData: Icons.menu,index: 3,currentIndex:statefulNavigationShell.currentIndex,context:context ),
                _buildNavBarItem(iconData: Icons.person_2_outlined,index: 4,currentIndex:statefulNavigationShell.currentIndex ,context:context),
          ]),
        ));
  }

  NavigationDestination _buildNavBarItem(
      {required BuildContext context,required int index,required int currentIndex,required IconData iconData}) {
    return NavigationDestination(icon: Icon(iconData,color: index==currentIndex?Theme.of(context).colorScheme.onSurface:Theme.of(context).colorScheme.surface,), label: "");
  }

// CustomBottomNavigationBar(selectedIndex: _selectedIndex, onItemTapped: (p0) => _onItemTapped(p0),),
  Future<void> requestPermission() async {
    // 1. Depolama İzni
    var storageStatus = await Permission.storage.status;
    if (storageStatus.isDenied) {
      await Permission.storage.request();
    } else if (storageStatus.isGranted) {
      print('Depolama izni zaten verilmiş');
    } else if (storageStatus.isPermanentlyDenied) {
      print(
          'Depolama izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }

    // 2. Kamera İzni
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    } else if (cameraStatus.isGranted) {
      print('Kamera izni zaten verilmiş');
    } else if (cameraStatus.isPermanentlyDenied) {
      print(
          'Kamera izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }

    // 3. Mikrofon İzni
    var microphoneStatus = await Permission.microphone.status;
    if (microphoneStatus.isDenied) {
      await Permission.microphone.request();
    } else if (microphoneStatus.isGranted) {
      print('Mikrofon izni zaten verilmiş');
    } else if (microphoneStatus.isPermanentlyDenied) {
      print(
          'Mikrofon izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }

    // 4. Konum İzni (Lokasyon)
    var locationStatus = await Permission.location.status;
    if (locationStatus.isDenied) {
      await Permission.location.request();
    } else if (locationStatus.isGranted) {
      print('Konum izni zaten verilmiş');
    } else if (locationStatus.isPermanentlyDenied) {
      print(
          'Konum izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }

    // 5. Rehber İzni
    var contactsStatus = await Permission.contacts.status;
    if (contactsStatus.isDenied) {
      await Permission.contacts.request();
    } else if (contactsStatus.isGranted) {
      print('Rehber izni zaten verilmiş');
    } else if (contactsStatus.isPermanentlyDenied) {
      print(
          'Rehber izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }

    // 6. Bildirim İzni (Sadece iOS 15 ve üzeri için geçerlidir)
    // if (Permission.notification.isSupported()) {
    //   var notificationStatus = await Permission.notification.status;
    //   if (notificationStatus.isDenied) {
    //     await Permission.notification.request();
    //   } else if (notificationStatus.isGranted) {
    //     print('Bildirim izni zaten verilmiş');
    //   } else if (notificationStatus.isPermanentlyDenied) {
    //     print('Bildirim izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    //   }
    // }

    // 7. Arka Plan Konum İzni (Background Location)
    var backgroundLocationStatus = await Permission.locationAlways.status;
    if (backgroundLocationStatus.isDenied) {
      await Permission.locationAlways.request();
    } else if (backgroundLocationStatus.isGranted) {
      print('Arka plan konum izni zaten verilmiş');
    } else if (backgroundLocationStatus.isPermanentlyDenied) {
      print(
          'Arka plan konum izni kalıcı olarak reddedilmiş. Ayarlardan izin verilmesi gerekiyor.');
    }
  }


}
