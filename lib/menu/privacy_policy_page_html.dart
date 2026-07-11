import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../common/swipe_to_back.dart';

/*
flutter_widget_from_html: ^0.15.0 #widget, code html
Chú ý cho code bên trong thẻ HtmlWidget và trong thẻ lại chứa code trong 2 lần dấu ''':
HtmlWidget( ''' <code> ''' )
 */

// void main() => runApp(MyApp());

class PrivacyPolicyPageHtml extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwipeToBack(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Privacy Policy & Contact', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            backgroundColor: Colors.green,
          ),
          body: const Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
      
                //HtmlWidget
                child: HtmlWidget(
                  '''
                  <!DOCTYPE html>
                  <html>
                  <head>
                    <meta charset='utf-8'>
                    <meta name='viewport' content='width=device-width'>
                    <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
                  </head>
                  <body>
                  <strong>Privacy Policy Falun Dafa Practice Supports</strong> <p>
                    Falun Dafa Practice Supports built the  app as
                    (free / ad-supported / buy in the application) app. This SERVICE is provided by
                    Falun Dafa Practice Supports and is intended for use as is.
                  </p> <p>
                    This page is used to inform visitors regarding our
                    policies with the collection, use, and disclosure of Personal
                    Information if anyone decided to use our Service.
                  </p> <p>
                    If you choose to use our Service, then you agree to
                    the collection and use of information in relation to this
                    policy. 
                    </p>
                   <p><strong>Information Collection and Use</strong></p> <p>
                      We do not collect personal data (full name, address, contact information, email, phone number, image, ... Personal documents any other)
                    <p>
                    The information that
                    we request will be retained on your device and is not collected by us in any way.</p>
                    <p>Applications can collect data used such as: Login time, usage status ...</p>
                  </p> <div><p>
                      The app does use third-party services that may collect
                      information used to identify you.
                    </p> <p>
                      Link to the privacy policy of third-party service providers used
                      by the app
                    </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----></ul></div> <p><strong>Log Data</strong></p> <p>
                    We want to inform you that whenever you
                    use our Service, in a case of an error in the app
                    We collect data and information (through third-party
                    products) on your phone called Log Data. This Log Data may
                    include information such as your device Internet Protocol
                    (“IP”) address, device name, operating system version, the
                    configuration of the app when utilizing [my/our] Service,
                    the time and date of your use of the Service, and other
                    statistics.
                  </p>
      
                  <p><strong>Service Providers</strong></p> <p>
                    We may employ third-party companies and
                    individuals due to the following reasons:
                  </p> <ul><li>To facilitate our Service;</li> <li>To provide the Service on our behalf;</li> <li>To perform Service-related services; or</li> <li>To assist us in analyzing how our Service is used.</li></ul> <p>
                    We want to inform users of this Service
                    that these third parties have access to their Personal
                    Information. The reason is to perform the tasks assigned to
                    them on our behalf. However, they are obligated not to
                    disclose or use the information for any other purpose.
                  </p> <p><strong>Security</strong></p> <p>
                    We value your trust in providing us your
                    Personal Information, thus we are striving to use commercially
                    acceptable means of protecting it. But remember that no method
                    of transmission over the internet, or method of electronic
                    storage is 100% secure and reliable, and We cannot
                    guarantee its absolute security.
                  </p> <p><strong>Links to Other Sites</strong></p> <p>
                    This Service may contain links to other sites. If you click on
                    a third-party link, you will be directed to that site. Note
                    that these external sites are not operated by us.
                    Therefore, We strongly advise you to review the
                    Privacy Policy of these websites. We have
                    no control over and assume no responsibility for the content,
                    privacy policies, or practices of any third-party sites or
                    services.
                  </p> <p><strong>Children’s Privacy</strong></p> <div><p>
                      These Services do not address anyone under the age of 13.
                      We do not knowingly collect personally
                      identifiable information from children under 13 years of age. In the case
                      We discover that a child under 13 has provided
                      us with personal information, We immediately
                      delete this from our servers. If you are a parent or guardian
                      and you are aware that your child has provided us with
                      personal information, please contact me so that
                      We will be able to do the necessary actions.
                    </p></div> <!----> <p><strong>Changes to This Privacy Policy</strong></p> <p>
                      We may update our Privacy Policy from
                    time to time. Thus, you are advised to review this page
                    periodically for any changes. We will
                    notify you of any changes by posting the new Privacy Policy on
                    this page.
                  </p> 
                  <p>This policy is effective as of 2024-06-01</p>
                  <p><strong>Contact Us</strong></p> 
                  <p> If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact me at</p>
                  <p>Email: minhviet.dragon@gmail.com</p> 
                  <p>This privacy policy page was created at <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>and modified/generated by <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
                  </body>
                  </html>
                  ''',
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}