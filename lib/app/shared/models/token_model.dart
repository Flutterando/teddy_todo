class TokenModel {
  String accessToken;
  String tokenType;
  int expiresIn;
  String credentials;

  TokenModel({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.credentials,
  });

  TokenModel.fromJson(dynamic json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    credentials = json['credentials'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['credentials'] = this.credentials;
    return data;
  }
}
