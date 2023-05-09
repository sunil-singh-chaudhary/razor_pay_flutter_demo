class User {
  final String orderId;
  final String paymentID;
  final String orderDetails;
  final double OrderPrice;

  User(
      {required this.orderId,
      required this.orderDetails,
      required this.paymentID,
      required this.OrderPrice});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      orderId: map['orderId'],
      orderDetails: map['orderDetails'],
      paymentID: map['paymentID'],
      OrderPrice: map['OrderPrice'],
    );
  }
}
