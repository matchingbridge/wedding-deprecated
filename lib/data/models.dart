import 'package:get/get.dart';
import 'package:wedding/data/enums.dart';
import 'package:wedding/data/structs.dart';
import 'package:wedding/pages/mobile/root_page.dart';
import 'package:wedding/services/mobile/base_service.dart';

class Chat {
  String userID;
  bool isTalking;
  String message;
  DateTime chattedAt;

  Chat({
    required this.userID, 
    required this.isTalking, 
    required this.message,
    required this.chattedAt
  });

  factory Chat.fromJSON(Map json) => Chat(
    userID: json['user_id'],
    isTalking: json['is_talking'],
    message: json['message'],
    chattedAt: DateTime.parse(json['chatted_at']).toLocal().add(Duration(hours: 9))
  );
}

class Match {
  int matchID;
  String senderID;
  String receiverID;
  DateTime? askedAt;
  DateTime? matchedAt;
  DateTime? terminatedAt;

  Match({
    required this.matchID,
    required this.senderID,
    required this.receiverID,
    this.askedAt,
    this.matchedAt,
    this.terminatedAt
  });

  factory Match.fromJSON(Map json) => Match(
    matchID: json['match_id'],
    senderID: json['sender_id'],
    receiverID: json['receiver_id'],
    askedAt: DateTime.tryParse(json['asked_at'] ?? ''),
    matchedAt: DateTime.tryParse(json['matched_at'] ?? ''),
    terminatedAt: DateTime.tryParse(json['terminated_at'] ?? '')
  );

  factory Match.dummy() => Match(
    matchID: 0, senderID: "", receiverID: ""
  );

  String get partnerID {
    var rootController = Get.find<RootController>();
    if (rootController.user.value.userID == senderID && rootController.user.value.userID != receiverID) return receiverID;
    else return senderID;
  }

  String get thumbnail {
    return '${BaseService.endpoint}/user/media/face1/$partnerID';
  }
}

class Review {
  int matchID;
  String targetID;
  DateTime writtenAt;
  String content;

  Review({
    required this.matchID,
    required this.targetID,
    required this.writtenAt,
    required this.content
  });

  factory Review.fromJSON(Map json) => Review(
    matchID: json['match_id'],
    targetID: json['target_id'],
    writtenAt: DateTime.parse(json['written_at']),
    content: json['content']
  );
}

class Suggestion {
  String userID;
  List<String> partnerIDs;
  DateTime suggestedAt;

  Suggestion({
    required this.userID,
    required this.partnerIDs,
    required this.suggestedAt
  });

  factory Suggestion.fromJSON(Map json) => Suggestion(
    userID: json['user_id'], 
    partnerIDs: (json['partner_ids'] as String).split(','), 
    suggestedAt: DateTime.parse(json['suggested_at'])
  );
}

class UserBase {
  final String userID;
  final int authID;
	final String name;
	final Gender gender;
	final Marriage marriage;
	final Area area;
	final Scholar scholar;
	final Job job;
	DateTime? reviewedAt;
  UserBase({
    required this.userID,
    required this.authID,
    required this.name,
    required this.gender,
    required this.marriage,
    required this.area,
    required this.scholar,
    required this.job,
    required this.reviewedAt
  });

  factory UserBase.fromJSON(Map json) => UserBase(
    userID: json['user_id'],
    authID: json['auth_id'],
    name: json['name'],
    gender: Gender.values[json['gender']],
    marriage: Marriage.values[json['marriage']],
    area: Area.values[json['area']],
    scholar: Scholar.values[json['scholar']],
    job: Job.values[json['job']],
    reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at']) : null
  );
}

