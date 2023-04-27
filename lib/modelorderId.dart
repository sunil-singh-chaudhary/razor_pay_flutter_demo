class ModelOrderId {
  ModelOrderId({
    required this.status,
    required this.msg,
    required this.information,
  });
  late final int status;
  late final String msg;
  late final String information;
  ModelOrderId.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    information = json['Information'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    data['Information'] = information;
    return data;
  }
}
