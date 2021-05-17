class Call {
  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  bool hasDialled;

  Call({
    this.callerId,
    this.callerName,
    this.callerPic,
    this.receiverId,
    this.receiverName,
    this.receiverPic,
    this.channelId,
    this.hasDialled,
  });

  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> mp = Map();
    mp["caller_id"] = call.callerId;
    mp["caller_name"] = call.callerName;
    mp["caller_pic"] = call.callerPic;
    mp["receiver_id"] = call.receiverId;
    mp["receiver_name"] = call.receiverName;
    mp["receiver_pic"] = call.receiverPic;
    mp["channel_id"] = call.channelId;
    mp["has_dialled"] = call.hasDialled;
    return mp;
  }

  Call.fromMap(Map mp) {
    this.callerId = mp["caller_id"];
    this.callerName = mp["caller_name"];
    this.callerPic =  mp["caller_pic"];
    this.receiverId = mp["receiver_id"];
    this.receiverName = mp["receiver_name"];
    this.receiverPic = mp["receiver_pic"];
    this.channelId = mp["channel_id"];
    this.hasDialled = mp["has_dialled"];
  }
}
