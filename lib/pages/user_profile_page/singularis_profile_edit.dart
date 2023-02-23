import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/widget.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

import '../../utils/LocationManager.dart';
import '../custom_pages/alert_widgets/alerts_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController =
      TextEditingController(text: Preference.getString(Preference.FIRST_NAME));
  final headController = TextEditingController(
      text: Preference.getString(Preference.USER_HEADLINE));
  final countryController = TextEditingController(
      text: Preference.getString(Preference.LOCATION)?.split(',')[1]);
  final cityController = TextEditingController(
      text: Preference.getString(Preference.LOCATION)?.split(',').first);
  final aboutController =
      TextEditingController(text: Preference.getString(Preference.ABOUT_ME));
  bool addingProfile = false;
  final _formKey = GlobalKey<FormState>();

  late double lat = 0.0;
  late double long = 0.0;

  @override
  void initState() {
    LocationManager.initLocationService().then((value) {
      setState(() {
        lat = value!.latitude!;
        long = value.longitude!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.WHITE,
        body: ScreenWithLoader(
          isLoading: addingProfile,
          body: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async {
                if (state is AddProfolioProfileState) {
                  handleAddProfileResponse(state);
                }
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                      child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                "Edit Profile",
                                style: Styles.bold(
                                    size: 14, color: Color(0xff0E1638)),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Full Name*",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              validate: true,
                              validationString: 'Please enter full name',
                              controller: nameController,
                              hintText: 'Full Name'),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Headline*",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                              validate: true,
                              validationString: 'Please enter headline',
                              maxChar: 30,
                              controller: headController,
                              hintText: 'Write your headlline'),
                          Text(
                            "Location",
                            style: Styles.bold(size: 14),
                          ),
                          InkWell(
                            onTap: () async {
                              try {
                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(lat, long);
                                print('${placemarks.first.country}');
                                print('${placemarks.first.locality}');

                                //countryController.text = placemarks.first.country.toString();
                                //cityController.text = placemarks.first.locality.toString();

                                AlertsWidget.showCustomDialog(
                                    context: context,
                                    title: 'Current Location',
                                    text: 'Use Your Current Location',
                                    icon: 'assets/images/circle_alert_fill.svg',
                                    onOkClick: () async {
                                      countryController.text =
                                          placemarks.first.country.toString();
                                      cityController.text =
                                          placemarks.first.locality.toString();
                                    });
                              } catch (e) {
                                print(':::: ${e.toString()}');
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset('assets/images/location.svg'),
                                SizedBox(
                                  width: 10,
                                ),
                                GradientText(
                                    child: Text(
                                  "Use current location",
                                  style: TextStyle(fontSize: 12),
                                ))
                              ],
                            ),
                          ),
                          Text(
                            "Country*",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                              validate: true,
                              validationString: 'Please enter country',
                              controller: countryController,
                              hintText: 'Enter your Country'),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "City*",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                              validate: true,
                              validationString: 'Please enter city',
                              controller: cityController,
                              hintText: 'Enter your City'),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "About me*",
                            style: Styles.regular(
                                size: 14, color: Color(0xff0E1638)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                              validate: true,
                              validationString: 'Please enter about yourself',
                              controller: aboutController,
                              maxLine: 10,
                              maxChar: 220,
                              hintText: 'Tell something about yourself'),
                          PortfolioCustomButton(clickAction: () {
                            if (_formKey.currentState!.validate()) {
                              Map<String, dynamic> data = Map();
                              data['name'] = nameController.value.text;
                              data['headline'] = headController.value.text;
                              data['country'] = countryController.value.text;
                              data['city'] = cityController.value.text;
                              data['about_me'] = aboutController.value.text;
                              print(data);
                              addProfile(data);
                            }
                          })
                        ]),
                  )),
                ),
              )),
        ));
  }

  void addProfile(Map<String, dynamic> data) {
    BlocProvider.of<HomeBloc>(context)
        .add(AddPortfolioProfileEvent(data: data));
  }

  void handleAddProfileResponse(AddProfolioProfileState state) {
    setState(() {
      switch (state.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          addingProfile = true;

          break;
        case ApiStatus.SUCCESS:
          Log.v("Add Profile State....................");
          addingProfile = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Profile updated Successfully '),
          ));

          Navigator.pop(context);

          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error CompetitionListIDState ..........................${state.error}");
          addingProfile = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}
