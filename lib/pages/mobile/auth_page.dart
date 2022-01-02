import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wedding/components/button.dart';
import 'package:wedding/components/dropdown.dart';
import 'package:wedding/components/elements.dart';
import 'package:wedding/components/list.dart';
import 'package:wedding/components/popup.dart';
import 'package:wedding/components/slider.dart';
import 'package:wedding/components/textfield.dart';
import 'package:wedding/components/toggle.dart';
import 'package:wedding/data/colors.dart';
import 'package:wedding/data/enums.dart';
import 'package:wedding/data/models.dart';
import 'package:wedding/data/strings.dart';
import 'package:wedding/data/structs.dart';
import 'package:wedding/pages/mobile/root_page.dart';
import 'package:wedding/services/mobile/address_service.dart';
import 'package:wedding/services/mobile/auth_service.dart';
import 'package:wedding/services/mobile/user_service.dart';

enum AuthState { SignIn, SignUp_1, SignUp_2, SignUp_3, Complete }
enum UserIDCheckState { Unchecked, Exist, Available }
enum PhoneCheckState { Unsent, Sent, Verified }

class AuthController extends GetxController {
  var authState = AuthState.SignIn.obs;

  var userID = TextEditingController();
  var userFocus = FocusNode();
  var userIDCheckStatus = UserIDCheckState.Unchecked.obs;
  var password = TextEditingController();
  var confirm = TextEditingController();

  var name = TextEditingController();
  var phone = TextEditingController();
  var phoneCheckStatus = PhoneCheckState.Unsent.obs;
  var birthday = TextEditingController();
  var gender = TextEditingController();
  // var gender = Gender.Female.obs;
  var marriage = Marriage.Single.obs;
  // var birthday = DateTime(1980).obs;
  var area = Area.Seoul.obs;
  var address = TextEditingController();
  var addressCandidate = <String>[].obs;
  var scholar = Scholar.GraduateOff.obs;
  var school = TextEditingController();
  var job = Job.Normal.obs;
  var workplace = TextEditingController();
  var salary = 0.obs;
  var asset = 0.obs;
  var realestate = <String>[].obs;
  var vehicle = <String>[].obs;
  var height = 170.obs;
  var weight = 60.obs;
  var bodyType = BodyType.Body1.obs;
  var character = Character.Character1.obs;
  var smoke = Smoke.No.obs;
  var religion = Religion.None.obs;
  var longDistance = true.obs;
  var wedding = Wedding.Early30.obs;

  var media = <String, String?>{'face1': null, 'face2': null, 'body1': null, 'body2': null, 'video': null}.obs;
  var introduction = TextEditingController();
  var partnerMarriage = Marriage.Single.obs;
  var partnerAge = Range(A: 30, B: 40).obs;
  var partnerHeight = Range(A: 160, B: 180).obs;
  var partnerScholar = Scholar.UndergraduateOff.obs;
  var partnerJob = <Job>[].obs;
  var partnerSalary = Range(A: 0, B: 100).obs;
  var partnerAsset = Range(A: 0, B: 100).obs;
  var partnerBodyType = <BodyType>[].obs;
  var partnerCharacter = <Character>[].obs;
  var partnerSmoke = Smoke.Pass.obs;
  var partnerOther = TextEditingController();
  
  var parent = Parent.Both.obs;
  var fatherJob = TextEditingController();
  var motherJob = TextEditingController();
  var parentAddress = TextEditingController();

  var brother = 0.obs;
  var sister = 0.obs;
  var yourself = 1.obs;
  var siblings = <List<TextEditingController>>[].obs;

  void showSignIn() => authState.value = AuthState.SignIn;
  void showSignUp() => authState.value = AuthState.SignUp_1;

