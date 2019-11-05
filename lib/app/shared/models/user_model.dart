class UserModel {
  String name;
  String email;
  String githubUsername;
  int id;

  UserModel(
      {this.name, this.email, this.githubUsername, this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    githubUsername = json['github_username'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['github_username'] = this.githubUsername;
    data['id'] = this.id;
    return data;
  }
}