import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/controller.dart';

class AboutScreen extends StatelessWidget {
  static const routename = "/AboutScreen";

  var _controller = Get.put(Controller());

  Future<void> _launchURL(context, link) async {
    try {
      var url = Uri.parse(link);
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("oops!!! Something Wrong"),
          ),
        );
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About the Developer'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/app_icon.png", width: 100),
                SizedBox(height: 20),

                // todo : name
                Text(
                  'MAHADUM AKBAR BASIL',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Kayal Pray Developer',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),

                // todo : contact information
                Text(
                  'Contact Information:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                // todo : email
                Text(
                  'basilpublicmail@gmail.com',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20),

                // todo : about
                Text(
                  'About the App:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                // todo : description
                Text(
                  'This app helps you stay on top of your daily prayer times. Never miss a prayer again with timely notifications and a user-friendly interface.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                // todo : get the app
                ElevatedButton(
                  onPressed: () async {
                    StoreRedirect.redirect(
                      androidAppId: "${_controller.appPackageName.value}",
                    );
                  },
                  child: Text('Get the App'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // todo : linked in profile
                Container(
                  height: 40,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      _launchURL(context, 'https://www.linkedin.com/in/akbarbasil/');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(FontAwesomeIcons.linkedin),
                        Text('LinkedIn Profile'),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
