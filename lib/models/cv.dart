class CV {
  String? fullName;
  String? linkToPP;
  String? job;
  String? location;
  String? phoneNumber;
  String? email;
  List<WEE>? workExperiences;
  List<WEE>? educations;
  List<Skill>? skills;
  List<String>? hobbies;
  String? aboutMe;
  List<Link>? links;
  List<Reference>? references;
  List<String>? languages;
  List<String>? additionalDetails;

  CV(
      {this.fullName,
      this.linkToPP,
      this.job,
      this.location,
      this.phoneNumber,
      this.email,
      this.workExperiences,
      this.educations,
      this.skills,
      this.hobbies,
      this.aboutMe,
      this.links,
      this.references,
      this.languages,
      this.additionalDetails});

  CV.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    linkToPP = json['linkToPP'];
    job = json['job'];
    location = json['location'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    if (json['workExperiences'] != null) {
      workExperiences = <WEE>[];
      json['workExperiences'].forEach((v) {
        workExperiences!.add(WEE.fromJson(v));
      });
    }
    if (json['educations'] != null) {
      educations = <WEE>[];
      json['educations'].forEach((v) {
        educations!.add(WEE.fromJson(v));
      });
    }
    if (json['skills'] != null) {
      skills = <Skill>[];
      json['skills'].forEach((v) {
        skills!.add(Skill.fromJson(v));
      });
    }
    hobbies = json['hobbies']?.cast<String>();
    aboutMe = json['aboutMe'];
    if (json['links'] != null) {
      links = <Link>[];
      json['links'].forEach((v) {
        links!.add(Link.fromJson(v));
      });
    }

    if (json['references'] != null) {
      references = <Reference>[];
      json['references'].forEach((v) {
        references!.add(Reference.fromJson(v));
      });
    }
    languages = json['languages']?.cast<String>();
    additionalDetails = json['additionalDetails']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['linkToPP'] = linkToPP;
    data['job'] = job;
    data['location'] = location;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    if (workExperiences != null) {
      data['workExperiences'] =
          workExperiences!.map((v) => v.toJson()).toList();
    } else {
      data['workExperiences'] = null;
    }
    if (educations != null) {
      data['educations'] = educations!.map((v) => v.toJson()).toList();
    } else {
      data['educations'] = null;
    }
    if (skills != null) {
      data['skills'] = skills!.map((v) => v.toJson()).toList();
    } else {
      data['skills'] = null;
    }
    data['hobbies'] = hobbies;
    data['aboutMe'] = aboutMe;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    } else {
      data['links'] = null;
    }
    if (references != null) {
      data['references'] = references!.map((v) => v.toJson()).toList();
    } else {
      data['references'] = null;
    }
    data['languages'] = languages;
    data['additionalDetails'] = additionalDetails;
    return data;
  }
}

class Reference {
  String? name;
  String? jobTitle;
  String? email;
  String? phoneNumber;

  Reference({this.name, this.jobTitle, this.email, this.phoneNumber});

  Reference.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    jobTitle = json['jobTitle'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['jobTitle'] = jobTitle;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}

class Link {
  String? name;
  String? link;

  Link({this.name, this.link});

  Link.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['link'] = link;
    return data;
  }
}

class Skill {
  String? name;
  int? capability;

  Skill({this.name, this.capability});

  Skill.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    capability = json['capability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['capability'] = capability;
    return data;
  }
}

class WEE {
  String? name;
  String? location;
  String? years;
  String? title;
  String? description;

  WEE({this.name, this.location, this.years, this.title, this.description});

  WEE.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    location = json['location'];
    years = json['years'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['location'] = location;
    data['years'] = years;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}
