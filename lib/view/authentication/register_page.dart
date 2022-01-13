import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qchat/core/components/clipper/custom_clipper.dart';
import 'package:qchat/core/components/text/custom_text_widget.dart';
import 'package:qchat/core/components/textFormField/custom_text_form_field_widget.dart';
import 'package:qchat/core/constants/app/app_colors.dart';
import 'package:qchat/core/constants/navigation/navigation_constant.dart';
import 'package:qchat/core/extensions/context_extension.dart';
import 'package:qchat/core/extensions/string_extension.dart';
import 'package:qchat/core/init/navigation/navigation_service.dart';
import 'package:qchat/core/init/services/fb_auth_service.dart';
import 'package:qchat/core/validations/validations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  NavigationService navigation = NavigationService.instance;

  TextEditingController? _nameController = TextEditingController();
  TextEditingController? _passwordController = TextEditingController();
  final TextEditingController? _emailController = TextEditingController();
  FocusNode? _nameFocus;
  FocusNode? _emailFocus;
  FocusNode? _passwordFocus;
  final formKey = GlobalKey<FormState>();
  final FBAuthService? _fbAuthService = FBAuthService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailFocus!.dispose();
    _passwordFocus!.dispose();
    _emailController!.dispose();
    _passwordController!.dispose();

    super.dispose();
  }

  fieldFocusChange(
      BuildContext? context, FocusNode? currentFocus, FocusNode? nextFocus) {
    // currentFocus!.unfocus();
    // FocusScope.of(context!).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      backgroundColor: AppColors.white,
      bottomNavigationBar: _footer(),
    );
  }

  Widget _footer() {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 8,
                    color: AppColors.primary,
                  )),
              GestureDetector(
                onTap: () {
                  navigation.navigateToPage(
                    path: NavigationConstants.loginPage,
                  );
                },
                child: CustomTextWidget(
                  text: 'Sign In',
                  textStyle: TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w800,
                  ).smallStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: MyClipper3(),
                  child: Container(
                    height: 380,
                    decoration: BoxDecoration(color: AppColors.appYellow),
                  ),
                ),
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(color: AppColors.primary),
                  ),
                ),
                ClipPath(
                  clipper: MyClipper2(),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(color: AppColors.secondary),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.mediumValue),
                      CustomTextFormFieldWidget(
                        hintText: "Name",
                        initialValue: "",
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => {},
                        focusNode: _nameFocus,
                        onFieldSubmitted:
                            fieldFocusChange(context, _nameFocus, _emailFocus),
                        onSaved: (value) => {},
                        validate: (value) =>
                            CustomValidator().nickNameValidate(value!),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: context.mediumValue,
                      ),
                      CustomTextFormFieldWidget(
                        hintText: "E-mail",
                        initialValue: "",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => {},
                        focusNode: _emailFocus,
                        onFieldSubmitted: fieldFocusChange(
                            context, _emailFocus, _passwordFocus),
                        onSaved: (value) => {},
                        validate: (value) =>
                            CustomValidator().emailValidate(value!),
                        readOnly: false,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: context.mediumValue,
                      ),
                      CustomTextFormFieldWidget(
                        hintText: "Password",
                        initialValue: "",
                        obscureText: true,
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => {},
                        focusNode: _passwordFocus,
                        onFieldSubmitted: fieldFocusChange(
                            context, _passwordFocus, _passwordFocus),
                        onSaved: (value) => {},
                        validate: (value) =>
                            CustomValidator().passwordValidate(value!),
                        readOnly: false,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: context.mediumValue,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: 'Sign Up',
                            textStyle: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w800,
                            ).largeStyle,
                            textAlign: TextAlign.center,
                          ),
                          GestureDetector(
                            onTap: () {
                              _fbAuthService!
                                  .signUp(
                                      context,
                                      _nameController!.text,
                                      _emailController!.text,
                                      _passwordController!.text)
                                  .then((value) {
                                if (value != null) {
                                  navigation.navigateToPageClear(
                                      path: NavigationConstants.homePage);
                                }
                              });
                            },
                            child: ClipOval(
                              clipBehavior: Clip.hardEdge,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration:
                                    BoxDecoration(color: AppColors.secondary),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: -30,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            child: SvgPicture.asset(
              "4".toSVG,
            ),
          ),
        ),
      ],
    );
  }
}
