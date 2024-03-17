// class TodoModel {
//   String? id;
//   bool? isActive;
//   bool? isDone;
//   String? subtitle;
//   String? title;
//   Timestamp? createdAt;
//
//   TodoModel(
//       {this.id,
//       this.isActive,
//       this.isDone,
//       this.subtitle,
//       this.title,
//       this.createdAt});
//
//   TodoModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     isActive = json['isActive'];
//     isDone = json['isDone'];
//     subtitle = json['subtitle'];
//     title = json['title'];
//     createdAt = json['createdAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['isActive'] = isActive;
//     data['isDone'] = isDone;
//     data['subtitle'] = subtitle;
//     data['title'] = title;
//     data['createdAt'] = createdAt;
//     return data;
//   }
// }
class TodoModel {
  int? id;
  String? title, description, status, timeString;
  int? statusID;
  int? timer;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    required this.statusID,
    required this.status,
    required this.timer,
    required this.timeString,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'statusID': statusID,
      'status': status,
      'timer': timer,
      'timeString': timeString,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      statusID: map['statusID'] ?? 0,
      status: map['status'] ?? '',
      timer: map['timer'] ?? 0,
      timeString: map['timeString'] ?? '',
    );
  }
}
