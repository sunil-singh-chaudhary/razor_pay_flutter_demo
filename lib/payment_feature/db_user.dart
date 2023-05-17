class User {
  final String orderId;
  final String paymentID;
  final String orderDetails;
  final double orderPrice;

  User(
      {required this.orderId,
      required this.orderDetails,
      required this.paymentID,
      required this.orderPrice});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      orderId: map['orderId'],
      orderDetails: map['orderDetails'],
      paymentID: map['paymentID'],
      orderPrice: map['orderPrice'],
    );
  }
}