class User {
  String userID;
  String name;
  String phone;
  Gender gender;
  Marriage marriage;
  String birthday;
  Area area;
  String address;
  Scholar scholar;
  String school;
  Job job;
  String workplace;
  int salary;
  int asset;
  List<String> realestate;
  List<String> vehicle;
  int height;
  int weight;
  BodyType bodyType;
  Character character;
  Smoke smoke;
  Religion religion;
  bool longDistance;
  Wedding wedding;
  String introduction;
  Marriage partnerMarriage;
  Range<int> partnerAge;
  Range<int> partnerHeight;
  Scholar partnerScholar;
  List<Job> partnerJob;
  Range<int> partnerSalary;
  Range<int> partnerAsset;
  List<BodyType> partnerBodyType;
  List<Character> partnerCharacter;
  Smoke partnerSmoke;
  String partnerOther;
  String parent;
  String sibling;

  User({
    required this.userID,
    required this.name,
    required this.phone,
    required this.gender,
    required this.marriage,
    required this.birthday,
    required this.area,
    required this.address,
    required this.scholar,
    required this.school,
    required this.job,
    required this.workplace,
    required this.salary,
    required this.asset,
    required this.realestate,
    required this.vehicle,
    required this.height,
    required this.weight,
    required this.bodyType,
    required this.character,
    required this.smoke,
    required this.religion,
    required this.longDistance,
    required this.wedding,
    required this.introduction,
    required this.partnerMarriage,
    required this.partnerAge,
    required this.partnerHeight,
    required this.partnerScholar,
    required this.partnerJob,
    required this.partnerSalary,
    required this.partnerAsset,
    required this.partnerBodyType,
    required this.partnerCharacter,
    required this.partnerSmoke,
    required this.partnerOther,
    required this.parent,
    required this.sibling
  });

  factory User.dummy() => User(
    userID: 'userID', name: 'name', 
    phone: 'phone',  gender: Gender.Male, marriage: Marriage.Single, 
    birthday: '890929', area: Area.Chungnam, address: 'address', 
    scholar: Scholar.UndergraduateOn, school: 'school', 
    job: Job.Big, workplace: 'workplace',
    salary: 0, asset: 0, realestate: ['address'], vehicle: ['vehicle'], 
    height: 0, weight: 0, bodyType: BodyType.Body1, character: Character.Character4, 
    smoke: Smoke.Yes, religion: Religion.Buddhist,
    longDistance: true, wedding: Wedding.Early20, introduction: 'intro', 
    partnerMarriage: Marriage.Pass,
    partnerAge: Range<int>(A: 20, B: 40), 
    partnerHeight: Range<int>(A: 150, B: 190),
    partnerScholar: Scholar.UndergraduateOn,
    partnerJob: [Job.Big, Job.Small],
    partnerSalary: Range<int>(A: 45, B: 100),
    partnerAsset: Range<int>(A: 100, B: 200),
    partnerBodyType: [BodyType.Body5], partnerCharacter: [Character.Character4],
    partnerSmoke: Smoke.Pass, partnerOther: 'partner other',
    parent: 'parent', sibling: 'sibling'
  );

  factory User.fromJSON(Map json) => User(
    userID: json['user_id'],
    name: json['name'],
    phone: json['phone'],
    gender: Gender.values[json['gender']],
    marriage: Marriage.values[json['marriage']],
    birthday: json['birthday'],
    area: Area.values[json['area']],
    address: json['address'],
    scholar: Scholar.values[json['scholar']],
    school: json['school'],
    job: Job.values[json['job']],
    workplace: json['workplace'],
    salary: json['salary'],
    asset: json['asset'],
    realestate: (json['realestate'] as String).isEmpty ? [] : (json['realestate'] as String).split(','),
    vehicle: (json['vehicle'] as String).isEmpty ? [] : (json['vehicle'] as String).split(','),
    height: json['height'], 
    weight: json['weight'], 
    bodyType: BodyType.values[json['bodytype']], 
    character: Character.values[json['character']],
    smoke: Smoke.values[json['smoke']], 
    religion: Religion.values[json['religion']],
    longDistance: json['long_distance'], 
    wedding: Wedding.values[json['wedding']],
    introduction: json['introduction'],
    partnerMarriage: Marriage.values[json['partner_marriage']],
    partnerAge: Range<int>(A: json['partner_age_min'], B: json['partner_age_max']),
    partnerHeight: Range<int>(A: json['partner_height_min'], B: json['partner_height_max']),
    partnerScholar: Scholar.values[json['partner_scholar']],
    partnerJob: json['partner_job'] == '' ? [] : (json['partner_job'] as String).split(',').map<Job>((e) => Job.values[int.parse(e)]).toList(),
    partnerSalary: Range<int>(A: json['partner_salary_min'], B: json['partner_salary_max']),
    partnerAsset: Range<int>(A: json['partner_asset_min'], B: json['partner_asset_max']),
    partnerBodyType: json['partner_bodytype'] == '' ? [] : (json['partner_bodytype'] as String).split(',').map<BodyType>((e) => BodyType.values[int.parse(e)]).toList(),
    partnerCharacter: json['partner_character'] == '' ? [] : (json['partner_character'] as String).split(',').map<Character>((e) => Character.values[int.parse(e)]).toList(),
    partnerSmoke: Smoke.values[json['partner_smoke']],
    partnerOther: json['partner_other'],
    parent: json['parent'],
    sibling: json['sibling'],
  );

