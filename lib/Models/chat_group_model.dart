class ChatGroupModel {
  int? id;
  String? groupName;
  String? groupContent;
  int? groupIcon;
  int? maxMembersNumber;
  int? membersNumber;

  ChatGroupModel(
      {this.id,
        this.groupName,
        this.groupContent,
        this.groupIcon,
        this.maxMembersNumber,
        this.membersNumber});

  ChatGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    groupContent = json['group_content'];
    groupIcon = json['group_icon'];
    maxMembersNumber = json['max_members_number'];
    membersNumber = json['members_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_name'] = this.groupName;
    data['group_content'] = this.groupContent;
    data['group_icon'] = this.groupIcon;
    data['max_members_number'] = this.maxMembersNumber;
    data['members_number'] = this.membersNumber;
    return data;
  }
}