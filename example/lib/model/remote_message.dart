class RemoteMessage {
	dynamic notification;
	Data data;

	RemoteMessage({this.notification, this.data});

	RemoteMessage.fromJson(Map<String, dynamic> json) {
		notification = json['notification'] != null ? null : null;
		data = json['data'] != null ? new Data.fromJson(json['data']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.notification != null) {
      data['notification'] = this.notification.toJson();
    }
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		return data;
	}
}

// class Notification {


// 	Notification({});

// 	Notification.fromJson(Map<String, dynamic> json) {
// 	}

// 	Map<String, dynamic> toJson() {
// 		final Map<String, dynamic> data = new Map<String, dynamic>();
// 		return data;
// 	}
// }

class Data {
	Custom custom;
	Wp wp;
	String alert;

	Data({this.custom, this.wp, this.alert});

	Data.fromJson(Map<String, dynamic> json) {
		custom = json['custom'] != null ? new Custom.fromJson(json['custom']) : null;
		wp = json['wp'] != null ? new Wp.fromJson(json['_wp']) : null;
		alert = json['alert'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.custom != null) {
      data['custom'] = this.custom.toJson();
    }
		if (this.wp != null) {
      data['wp'] = this.wp.toJson();
    }
		data['alert'] = this.alert;
		return data;
	}
}

class Custom {
	String moga;

	Custom({this.moga});

	Custom.fromJson(Map<String, dynamic> json) {
		moga = json['moga'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['moga'] = this.moga;
		return data;
	}
}

class Wp {
	String c;
	Alert alert;
	bool receipt;
	String type;
	String targetUrl;
	String n;

	Wp({this.c, this.alert, this.receipt, this.type, this.targetUrl, this.n});

	Wp.fromJson(Map<String, dynamic> json) {
		c = json['c'];
		alert = json['alert'] != null ? new Alert.fromJson(json['alert']) : null;
		receipt = json['receipt'];
		type = json['type'];
		targetUrl = json['targetUrl'];
		n = json['n'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['c'] = this.c;
		if (this.alert != null) {
      data['alert'] = this.alert.toJson();
    }
		data['receipt'] = this.receipt;
		data['type'] = this.type;
		data['targetUrl'] = this.targetUrl;
		data['n'] = this.n;
		return data;
	}
}

class Alert {
	String text;
	String type;
	String title;
	String bigPicture;

	Alert({this.text, this.type, this.title, this.bigPicture});

	Alert.fromJson(Map<String, dynamic> json) {
		text = json['text'];
		type = json['type'];
		title = json['title'];
		bigPicture = json['bigPicture'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['text'] = this.text;
		data['type'] = this.type;
		data['title'] = this.title;
		data['bigPicture'] = this.bigPicture;
		return data;
	}
}
