class Message {
  int date;
  String senderName;
  String senderId;
  String message;
  Message({
    required this.date,
    required this.senderId,
    required this.senderName,
    required this.message,
  });
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        date: json['date'],
        senderId: json['senderId'],
        senderName: json['senderName'],
        message: json['message'],
      );
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['date'] = date;
    data['senderId'] = '$senderId';
    data['senderName'] = '$senderName';
    data['message'] = '$message';

    return data;
  }
}
