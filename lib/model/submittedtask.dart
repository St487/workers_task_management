class Submittedtask {
  String? id;
  String? workId;
  String? workerId;
  String? text;
  String? date;
  String? dueDate;
  String? title;

  Submittedtask(
      {this.id,
      this.workId,
      this.workerId,
      this.text,
      this.date,
      this.dueDate,
      this.title});

  Submittedtask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workId = json['work_id'];
    workerId = json['worker_id'];
    text = json['submission_text'];
    date = json['submitted_at'];
    dueDate = json['due_date'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['work_id'] = workId;
    data['woker_id'] = workerId;
    data['submission_text'] = text;
    data['submitted_at'] = date;
    data['due_date'] = dueDate;
    data['title'] = title;
    return data;
  }
}