  get isUserIDValid => 8 <= userID.text.length && userID.text.length <= 16;
  get isPasswordValid => 8 <= password.text.length && password.text.length <= 16;
  get isConfirmValid => password.text == confirm.text;
  get isNameValid => name.text.isNotEmpty && name.text.length < 12;
  get isPhoneValid => 10 <= phone.text.length && phone.text.length <= 11 && phoneCheckStatus.value == PhoneCheckState.Verified;
  get isAddressValid => address.text.isNotEmpty;
  get isSchoolValid => school.text.isNotEmpty;
  get isWorkplaceValid => workplace.text.isNotEmpty;
  
  get isIntroductionValid => introduction.text.isNotEmpty;
  get isPartnerOtherValid => partnerOther.text.isNotEmpty;
  
  get isFatherJobValid => fatherJob.text.isNotEmpty;
  get isMotherJobValid => motherJob.text.isNotEmpty;
  get isParentAddressValid => parentAddress.text.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    userFocus.addListener(() { 
      if (!userFocus.hasFocus)
        checkUserID();
    });
    address.addListener(onAddressChanged);
  }

  Future<void> onAddressChanged() async {
    if (address.text.isEmpty) return;
    try {
      addressCandidate.value = await AddressService.getAddress(address.text);
    } catch (error) {
      buildPopup(failedToSignUpPopup, addressInvalid);
    }
  }

  void onSelectAddress(String picked) {
    address.text = picked;
    addressCandidate.value = [];
  }

  void validateSignIn() {
    if (!isUserIDValid)
      buildPopup(failedToSignInPopup, userIDInvalid);
    else if (!isPasswordValid)
      buildPopup(failedToSignInPopup, passwordInvalid);
    else
      signIn();
  }

  void validateSignUp1() {
    if (!isUserIDValid)
      buildPopup(failedToSignUpPopup, userIDInvalid);
    else if (!isPasswordValid)
      buildPopup(failedToSignUpPopup, passwordInvalid);
    else if (!isConfirmValid)
      buildPopup(failedToSignUpPopup, confirmInvalid);
    else if (!isNameValid)
      buildPopup(failedToSignUpPopup, nameInvalid);
    else if (!isPhoneValid)
      buildPopup(failedToSignUpPopup, phoneInvalid);
    else if (!isAddressValid)
      buildPopup(failedToSignUpPopup, addressInvalid);
    else if (!isSchoolValid)
      buildPopup(failedToSignUpPopup, schoolInvalid);
    else if (!isWorkplaceValid)
      buildPopup(failedToSignUpPopup, workplaceInvalid);
    else
      authState.value = AuthState.SignUp_2;
  }

  void validateSignUp2() {
    if (!isIntroductionValid)
      buildPopup(failedToSignUpPopup, introductionInvalid);
    else if (!isPartnerOtherValid)
      buildPopup(failedToSignUpPopup, partnerOtherInvalid);
    else if (media['face1'] == null)
      buildPopup(failedToSignUpPopup, face1Invalid);
    else if (media['face2'] == null)
      buildPopup(failedToSignUpPopup, face2Invalid);
    else if (media['body1'] == null)
      buildPopup(failedToSignUpPopup, body1Invalid);
    else if (media['body2'] == null)
      buildPopup(failedToSignUpPopup, body2Invalid);
    else if (media['video'] == null)
      buildPopup(failedToSignUpPopup, videoInvalid);
    else
      authState.value = AuthState.SignUp_3;
  }
  
  void validateSignUp3(BuildContext context) {
    if (parent.value != Parent.Mother && !isFatherJobValid)
      buildPopup(failedToSignUpPopup, fatherJobInvalid);
    else if (parent.value != Parent.Father && !isPartnerOtherValid)
      buildPopup(failedToSignUpPopup, motherJobInvalid);
    else if (!isPartnerOtherValid)
      buildPopup(failedToSignUpPopup, parentAddressInvalid);
    else
      signUp(context);
  }

  Future<void> checkUserID() async {
    try {
      var available = await UserService.checkUserID(userID.text);
      userIDCheckStatus.value = available ? UserIDCheckState.Available : UserIDCheckState.Exist ;
    } catch (e) {
      await buildPopup(failedToSignInPopup, '$e');
    }
  }

  Future<void> sendCode() async {
    phoneCheckStatus.value = PhoneCheckState.Sent;
  }

  Future<void> verifyCode() async {
    phoneCheckStatus.value = PhoneCheckState.Verified;
  }

  // Future<void> pickBirthday(BuildContext context) async {
  //   var picked = await showDatePicker(
  //     context: context, 
  //     initialDate: birthday.value, 
  //     firstDate: DateTime(1960), 
  //     lastDate: DateTime(2000)
  //   );
  //   if (picked != null)
  //     birthday.value = picked;
  // }

  void addSibling() {
    siblings.add([TextEditingController(), TextEditingController(), TextEditingController()]);
  }

  void removeSibling(int index) {
    siblings.removeAt(index);
  }

  Future<void> openAlbum(String label) async {
    final ImagePicker picker = ImagePicker();
    XFile? picked;
    if (label == 'video')
      picked = await picker.pickVideo(source: ImageSource.gallery);
    else
      picked = await picker.pickImage(source: ImageSource.gallery);
    
    if (picked != null)
      media[label] = picked.path;
  }

  Future<void> signIn() async {
    try {
      if (await AuthService.signin(userID.text, password.text))
        Get.off(() => RootPage());
      else
        authState.value = AuthState.Complete;
    } catch (e) {
      await buildPopup(failedToSignInPopup, '$e');
    }
  }

  Future<void> signUp(BuildContext context) async {
    try {
      showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator(color: mainColor)), barrierDismissible: false);
      var parentString = parent.value.literal + ',' + fatherJob.text + ',' + motherJob.text + ',' + parentAddress.text;
      var siblingString = '$brother남 $sister녀 중 $yourself째,';
      for (var sibling in siblings) {
        siblingString += '${sibling[0].text},${sibling[1].text},${sibling[2].text},';
      }
      var user = User(
        userID: userID.text, name: name.text, phone: phone.text, gender: gender.value.text == '1' ? Gender.Male : Gender.Female, marriage: marriage.value, 
        birthday: birthday.value.text, area: area.value, address: address.text, scholar: scholar.value, school: school.text, job: job.value,
        workplace: workplace.text, salary: salary.value, asset: asset.value, realestate: realestate, vehicle: vehicle,
        height: height.value, weight: weight.value, bodyType: bodyType.value, character: character.value, smoke: smoke.value,
        religion: religion.value, longDistance: longDistance.value, wedding: wedding.value, introduction: introduction.text,
        partnerMarriage: partnerMarriage.value, partnerAge: partnerAge.value, partnerHeight: partnerHeight.value, 
        partnerScholar: partnerScholar.value, partnerJob: partnerJob, partnerSalary: partnerSalary.value, 
        partnerAsset: partnerAsset.value, partnerBodyType: partnerBodyType, partnerCharacter: partnerCharacter,
        partnerSmoke: partnerSmoke.value, partnerOther: partnerOther.text, parent: parentString, sibling: siblingString
      );
      var validMedia = <String, String>{};
      for (var key in media.keys) {
        var value = media[key];
        if (value != null)
          validMedia[key] = value;
      }
      var response = await AuthService.signup(user, password.text, validMedia);
      Get.back();
      if (response.isEmpty)
        authState.value = AuthState.Complete;
      else
        await buildPopup(failedToSignUpPopup, response);
    } catch (e) {
      Get.back();
      await buildPopup(failedToSignUpPopup, '$e');
    }
  }
}

