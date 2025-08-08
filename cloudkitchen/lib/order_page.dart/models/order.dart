enum OrderStatus { waiting, accepted, rejected, cancelled }

class OrderModel {
  final String orderId;
  final OrderStatus status;
  final String orderDate;
  final String name;
  final String itemName;
  final double price;
  final int quantity;
  final double discount;
  final double tax;
  final double total;

  OrderModel(
      {required this.orderId,
      required this.status,
      required this.orderDate,
      required this.name,
      required this.itemName,
      required this.price,
      required this.quantity,
      required this.discount,
      required this.tax,
      required this.total});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      status: _parseStatus(json['status']),
      orderDate: json['orderDate'],
      name: json['name'],
      itemName: json['itemName'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      discount: (json['discount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
  static OrderStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'waiting for approval':
        return OrderStatus.waiting;
      case 'accepted':
        return OrderStatus.accepted;
      case 'rejected':
        return OrderStatus.rejected;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.waiting;
    }
  }

  
}