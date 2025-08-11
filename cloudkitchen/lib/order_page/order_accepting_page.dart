import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/orderAccept_Widget.dart';
import 'package:cloudkitchen/order_page.dart/models/order.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  
  List<Widget> get _pages => [
    OrderAcceptPage(),
    InventoryPage(),
    MorePage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0 ? AppBar(
        title: Text(
          "My Orders",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SvgPicture.asset(
              'lib/assets/Icon.svg',
              width: 45,
              height: 45,
              fit: BoxFit.fill,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ): null,
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF45C3FF),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 24,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'My Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}


class OrderAcceptPage extends StatelessWidget {
  const OrderAcceptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyOrder = OrderModel(
      orderId: "89562389784",
      status: OrderStatus.waiting,
      orderDate: "Feb 16,2025",
      name: "Premkumar Angapan",
      itemName: "Pepperoni Pizza",
      price: 12.99,
      quantity: 2,
      discount: 2.0,
      tax: 1.5,
      total: 12.99 * 2 - 2.0 + 1.5,
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            MyOrders(order: dummyOrder)
          ],
        ),
      ),
    );
  }
}


class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Inventory Page')),
    );
  }
}


class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('More Page')),
    );
  }
}