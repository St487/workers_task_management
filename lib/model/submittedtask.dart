class Submittedtask {
  String? id;
  String? workId;
  String? workerId;
  String? text;
  String? date;
  String? title;

  Submittedtask(
      {this.id,
      this.workId,
      this.workerId,
      this.text,
      this.date,
      this.title});

  Submittedtask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workId = json['work_id'];
    workerId = json['woker_id'];
    text = json['submission_text'];
    date = json['submitted_at'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['work_id'] = workId;
    data['woker_id'] = workerId;
    data['submission_text'] = text;
    data['submitted_at'] = date;
    data['title'] = title;
    return data;
  }
}
