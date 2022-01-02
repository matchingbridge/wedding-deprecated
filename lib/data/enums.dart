enum Marriage { Single, Back, Pass }
extension MarriageExtension on Marriage {
  String get literal {
    switch (this) {
      case Marriage.Single: return '미혼';
      case Marriage.Back: return '돌싱';
      case Marriage.Pass: return '무관';
    }
  }
}

enum Scholar { UndergraduateOn, UndergraduateOff, GraduateOn, GraduateOff, Other, Pass }
extension ScholarExtension on Scholar {
  String get literal {
    switch (this) {
      case Scholar.UndergraduateOn: return '대학교 재학';
      case Scholar.UndergraduateOff: return '대학교 졸업';
      case Scholar.GraduateOn: return '대학원 재학';
      case Scholar.GraduateOff: return '대학원 졸업';
      case Scholar.Other: return '고등학교 졸업 및 기타';
      case Scholar.Pass: return '무관';
    }
  }
}

enum Job { Specialized, Big, Small, Government, Public, Normal, Business, Other }
extension JobExtension on Job {
  String get literal {
    switch (this) {
      case Job.Specialized: return '전문직';
      case Job.Big: return '대기업';
      case Job.Small: return '중소기업';
      case Job.Government: return '공무원';
      case Job.Public: return '공기업';
      case Job.Normal: return '일반 회사원';
      case Job.Business: return '개인 사업';
      case Job.Other: return '무관';
    }
  }
}

enum Smoke { Yes, No, Pass }
extension SmokeExtension on Smoke {
  String get literal {
    switch (this) {
      case Smoke.Yes: return '흡연';
      case Smoke.No: return '비흡연';
      case Smoke.Pass: return '무관';
    }
  }
}

enum Gender { Male, Female }
extension GenderExtension on Gender {
  String get literal {
    switch (this) {
      case Gender.Male: return '남성';
      case Gender.Female: return '여성';
    }
  }
}

enum Religion { Protestant, Catholic, Buddhist, None, Other }
extension ReligionExtension on Religion {
  String get literal {
    switch (this) {
      case Religion.Protestant: return '기독교';
      case Religion.Catholic: return '천주교';
      case Religion.Buddhist: return '불교';
      case Religion.None: return '무교';
      case Religion.Other: return '기타';
    }
  }
}

enum Wedding { Early20, Mid20, Later20, Early30, Mid30, Later30 }
extension WeddingExtension on Wedding {
  String get literal {
    switch (this) {
      case Wedding.Early20: return '20대 초반';
      case Wedding.Mid20: return '20대 중반';
      case Wedding.Later20: return '20대 후반';
      case Wedding.Early30: return '30대 초반';
      case Wedding.Mid30: return '30대 중반';
      case Wedding.Later30: return '30대 후반';
    }
  }
}

enum BodyType { Body1, Body2, Body3, Body4, Body5, Body6, Body7, Body8, Body9, Body10 }
extension BodyTypeExtension on BodyType {
  String get literalMale {
    switch (this) {
      case BodyType.Body1: return '곰같은';
      case BodyType.Body2: return '근육질인';
      case BodyType.Body3: return '평범한';
      case BodyType.Body4: return '어깨가 넓은';
      case BodyType.Body5: return '허벅지가 탄탄한';
      case BodyType.Body6: return '엉덩이가 예쁜';
      case BodyType.Body7: return '배가 나온';
      case BodyType.Body8: return '얼굴이 작은';
      case BodyType.Body9: return '매끈한';
      case BodyType.Body10: return '아이돌체형';
    }
  }
  String get literalFemale {
    switch (this) {
      case BodyType.Body1: return '글래머러스한';
      case BodyType.Body2: return '통통한';
      case BodyType.Body3: return '살집이 있는';
      case BodyType.Body4: return '가슴이 큰';
      case BodyType.Body5: return '엉덩이가 예쁜';
      case BodyType.Body6: return '허리가 잘록한';
      case BodyType.Body7: return '얼굴이 작은';
      case BodyType.Body8: return '평범한';
      case BodyType.Body9: return '여리여리한';
      case BodyType.Body10: return '근육질인';
    }
  }
}