class AuthPage extends StatelessWidget {
  final controller = Get.put(AuthController());
  
  Widget get leading {
    switch (controller.authState.value) {
      case AuthState.SignUp_2: 
        return IconButton(color: mainColor, icon: Icon(Icons.arrow_back_ios), onPressed: controller.showSignUp,);
      case AuthState.SignUp_3: 
        return IconButton(color: mainColor, icon: Icon(Icons.arrow_back_ios), onPressed: controller.validateSignUp1,);
      default: return Text('');
    }
  }

  String get title {
    switch (controller.authState.value) {
      case AuthState.SignIn:
      case AuthState.Complete: return '';
      default: return '회원가입';
    }
  }

  Widget body(BuildContext context) {
    switch (controller.authState.value) {
      case AuthState.SignIn: return buildSignIn();
      case AuthState.SignUp_1: return buildSignUp1(context);
      case AuthState.SignUp_2: return buildSignUp2();
      case AuthState.SignUp_3: return buildSignUp3(context);
      case AuthState.Complete: return buildComplete();
    }
  }

  Widget buildSignIn() => ListView(
    children: [
      Text(''),
      Column(
        children: [
          Text('매칭 브릿지', style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center),
          Divider(height: 32, color: Colors.transparent,),
          buildTextField(controller: controller.userID, hint: '아이디를 입력해 주세요.', radius: 8),
          Divider(height: 16, color: Colors.transparent,),
          buildTextField(controller: controller.password, hint: '비밀번호 입력해 주세요.', radius: 8, obscure: true),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: Text('비밀번호를 잊으셨나요?', style: TextStyle(color: greyColor)))),
          Divider(height: 16, color: Colors.transparent,),
          buildButton(
            child: Text('로그인', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
            color: mainColor,
            onPressed: controller.validateSignIn
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
      TextButton(onPressed: controller.showSignUp, child: Row(children: [
        Text('아직 가입하지 않으셨나요? ', style: TextStyle(color: greyColor)),
        Text('회원가입', style: TextStyle(color: mainColor))
      ], mainAxisAlignment: MainAxisAlignment.center,))
    ],
    padding: EdgeInsets.all(20),
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
  );

  Widget buildAddressCandidate(String address) => GestureDetector(
    child: Padding(
      child: Row(
        children: [
          Flexible(child: Text(address)),
          if (address == controller.address.text)
            Icon(Icons.check, color: okColor)
        ], 
        mainAxisAlignment: MainAxisAlignment.spaceBetween
      ), 
      padding: EdgeInsets.all(12)
    ),
    onTap: () => controller.onSelectAddress(address),
  );

  Widget buildSignUp1(BuildContext context) => ListView(
    children: [
      buildLabelTextField('아이디', controller: controller.userID, hint: '8~16자', radius: 8, focus: controller.userFocus),
      if (controller.userIDCheckStatus.value != UserIDCheckState.Unchecked)
        Divider(height: 8, color: Colors.transparent,),
      if (controller.userIDCheckStatus.value == UserIDCheckState.Available)
        Text(userIDAvailable, style: TextStyle(color: okColor)),
      if (controller.userIDCheckStatus.value == UserIDCheckState.Exist)
        Text(userIDExist, style: TextStyle(color: warningColor)),
      Divider(height: 16, color: Colors.transparent,),
      buildLabelTextField('비밀번호', controller: controller.password, hint: '8~16자', obscure: true, radius: 8),
      Divider(height: 16, color: Colors.transparent,),
      buildLabelTextField('비밀번호 확인', controller: controller.confirm, hint: '비밀번호를 다시 입력해 주세요.', obscure: true, radius: 8),
      Divider(height: 32, color: Colors.transparent,),
      buildLabelTextField('이름', controller: controller.name, hint: '실명을 입력해 주세요.', radius: 8),
      Divider(height: 16, color: Colors.transparent,),
      Row(
        children: [
          Flexible(child: Text('주민등록번호', style: TextStyle(color: greyColor, fontSize: 14)), flex: 1),
          Flexible(
            child: Row(
              children: [
                Flexible(child: buildTextField(
                  controller: controller.birthday, hint: '생년월일', keyboardType: TextInputType.number, radius: 8, length: 6
                ), flex: 2),
                Text('  -  '),
                Flexible(child: buildTextField(
                  controller: controller.gender, hint: '첫글자', keyboardType: TextInputType.number, radius: 8, length: 1
                ), flex: 1),
                Text('  ●●●●●●')
              ]
            ), flex: 3
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween
      ),
      Divider(height: 16, color: Colors.transparent,),
      if (controller.phoneCheckStatus.value != PhoneCheckState.Verified)
        buildLabelTextField('핸드폰 번호', controller: controller.phone, hint: '-를 제외하고 입력해 주세요.', keyboardType: TextInputType.phone, radius: 8)
      else
        Row(children: [
          Text('핸드폰 번호', style: TextStyle(color: greyColor, fontSize: 14)),
          Row(children: [Text(controller.phone.text), Icon(Icons.check, color: okColor)])
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween,),
      Divider(height: 16, color: Colors.transparent,),
      Row(
        children: [
          if (controller.phoneCheckStatus.value == PhoneCheckState.Sent)
            Flexible(child: buildTextField(hint: '인증코드', keyboardType: TextInputType.number, radius: 8)),
          if (controller.phoneCheckStatus.value == PhoneCheckState.Unsent)
            buildButton(child: Text('인증번호 전송', style: TextStyle(color: Colors.white),), color: mainColor, margin: EdgeInsets.only(left: 8), onPressed: controller.sendCode),
          if (controller.phoneCheckStatus.value == PhoneCheckState.Sent)
            buildButton(child: Text('인증', style: TextStyle(color: Colors.white),), color: mainColor, margin: EdgeInsets.only(left: 8), onPressed: controller.verifyCode),
        ], mainAxisAlignment: MainAxisAlignment.end,
      ),
      Divider(height: 16, color: Colors.transparent,),
      // buildLabelDropdown<Gender>('성별', 
      //   (gender) => controller.gender.value = gender ?? controller.gender.value, 
      //   controller.gender.value,
      //   Gender.values.map((e) => DropdownMenuItem(
      //     child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
      //   )).toList(), 
      // ),
      // Divider(height: 16, color: Colors.transparent,),
      buildLabelDropdown<Marriage>('결혼경험 유무', 
        (marriage) => controller.marriage.value = marriage ?? controller.marriage.value,
        controller.marriage.value,
        Marriage.values.where((e) => e != Marriage.Pass).map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList(), 
      ),
      // Divider(color: Colors.transparent, height: 16),
      // Row(
      //   children: [
      //     Flexible(child: Text('생일', style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
      //     Flexible(
      //       child: buildButton(
      //         child: Text(DateFormat('yyyy년 MM월 dd일').format(controller.birthday.value), style: TextStyle(color: Colors.white)), 
      //         color: mainColor, 
      //         onPressed: () => controller.pickBirthday(context)), 
      //       flex: 3
      //     )
      //   ],
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween
      // ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Area>('지역', 
        (area) => controller.area.value = area ?? controller.area.value,
        controller.area.value,
        Area.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList(), 
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelTextField('주소', controller: controller.address, hint: '주소', keyboardType: TextInputType.streetAddress, radius: 8),
      Divider(color: Colors.transparent, height: 4),
      Container(
        child: Column(children: controller.addressCandidate.map<Widget>((e) => buildAddressCandidate(e)).toList(), crossAxisAlignment: CrossAxisAlignment.start,),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), offset: Offset(0, 3), blurRadius: 3)],
          color: Colors.white,
        ),
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Scholar>('학력', 
        (scholar) => controller.scholar.value = scholar ?? controller.scholar.value, 
        controller.scholar.value,
        Scholar.values.where((e) => e != Scholar.Pass).map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList(),
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelTextField('학교 정보', controller: controller.school, hint: '학교, 캠퍼스, 전공 등', radius: 8),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Job>('직업', 
        (job) => controller.job.value = job ?? controller.job.value, 
        controller.job.value,
        Job.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelTextField('회사 정보', controller: controller.workplace, hint: '회사명, 근무지역, 근무형태 등', radius: 8),
      Divider(color: Colors.transparent, height: 16),
      buildLabelSlider('연봉\n${controller.salary.value}백만원', controller.salary.value, Range(A: 0, B: 200), (salary) => controller.salary.value = salary),
      Divider(color: Colors.transparent, height: 16),
      buildLabelSlider('자산\n${controller.asset.value}백만원', controller.asset.value, Range(A: 0, B: 500), (asset) => controller.asset.value = asset),
      Divider(color: Colors.transparent, height: 16),
      buildLabelStringList('부동산', '주소 입력', controller.realestate, 5, (realestate) => controller.realestate.add(realestate), (index) => controller.realestate.removeAt(index)),
      Divider(color: Colors.transparent, height: 16),
      buildLabelStringList('차량', '차종 입력', controller.vehicle, 5, (vehicle) => controller.vehicle.add(vehicle), (index) => controller.vehicle.removeAt(index)),
      Divider(color: Colors.transparent, height: 16),
      buildLabelSlider('키\n${controller.height}cm', controller.height.value, Range(A: 130, B: 200), (height) => controller.height.value = height),
      Divider(color: Colors.transparent, height: 16),
      buildLabelSlider('몸무게\n${controller.weight}kg', controller.weight.value, Range(A: 8, B: 120), (weight) => controller.weight.value = weight),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<BodyType>('체형', 
        (bodyType) => controller.bodyType.value = bodyType ?? controller.bodyType.value, 
        controller.bodyType.value,
        BodyType.values.map((e) => DropdownMenuItem(
          child: Text(controller.gender.value == Gender.Male ? e.literalMale : e.literalFemale, style: TextStyle(color: greyColor, fontSize: 12)), 
          value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Character>('성격', 
        (character) => controller.character.value = character ?? controller.character.value, 
        controller.character.value,
        Character.values.map((e) => DropdownMenuItem(
          child: Text(controller.gender.value == Gender.Male ? e.literalMale : e.literalFemale, style: TextStyle(color: greyColor, fontSize: 12)), 
          value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Smoke>('흡연여부', 
        (smoke) => controller.smoke.value = smoke ?? controller.smoke.value,
        controller.smoke.value, 
        Smoke.values.where((e) => e != Smoke.Pass).map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Religion>('종교', 
        (religion) => controller.religion.value = religion ?? controller.religion.value,
        controller.religion.value, 
        Religion.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelToggle('장거리 여부', value: controller.longDistance.value, onToggle: (longDistance) => controller.longDistance.value = longDistance),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Wedding>('희망 결혼시기', 
        (wedding) => controller.wedding.value = wedding ?? controller.wedding.value,
        controller.wedding.value, 
        Wedding.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildButton(
        child: Text('다음', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
        color: mainColor, 
        onPressed: controller.validateSignUp1,
        padding: EdgeInsets.symmetric(horizontal: 20)
      ),
      Divider(height: 16, color: Colors.transparent,),
      TextButton(onPressed: controller.showSignIn, child: Row(children: [
        Text('이미 가입하셨나요? ', style: TextStyle(color: greyColor)),
        Text('로그인', style: TextStyle(color: mainColor))
      ], mainAxisAlignment: MainAxisAlignment.center,))
    ],
    padding: EdgeInsets.all(20),
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
  );

  Widget buildSignUp2() => ListView(
    children: [
      Column(
        children: [
          LayoutBuilder(builder: (context, constraints) => SizedBox.fromSize(
            child: Obx(() => ListView(
              children: controller.media.keys.map((e) => Padding(
                child: GestureDetector(child: buildProfile(e, path: controller.media[e], width: 100, height: 100), onTap: () => controller.openAlbum(e)),
                padding: EdgeInsets.symmetric(horizontal: e.contains('2') ? 16 : 0)
              )).toList(),
              padding: EdgeInsets.only(bottom: 16),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
            )),
            size: Size(constraints.maxWidth, 142),
          )),
          Divider(color: Colors.transparent, height: 16),
          buildLabelTextField('자기소개', controller: controller.introduction, hint: '상대방에게 전할 메시지를 적어주세요.', maxLines: 5),
          Divider(color: Colors.transparent, height: 16),
          buildLabelDropdown<Marriage>('상대방 결혼경험 유무', 
            (partnerMarriage) => controller.partnerMarriage.value = partnerMarriage ?? controller.partnerMarriage.value,
            controller.marriage.value,
            Marriage.values.map((e) => DropdownMenuItem(
              child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
            )).toList(), 
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelRangeSlider('상대방 나이\n${controller.partnerAge.value.min}세~${controller.partnerAge.value.max}세', controller.partnerAge.value, Range(A: 20, B: 50), (partnerAge) => controller.partnerAge.value = partnerAge),
          Divider(color: Colors.transparent, height: 16),
          buildLabelRangeSlider('상대방 키\n${controller.partnerHeight.value.min}cm~${controller.partnerHeight.value.max}cm', controller.partnerHeight.value, Range(A: 130, B: 200), (partnerHeight) => controller.partnerHeight.value = partnerHeight),
          Divider(color: Colors.transparent, height: 16),
          buildLabelDropdown<Scholar>('상대방 학력', 
            (scholar) => controller.partnerScholar.value = scholar ?? controller.partnerScholar.value, 
            controller.partnerScholar.value,
            Scholar.values.where((e) => e != Scholar.Pass).map((e) => DropdownMenuItem(
              child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
            )).toList(),
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelEnumList<Job>('상대방 직업', '', controller.partnerJob, Job.values, Job.Normal, 5, (e) => e.literal, (job) => controller.partnerJob.add(job), (index) => controller.partnerJob.removeAt(index)),
          Divider(color: Colors.transparent, height: 16),
          buildLabelRangeSlider('상대방 연봉\n${controller.partnerSalary.value.min}백만원~${controller.partnerSalary.value.max}백만원', controller.partnerSalary.value, Range(A: 0, B: 200), (partnerSalary) => controller.partnerSalary.value = partnerSalary),
          Divider(color: Colors.transparent, height: 16),
          buildLabelRangeSlider('상대방 자산\n${controller.partnerAsset.value.min}백만원~${controller.partnerAsset.value.max}백만원', controller.partnerAsset.value, Range(A: 0, B: 500), (partnerAsset) => controller.partnerAsset.value = partnerAsset),
          Divider(color: Colors.transparent, height: 16),
          buildLabelEnumList<BodyType>('상대방 체형', 
            '', controller.partnerBodyType, BodyType.values, BodyType.Body1, 5, 
            (e) => controller.gender.value.text == '1' ? e.literalFemale : e.literalMale, 
            (partnerBodyType) => controller.partnerBodyType.add(partnerBodyType), (index) => controller.partnerBodyType.removeAt(index)
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelEnumList<Character>('상대방 성격', 
            '', controller.partnerCharacter, Character.values, Character.Character1, 5, 
            (e) => controller.gender.value.text == '1' ? e.literalFemale : e.literalMale, 
            (partnerCharacter) => controller.partnerCharacter.add(partnerCharacter), (index) => controller.partnerCharacter.removeAt(index)
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelDropdown<Smoke>('상대방 흡연여부', 
            (smoke) => controller.smoke.value = smoke ?? controller.smoke.value,
            controller.smoke.value, 
            Smoke.values.map((e) => DropdownMenuItem(
              child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
            )).toList()
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelTextField('기타', controller: controller.partnerOther, hint: '성격, 취미, 취향 등 이상형에 대해 자세히 적어주세요.', maxLines: 5),
        ]
      ),
      Divider(height: 16, color: Colors.transparent,),
      buildButton(
        child: Text('다음', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
        color: mainColor, 
        onPressed: controller.validateSignUp2,
        padding: EdgeInsets.symmetric(horizontal: 20)
      ),
    ],
    padding: EdgeInsets.all(20),
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
  );

  Widget buildSignUp3(BuildContext context) => ListView(
    children: [
      buildLabelDropdown<Parent>('부모님 여부', 
        (parent) => controller.parent.value = parent ?? controller.parent.value,
        controller.parent.value,
        Parent.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList(), 
      ),
      Divider(height: 16, color: Colors.transparent,),
      if (controller.parent.value != Parent.Mother)
        buildLabelTextField('아버지 직업', controller: controller.fatherJob, radius: 8),
      if (controller.parent.value != Parent.Mother)
        Divider(height: 16, color: Colors.transparent,),
      if (controller.parent.value != Parent.Father)
        buildLabelTextField('어머니 직업', controller: controller.motherJob, radius: 8),
      if (controller.parent.value != Parent.Father)
        Divider(height: 16, color: Colors.transparent,),
      buildLabelTextField('부모님 주거지역', controller: controller.parentAddress, radius: 8),
      Divider(height: 16, color: Colors.transparent,),
      Text('형제자매 여부', style: TextStyle(color: greyColor, fontSize: 14)),
      Divider(height: 4, color: Colors.transparent,),
      Row(
        children: [
          Flexible(child: buildDropdown(
            DropdownButton<int>(
              items: List.generate(5, (index) => index).map<DropdownMenuItem<int>>((e) => DropdownMenuItem(child: Text('$e남'), value: e)).toList(),
              value: controller.brother.value,
              onChanged: (value) => controller.brother.value = value ?? controller.brother.value
            ),
          )),
          Flexible(child: buildDropdown(
            DropdownButton<int>(
              items: List.generate(5, (index) => index).map<DropdownMenuItem<int>>((e) => DropdownMenuItem(child: Text('$e녀'), value: e)).toList(),
              value: controller.sister.value,
              onChanged: (value) => controller.sister.value = value ?? controller.sister.value
            ),
          )),
          Text('  중'),
          Flexible(child: buildDropdown(
            DropdownButton<int>(
              items: List.generate(10, (index) => index + 1).map<DropdownMenuItem<int>>((e) => DropdownMenuItem(child: Text('$e째'), value: e)).toList(),
              value: controller.yourself.value,
              onChanged: (value) => controller.yourself.value = value ?? controller.yourself.value
            ),
          )),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      Divider(height: 8, color: Colors.transparent,),
      for (var index = 0; index < controller.siblings.length; index++)
        Padding(
          child: Row(
            children: [
              Flexible(child: buildTextField(controller: controller.siblings[index][0], hint: '직업', radius: 8)),
              SizedBox(width: 8),
              Flexible(child: buildTextField(controller: controller.siblings[index][1], hint: '결혼여부', radius: 8)),
              SizedBox(width: 8),
              Flexible(child: buildTextField(controller: controller.siblings[index][2], hint: '주소', radius: 8)),
              GestureDetector(child: Icon(Icons.close), onTap: () => controller.removeSibling(index)),
            ]
          ), 
          padding: EdgeInsets.all(8)
        ),
      Row(
        children: [
          buildButton(
            child: Text('추가', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            color: mainColor, onPressed: controller.addSibling)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      Divider(height: 16, color: Colors.transparent,),
      buildButton(
        child: Text('완료', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
        color: mainColor, 
        onPressed: () => controller.validateSignUp3(context),
        padding: EdgeInsets.symmetric(horizontal: 20)
      ),
    ],
    padding: EdgeInsets.all(20),
    physics: ClampingScrollPhysics(),
    shrinkWrap: true,
  );

  Widget buildComplete() => Padding(
    child: Column(
      children: [
        Text(''),
        Text('현재 심사중입니다.', style: TextStyle(color: mainColor, fontSize: 14, fontWeight: FontWeight.bold)),
        buildButton(
          child: Text('돌아가기', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
          color: mainColor, 
          onPressed: controller.showSignIn,
          padding: EdgeInsets.symmetric(horizontal: 20)
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ),
    padding: EdgeInsets.all(20),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor, 
        centerTitle: true,
        elevation: 0,
        leading: Obx(() => leading),
        title: Obx(() => Text(title, style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 20)))
      ),
      backgroundColor: backgroundColor,
      body: Container(
        alignment: Alignment.center,
        color: backgroundColor,
        child: Obx(() => body(context)),
        width: double.infinity,
      ),
    );
  }
}