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
      var siblingString = '$brother??? $sister??? ??? $yourself???,';
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
      default: return '????????????';
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
          Text('?????? ?????????', style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center),
          Divider(height: 32, color: Colors.transparent,),
          buildTextField(controller: controller.userID, hint: '???????????? ????????? ?????????.', radius: 8),
          Divider(height: 16, color: Colors.transparent,),
          buildTextField(controller: controller.password, hint: '???????????? ????????? ?????????.', radius: 8, obscure: true),
          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: Text('??????????????? ????????????????', style: TextStyle(color: greyColor)))),
          Divider(height: 16, color: Colors.transparent,),
          buildButton(
            child: Text('?????????', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
            color: mainColor,
            onPressed: controller.validateSignIn
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
      TextButton(onPressed: controller.showSignUp, child: Row(children: [
        Text('?????? ???????????? ???????????????? ', style: TextStyle(color: greyColor)),
        Text('????????????', style: TextStyle(color: mainColor))
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
      buildLabelTextField('?????????', controller: controller.userID, hint: '8~16???', radius: 8, focus: controller.userFocus),
      if (controller.userIDCheckStatus.value != UserIDCheckState.Unchecked)
        Divider(height: 8, color: Colors.transparent,),
      if (controller.userIDCheckStatus.value == UserIDCheckState.Available)
        Text(userIDAvailable, style: TextStyle(color: okColor)),
      if (controller.userIDCheckStatus.value == UserIDCheckState.Exist)
        Text(userIDExist, style: TextStyle(color: warningColor)),
      Divider(height: 16, color: Colors.transparent,),
      buildLabelTextField('????????????', controller: controller.password, hint: '8~16???', obscure: true, radius: 8),
      Divider(height: 16, color: Colors.transparent,),
      buildLabelTextField('???????????? ??????', controller: controller.confirm, hint: '??????????????? ?????? ????????? ?????????.', obscure: true, radius: 8),
      Divider(height: 32, color: Colors.transparent,),
      buildLabelTextField('??????', controller: controller.name, hint: '????????? ????????? ?????????.', radius: 8),
      Divider(height: 16, color: Colors.transparent,),
      Row(
        children: [
          Flexible(child: Text('??????????????????', style: TextStyle(color: greyColor, fontSize: 14)), flex: 1),
          Flexible(
            child: Row(
              children: [
                Flexible(child: buildTextField(
                  controller: controller.birthday, hint: '????????????', keyboardType: TextInputType.number, radius: 8, length: 6
                ), flex: 2),
                Text('  -  '),
                Flexible(child: buildTextField(
                  controller: controller.gender, hint: '?????????', keyboardType: TextInputType.number, radius: 8, length: 1
                ), flex: 1),
                Text('  ??????????????????')
              ]
            ), flex: 3
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween
      ),
      Divider(height: 16, color: Colors.transparent,),
      if (controller.phoneCheckStatus.value != PhoneCheckState.Verified)
        buildLabelTextField('????????? ??????', controller: controller.phone, hint: '-??? ???????????? ????????? ?????????.', keyboardType: TextInputType.phone, radius: 8)
      else
        Row(children: [
          Text('????????? ??????', style: TextStyle(color: greyColor, fontSize: 14)),
          Row(children: [Text(controller.phone.text), Icon(Icons.check, color: okColor)])
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween,),
      Divider(height: 16, color: Colors.transparent,),
      Row(
        children: [
          if (controller.phoneCheckStatus.value == PhoneCheckState.Sent)
            Flexible(child: buildTextField(hint: '????????????', keyboardType: TextInputType.number, radius: 8)),
          if (controller.phoneCheckStatus.value == PhoneCheckState.Unsent)
            buildButton(child: Text('???????????? ??????', style: TextStyle(color: Colors.white),), color: mainColor, margin: EdgeInsets.only(left: 8), onPressed: controller.sendCode),
          if (controller.phoneCheckStatus.value == PhoneCheckState.Sent)
            buildButton(child: Text('??????', style: TextStyle(color: Colors.white),), color: mainColor, margin: EdgeInsets.only(left: 8), onPressed: controller.verifyCode),
        ], mainAxisAlignment: MainAxisAlignment.end,
      ),
      Divider(height: 16, color: Colors.transparent,),
      // buildLabelDropdown<Gender>('??????', 
      //   (gender) => controller.gender.value = gender ?? controller.gender.value, 
      //   controller.gender.value,
      //   Gender.values.map((e) => DropdownMenuItem(
      //     child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
      //   )).toList(), 
      // ),
      // Divider(height: 16, color: Colors.transparent,),
      buildLabelDropdown<Marriage>('???????????? ??????', 
        (marriage) => controller.marriage.value = marriage ?? controller.marriage.value,
        controller.marriage.value,
        Marriage.values.where((e) => e != Marriage.Pass).map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList(), 
      ),
      // Divider(color: Colors.transparent, height: 16),
      // Row(
      //   children: [
      //     Flexible(child: Text('??????', style: TextStyle(color: greyColor, fontSize: 14)), flex: 1,),
      //     Flexible(
      //       child: buildButton(
      //         child: Text(DateFormat('yyyy??? MM??? dd???').format(controller.birthday.value), style: TextStyle(color: Colors.white)), 
      //         color: mainColor, 
      //         onPressed: () => controller.pickBirthday(context)), 
      //       flex: 3
      //     )
      //   ],
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween
      // ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Area>('??????', 
        (area) => controller.area.value = area ?? controller.area.value,
        controller.area.value,
        Area.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList(), 
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelTextField('??????', controller: controller.address, hint: '??????', keyboardType: TextInputType.streetAddress, radius: 8),
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
      buildLabelDropdown<Scholar>('??????', 
        (scholar) => controller.scholar.value = scholar ?? controller.scholar.value, 
        controller.scholar.value,
        Scholar.values.where((e) => e != Scholar.Pass).map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList(),
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelTextField('?????? ??????', controller: controller.school, hint: '??????, ?????????, ?????? ???', radius: 8),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Job>('??????', 
        (job) => controller.job.value = job ?? controller.job.value, 
        controller.job.value,
        Job.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelTextField('?????? ??????', controller: controller.workplace, hint: '?????????, ????????????, ???????????? ???', radius: 8),
      Divider(color: Colors.transparent, height: 16),
      buildLabelSlider('??????\n${controller.salary.value}?????????', controller.salary.value, Range(A: 0, B: 200), (salary) => controller.salary.value = salary),
      Divider(color: Colors.transparent, height: 16),
      buildLabelSlider('??????\n${controller.asset.value}?????????', controller.asset.value, Range(A: 0, B: 500), (asset) => controller.asset.value = asset),
      Divider(color: Colors.transparent, height: 16),
      buildLabelStringList('?????????', '?????? ??????', controller.realestate, 5, (realestate) => controller.realestate.add(realestate), (index) => controller.realestate.removeAt(index)),
      Divider(color: Colors.transparent, height: 16),
      buildLabelStringList('??????', '?????? ??????', controller.vehicle, 5, (vehicle) => controller.vehicle.add(vehicle), (index) => controller.vehicle.removeAt(index)),
      Divider(color: Colors.transparent, height: 16),
      buildLabelSlider('???\n${controller.height}cm', controller.height.value, Range(A: 130, B: 200), (height) => controller.height.value = height),
      Divider(color: Colors.transparent, height: 16),
      buildLabelSlider('?????????\n${controller.weight}kg', controller.weight.value, Range(A: 8, B: 120), (weight) => controller.weight.value = weight),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<BodyType>('??????', 
        (bodyType) => controller.bodyType.value = bodyType ?? controller.bodyType.value, 
        controller.bodyType.value,
        BodyType.values.map((e) => DropdownMenuItem(
          child: Text(controller.gender.value == Gender.Male ? e.literalMale : e.literalFemale, style: TextStyle(color: greyColor, fontSize: 12)), 
          value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Character>('??????', 
        (character) => controller.character.value = character ?? controller.character.value, 
        controller.character.value,
        Character.values.map((e) => DropdownMenuItem(
          child: Text(controller.gender.value == Gender.Male ? e.literalMale : e.literalFemale, style: TextStyle(color: greyColor, fontSize: 12)), 
          value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Smoke>('????????????', 
        (smoke) => controller.smoke.value = smoke ?? controller.smoke.value,
        controller.smoke.value, 
        Smoke.values.where((e) => e != Smoke.Pass).map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Religion>('??????', 
        (religion) => controller.religion.value = religion ?? controller.religion.value,
        controller.religion.value, 
        Religion.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildLabelToggle('????????? ??????', value: controller.longDistance.value, onToggle: (longDistance) => controller.longDistance.value = longDistance),
      Divider(color: Colors.transparent, height: 16),
      buildLabelDropdown<Wedding>('?????? ????????????', 
        (wedding) => controller.wedding.value = wedding ?? controller.wedding.value,
        controller.wedding.value, 
        Wedding.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList()
      ),
      Divider(color: Colors.transparent, height: 16),
      buildButton(
        child: Text('??????', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
        color: mainColor, 
        onPressed: controller.validateSignUp1,
        padding: EdgeInsets.symmetric(horizontal: 20)
      ),
      Divider(height: 16, color: Colors.transparent,),
      TextButton(onPressed: controller.showSignIn, child: Row(children: [
        Text('?????? ??????????????????? ', style: TextStyle(color: greyColor)),
        Text('?????????', style: TextStyle(color: mainColor))
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
          buildLabelTextField('????????????', controller: controller.introduction, hint: '??????????????? ?????? ???????????? ???????????????.', maxLines: 5),
          Divider(color: Colors.transparent, height: 16),
          buildLabelDropdown<Marriage>('????????? ???????????? ??????', 
            (partnerMarriage) => controller.partnerMarriage.value = partnerMarriage ?? controller.partnerMarriage.value,
            controller.marriage.value,
            Marriage.values.map((e) => DropdownMenuItem(
              child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
            )).toList(), 
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelRangeSlider('????????? ??????\n${controller.partnerAge.value.min}???~${controller.partnerAge.value.max}???', controller.partnerAge.value, Range(A: 20, B: 50), (partnerAge) => controller.partnerAge.value = partnerAge),
          Divider(color: Colors.transparent, height: 16),
          buildLabelRangeSlider('????????? ???\n${controller.partnerHeight.value.min}cm~${controller.partnerHeight.value.max}cm', controller.partnerHeight.value, Range(A: 130, B: 200), (partnerHeight) => controller.partnerHeight.value = partnerHeight),
          Divider(color: Colors.transparent, height: 16),
          buildLabelDropdown<Scholar>('????????? ??????', 
            (scholar) => controller.partnerScholar.value = scholar ?? controller.partnerScholar.value, 
            controller.partnerScholar.value,
            Scholar.values.where((e) => e != Scholar.Pass).map((e) => DropdownMenuItem(
              child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
            )).toList(),
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelEnumList<Job>('????????? ??????', '', controller.partnerJob, Job.values, Job.Normal, 5, (e) => e.literal, (job) => controller.partnerJob.add(job), (index) => controller.partnerJob.removeAt(index)),
          Divider(color: Colors.transparent, height: 16),
          buildLabelRangeSlider('????????? ??????\n${controller.partnerSalary.value.min}?????????~${controller.partnerSalary.value.max}?????????', controller.partnerSalary.value, Range(A: 0, B: 200), (partnerSalary) => controller.partnerSalary.value = partnerSalary),
          Divider(color: Colors.transparent, height: 16),
          buildLabelRangeSlider('????????? ??????\n${controller.partnerAsset.value.min}?????????~${controller.partnerAsset.value.max}?????????', controller.partnerAsset.value, Range(A: 0, B: 500), (partnerAsset) => controller.partnerAsset.value = partnerAsset),
          Divider(color: Colors.transparent, height: 16),
          buildLabelEnumList<BodyType>('????????? ??????', 
            '', controller.partnerBodyType, BodyType.values, BodyType.Body1, 5, 
            (e) => controller.gender.value.text == '1' ? e.literalFemale : e.literalMale, 
            (partnerBodyType) => controller.partnerBodyType.add(partnerBodyType), (index) => controller.partnerBodyType.removeAt(index)
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelEnumList<Character>('????????? ??????', 
            '', controller.partnerCharacter, Character.values, Character.Character1, 5, 
            (e) => controller.gender.value.text == '1' ? e.literalFemale : e.literalMale, 
            (partnerCharacter) => controller.partnerCharacter.add(partnerCharacter), (index) => controller.partnerCharacter.removeAt(index)
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelDropdown<Smoke>('????????? ????????????', 
            (smoke) => controller.smoke.value = smoke ?? controller.smoke.value,
            controller.smoke.value, 
            Smoke.values.map((e) => DropdownMenuItem(
              child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
            )).toList()
          ),
          Divider(color: Colors.transparent, height: 16),
          buildLabelTextField('??????', controller: controller.partnerOther, hint: '??????, ??????, ?????? ??? ???????????? ?????? ????????? ???????????????.', maxLines: 5),
        ]
      ),
      Divider(height: 16, color: Colors.transparent,),
      buildButton(
        child: Text('??????', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
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
      buildLabelDropdown<Parent>('????????? ??????', 
        (parent) => controller.parent.value = parent ?? controller.parent.value,
        controller.parent.value,
        Parent.values.map((e) => DropdownMenuItem(
          child: Text(e.literal, style: TextStyle(color: greyColor, fontSize: 12)), value: e
        )).toList(), 
      ),
      Divider(height: 16, color: Colors.transparent,),
      if (controller.parent.value != Parent.Mother)
        buildLabelTextField('????????? ??????', controller: controller.fatherJob, radius: 8),
      if (controller.parent.value != Parent.Mother)
        Divider(height: 16, color: Colors.transparent,),
      if (controller.parent.value != Parent.Father)
        buildLabelTextField('????????? ??????', controller: controller.motherJob, radius: 8),
      if (controller.parent.value != Parent.Father)
        Divider(height: 16, color: Colors.transparent,),
      buildLabelTextField('????????? ????????????', controller: controller.parentAddress, radius: 8),
      Divider(height: 16, color: Colors.transparent,),
      Text('???????????? ??????', style: TextStyle(color: greyColor, fontSize: 14)),
      Divider(height: 4, color: Colors.transparent,),
      Row(
        children: [
          Flexible(child: buildDropdown(
            DropdownButton<int>(
              items: List.generate(5, (index) => index).map<DropdownMenuItem<int>>((e) => DropdownMenuItem(child: Text('$e???'), value: e)).toList(),
              value: controller.brother.value,
              onChanged: (value) => controller.brother.value = value ?? controller.brother.value
            ),
          )),
          Flexible(child: buildDropdown(
            DropdownButton<int>(
              items: List.generate(5, (index) => index).map<DropdownMenuItem<int>>((e) => DropdownMenuItem(child: Text('$e???'), value: e)).toList(),
              value: controller.sister.value,
              onChanged: (value) => controller.sister.value = value ?? controller.sister.value
            ),
          )),
          Text('  ???'),
          Flexible(child: buildDropdown(
            DropdownButton<int>(
              items: List.generate(10, (index) => index + 1).map<DropdownMenuItem<int>>((e) => DropdownMenuItem(child: Text('$e???'), value: e)).toList(),
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
              Flexible(child: buildTextField(controller: controller.siblings[index][0], hint: '??????', radius: 8)),
              SizedBox(width: 8),
              Flexible(child: buildTextField(controller: controller.siblings[index][1], hint: '????????????', radius: 8)),
              SizedBox(width: 8),
              Flexible(child: buildTextField(controller: controller.siblings[index][2], hint: '??????', radius: 8)),
              GestureDetector(child: Icon(Icons.close), onTap: () => controller.removeSibling(index)),
            ]
          ), 
          padding: EdgeInsets.all(8)
        ),
      Row(
        children: [
          buildButton(
            child: Text('??????', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            color: mainColor, onPressed: controller.addSibling)
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      Divider(height: 16, color: Colors.transparent,),
      buildButton(
        child: Text('??????', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
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
        Text('?????? ??????????????????.', style: TextStyle(color: mainColor, fontSize: 14, fontWeight: FontWeight.bold)),
        buildButton(
          child: Text('????????????', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)), 
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