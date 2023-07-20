class Payment {
  String? paymentId;
  String? userId;
  String? paymentDate;
  String? paymentStatus;
  double? amount;

  Payment({this.paymentId, this.userId, this.paymentDate, this.paymentStatus, this.amount});

  Payment.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    userId = json['user_id'];
    paymentDate = json['payment_date'];
    paymentStatus = json['payment_status'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['user_id'] = userId;
    data['payment_date'] = paymentDate;
    data['payment_status'] = paymentStatus;
    data['amount'] = amount;
    return data;
  }
}