  Map<String, dynamic> toJSON() => {
    'user_id': userID,
    'name': name,
    'phone': phone,
    'gender': Gender.values.indexOf(gender),
    'marriage': Marriage.values.indexOf(marriage),
    'birthday': birthday,
    'area': Area.values.indexOf(area),
    'address': address,
    'scholar': Scholar.values.indexOf(scholar),
    'school': school,
    'job': Job.values.indexOf(job),
    'workplace': workplace,
    'salary': salary, 
    'asset': asset, 
    'realestate': realestate.join(','),
    'vehicle': vehicle.join(','),
    'height': height, 
    'weight': weight,
    'bodytype': BodyType.values.indexOf(bodyType),
    'character': Character.values.indexOf(character),
    'smoke': Smoke.values.indexOf(smoke),
    'religion': Religion.values.indexOf(religion),
    'long_distance': longDistance,
    'wedding': Wedding.values.indexOf(wedding),
    'introduction': introduction,
    'partner_marriage': Marriage.values.indexOf(partnerMarriage),
    'partner_age_min': partnerAge.min,
    'partner_age_max': partnerAge.max,
    'partner_height_min': partnerHeight.min,
    'partner_height_max': partnerHeight.max,
    'partner_scholar': Scholar.values.indexOf(partnerScholar),
    'partner_job': partnerJob.map((e) => Job.values.indexOf(e)).toList().join(','),
    'partner_salary_min': partnerSalary.min,
    'partner_salary_max': partnerSalary.max,
    'partner_asset_min': partnerAsset.min,
    'partner_asset_max': partnerAsset.max,
    'partner_bodytype': partnerBodyType.map((e) => BodyType.values.indexOf(e)).join(','),
    'partner_character': partnerCharacter.map((e) => Character.values.indexOf(e)).join(','),
    'partner_smoke': Smoke.values.indexOf(partnerSmoke),
    'partner_other': partnerOther,
    'parent': parent,
    'sibling': sibling
  };

  get age => DateTime.now().year - int.parse(birthday.substring(0, 4)) + 1;
  get bodyTypeLiteral => gender == Gender.Male ? bodyType.literalMale : bodyType.literalFemale;
  get characterLiteral => gender == Gender.Male ? character.literalMale : character.literalFemale;
  get salaryLiteral => salary > 100 ? '${salary / 100}억 ${salary % 100}00만원' : '${salary}00만원';
  get assetLiteral => asset > 100 ? '${(asset / 100).floor()}억 ${asset % 100}00만원' : '${asset}00만원';
  get realestateLiteral => realestate.isEmpty ? '없음' : realestate.join('\n');
  get vehicleLiteral => vehicle.isEmpty ? '없음' : vehicle.join('\n');

  String media(String bucket) => '${BaseService.endpoint}/user/media/$bucket/$userID';
}