enum Character { 
  Character1, Character2, Character3, Character4, Character5, 
  Character6, Character7, Character8, Character9, Character10, 
  Character11, Character12, Character13, Character14, Character15, 
  Character16, Character17, Character18, Character19, Character20
}
extension CharacterExtension on Character {
  String get literalMale {
    switch (this) {
      case Character.Character1: return '외향적인';
      case Character.Character2: return '내성적인';
      case Character.Character3: return '상남자같은';
      case Character.Character4: return '털털한';
      case Character.Character5: return '차분한';
      case Character.Character6: return '수다스러운';
      case Character.Character7: return '과묵한';
      case Character.Character8: return '섹시한';
      case Character.Character9: return '유머있는';
      case Character.Character10: return '배려심깊은';
      case Character.Character11: return '감성적인';
      case Character.Character12: return '이성적인';
      case Character.Character13: return '자유로운';
      case Character.Character14: return '계획적인';
      case Character.Character15: return '애교있는';
      case Character.Character16: return '귀여운';
      case Character.Character17: return '우아한';
      case Character.Character18: return '평범한';
      case Character.Character19: return '못생긴';
      case Character.Character20: return '성적성향이있는';
    }
  }
  String get literalFemale {
    switch (this) {
      case Character.Character1: return '외향적인';
      case Character.Character2: return '내성적인';
      case Character.Character3: return '여성스러운';
      case Character.Character4: return '털털한';
      case Character.Character5: return '차분한';
      case Character.Character6: return '수다스러운';
      case Character.Character7: return '과묵한';
      case Character.Character8: return '섹시한';
      case Character.Character9: return '유머있는';
      case Character.Character10: return '배려심깊은';
      case Character.Character11: return '감성적인';
      case Character.Character12: return '이성적인';
      case Character.Character13: return '자유로운';
      case Character.Character14: return '계획적인';
      case Character.Character15: return '애교있는';
      case Character.Character16: return '귀여운';
      case Character.Character17: return '우아한';
      case Character.Character18: return '평범한';
      case Character.Character19: return '못생긴';
      case Character.Character20: return '성적성향이있는';
    }
  }
}

enum Area { Seoul, Busan, Daegu, Incheon, Gwangju, Daejeon, Ulsan, Sejong, Gyeonggi, Gangwon, Chungbuk, Chungnam, Jeonbuk, Jeonnam, Gyeongbuk, Gyeongnam, Jeju }
extension AreaExtension on Area {
  String get literal {
    switch (this) {
      case Area.Seoul: return '서울';
      case Area.Busan: return '부산';
      case Area.Daegu: return '대구';
      case Area.Incheon: return '인천';
      case Area.Gwangju: return '광주';
      case Area.Daejeon: return '대전';
      case Area.Ulsan: return '울산';
      case Area.Sejong: return '세종';
      case Area.Gyeonggi: return '경기';
      case Area.Gangwon: return '강원';
      case Area.Chungbuk: return '충북';
      case Area.Chungnam: return '충남';
      case Area.Jeonbuk: return '전북';
      case Area.Jeonnam: return '전남';
      case Area.Gyeongbuk: return '경북';
      case Area.Gyeongnam: return '경남';
      case Area.Jeju: return '제주';
    }
  }
}

enum Parent { Both, Father, StepFather, Mother, StepMother }
extension ParentExtension on Parent {
  String get literal {
    switch (this) {
      case Parent.Both: return '양부모 다 계심';
      case Parent.Father: return '편부';
      case Parent.StepFather: return '편부(재혼)';
      case Parent.Mother: return '편모';
      case Parent.StepMother: return '편모(재혼)';
    }
  }
}

enum Relation { OlderBrother, OlderSister, YoungerBrother, YoungerSister }
extension RelationExtension on Relation {
  String get literalMale {
    switch (this) {
      case Relation.OlderBrother: return '형';
      case Relation.OlderSister: return '누나';
      case Relation.YoungerBrother: return '남동생';
      case Relation.YoungerSister: return '여동생';
    }
  }
  String get literalFemale {
    switch (this) {
      case Relation.OlderBrother: return '오빠';
      case Relation.OlderSister: return '언니';
      case Relation.YoungerBrother: return '남동생';
      case Relation.YoungerSister: return '여동생';
    }
  }
}