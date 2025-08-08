import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/orderAccept_Widget.dart';
import 'package:cloudkitchen/order_page.dart/models/order.dart';


class OrderAcceptPage extends StatelessWidget {
  const OrderAcceptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyOrder = OrderModel(
      orderId: "895623897845212",
      status: OrderStatus.waiting,
      orderDate: "Feb 16,2025",
      name: "Premkumar Angapan",
      itemName: "Pepperoni Pizza",
      price: 12.99,
      quantity: 2,
      discount: 2.0,
      tax: 1.5,
      total: 12.99 * 2 - 2.0 + 1.5,
      // add any other fields if your OrderModel has more
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Orders',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  SvgPicture.asset(
                    'lib/assets/Icon.svg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              MyOrders(order: dummyOrder)
            ],
          ),
        ),
      ),
    );
  }
}
