# **Outfitters App**

A Flutter application for Outfitters brand that use shopify store to sell their goods. Outfitters is a ecommerce application that help users to buy their products. Shopify is a flexible platform enable anyone to easily integrate every app in their stack so automate any business process. Shopify is a complete ecommerce store that provide many advantages. 

## Product Description

The purpose of the system is to provide many range of products to their customers. Provide product details and also provide support to the customers. Each module performs a seprate function within the application that helps customers to easily connect with the store by using this app. Thes Modules are:
  - Display Products
  - Add Product to the cart
  - Update Cart
  - Delete Cart
  - Order Processing
  - Add Product To Wish List
  - Login/Signin
  - Registration/Signup
  - Customer Services

## Getting Started

These instruction will get you a copy of the project up and running on your local machine for development and testing purpose. See deployment for notes on how to deploy the project on a live system.

- **Minimum Sysrem Requirements**
  - Operating System: Window 7 or later [64-bit]/ MAC
  - Disk Size 500 MB
  - Git for Windows/Git for MAC
  - Get the flutter SDK
  - Download lates Flutter SDK for Windows/MAC
  - Unzip the download zip in folder
  - Locale flutter_console.bat inside the flutter directory and start it by double-clicking
  
-  **Update your path**
    - From the start search bar, type '**env**' and select edit enviroment variables for your account
    - Under User variable check if there is any entry called '**Path:**'
    - If the user entry does not exist, append the full path to flutter\bin using ; as a seprator from existing values.
    - If the enry doest not exist, create a new varibale named path with the pull path tp flutter\bin as its value.
- **Run Flutter Doctor**    
   - This command checks your enviroment and displays a report of the status of your Flutter installation, 
      - Windows : C:\flutter>flutter doctor
      - MAC : /UserName> flutter doctor 
   
- **Android Setup**
   - Flutter relies on a full installation of Android Studio to supply its Android platform dependencies. However, you can write your Flutter apps in a number of editors.
   - Install Android Studio
   - Download and install Android Studio.
   - Start Android Studio, and go through the Android Studio Setup Wizard. This installs the latest Android SDK, Android SDK Platform-Tools, and Android SDK Build-Tools, which are required by Flutter when developing for Android.
   
     - **Install the Flutter and Dart plugins**
        - Start Android Studio.
        - Open plugin preferences (File > Settings > Plugins).
        - Select Browse repositories, select the Flutter plugin and click Install.
        - Click Yes when prompted to install the Dart plugin.
        - Click Restart when prompted
  # **How to Use**
 - ## **Step 1:-** 
  Download or clone this repo by using the link below: 
 
- [https://github.com/alche2014/outfitters-ecommerce-flutterApp.git](https://github.com/alche2014/outfitters-ecommerce-flutterApp.git)
  
- ## **Step 2:-** 
   - Go to project root and execute the following command in console to get the required dependencies:
   - Use `flutter` Command
   - 
  ```dart
  flutter pub get
  ``` 

- ## **Step 3:-** 
   - This project uses inject library that works with code generation, execute the following command to generate files:
   - Use `flutter` Command
   - 
  ```dart
  flutter packages pub run build_runner build --delete-conflicting-outputs
  ``` 
   or watch command in order to keep the source code synced automatically:
   ```dart
  flutter packages pub run build_runner watch
  ``` 
## **Libraries**
 
  - [flutter_swiper](https://pub.dev/packages/flutter_swiper)





## **Technical Requirements**
  - An editor like Android Studio, IntelliJ IDEA Community or Visual Studio Code
  - Flutter SDK - then run flutter doctor and update your path
  - Xcode
  - Android Studio
## **Product Modules**
  - Display Products
  - Add Product to the cart
  - Update Cart
  - Delete Cart
  - Order Processing
  - Add Product To Wish List
  - Login/Signin
  - Registration/Signup
  - Customer Services
## **Folder Structure**
Here is the core folder structure which flutter provides.
  - flutter-app/
  - |- [android](android/)
  - |- [build](build/)
  - |- [ios](ios/)
  - |- [lib](lib/)
  - |- [test](test/)

Here is the folder structure we have been using in this project
   - |- [main.dart](lib/main.dart)
   - [lib](lib/)
             
        
   
  
  ## **Release Your Flutter App for iOS and Android**
  - **For IOS**
    - **Prerequisites**
       - Make sure that you've covered Apple's guidelines for releasing an app on the app store.
       - Have your app's icons and launch screens ready. 
       - Have an Apple Developer account.
         - ## **Prepare for building**
            -  Open the App IDs page.
            -  Click + to create a new Bundle ID.
            -  Fill out the needed information: App Name, and Explicit App ID.
            -  If your app needs specific services, select them and click Continue.
            -  Review the details and click Register to finish.
            -  Now that we have a unique bundle ID, it's time to set up a place for your app on the App Store Connect. Log in to the App Store Connect.
            -  Select My Apps.
            -  Click + then select New App.
            -  Fill in your app details and make sure iOS is selected, then click Create.
            -  From the sidebar, select App Information.
            -  In the General Information section, select the Bundle ID that you registered above.
    
    
         - ## **Adjust Xcode project settings for release**
           You've set everything up from Apple's side, and next you'll adjust your Xcode project's settings to prepare your app for release. Go ahead and fire up Xcode.

           - Open [Runner.xcworkspace](ios/Runner.xcworkspaces) that is inside your app's iOS folder.
           - From the Xcode project navigator, select the Runner project.
           - Then, select the Runner target in the main view sidebar.
           - Go to the General tab.
           - In the Identity section, fill out the information and make sure the Bundle Identifier is the one registered on App Store Connect.
           - In the Signing section, make sure Automatically manage signing is checked and select your team.
           - Fill out the rest of the information as needed.
           - Next, you'll update your app's icon. This can be done by selecting [Assets.xcassets](ios/Runner/Assets.xcassets/AppIcon.appiconset) in the Runner folder from Xcode's project navigator.
         - ## **Build and upload your app** 
           At this point, all the settings have been updated for release and there is a placeholder ready on App Store Connect, which means you can build and release. 
            - From the command line, `run`
   
           ```dart
            flutter build ios
           ```
         - Then go back to Xcode and reopen Runner.xcworkspace
         - Select Product -> **Scheme** -> **Runner**.
         - Select Product -> **Destination** -> **Generic iOS** Device.
         - Select Product -> Archive to produce a build archive.
         - From the Xcode Organizer window, select your iOS app from the sidebar, then select the build archive you just produced.
         - Click the Validate button to build.
         - Once the archive is successfully validated, click Upload to App Store.
         - Back on App Store Connect, check the status of your build from the Activities tab. Once it's ready to release:
         - Go to Pricing and Availability and fill out the required information.
         - From the sidebar, select the status.
         - Select Prepare for Submission and complete all required fields.
         - Click Submit for Review.
     - ## **IOS SCREENSHOOTS**
       <table>
       <tr>
      
       </tr>

      
       </table>
       
        
     
 - **For Android Release**
   - **Prerequisites**
       - Have an Android app ready for release.
       - Add a launcher icon and have all your app's assets ready.
       
         - ## **Prepare for release** 
           - Before you can publish your Flutter app to Google Play, the app needs a digital signature.
           - If you don�t already have a keystore, create one
           - On Windows, use the following command:
             ``` dart 
             keytool -genkey -v -keystore c:/Users/USER_NAME/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
             ``` 
            - On IOS, use the following command:
             ``` dart 
             keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
             ```  
            - Create a file named /android/key.properties that is empty:
            - Add this.
             ```dart
             storePassword=<password from previous step>
             keyPassword=<password from previous step>
             keyAlias=key
             storeFile=<location of the key store file, such as /Users/<user name>/key.jks>
              ```  
            - **Configure signing in Gradle**
             You will find your Gradle file at /android/app/build.gradle. Start editing and follow these steps: 

            - **Replace**
              ```java
               android {    
                //   With the keystore information that we just created:
                    created:
                     def keystoreProperties = new Properties()
                     def keystorePropertiesFile = rootProject.file('key.properties')
                     if (keystorePropertiesFile.exists()) {
                    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
                      }
               } 

        - **Then, Replace**
             ``` java
               buildTypes {
                 release {
                 // TODO: Add your own signing config for the release build.
                // Signing with the debug keys for now,
                // so `flutter run --release` works.
                signingConfig signingConfigs.debug
                 }
                   }
        - **With the signing configuration info:**
             ``` java
               signingConfigs {
                release {
                keyAlias keystoreProperties['keyAlias']
                keyPassword keystoreProperties['keyPassword']
                storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
                storePassword keystoreProperties['storePassword']
                    }
                        }
                buildTypes {
                release {
                signingConfig signingConfigs.release
                    }
                    }

    - Then, go to the defaultConfig block.
    - Enter a final unique applicationId.
    - Give your app a versionName and versionCode.
    - Specify the minimum SDK API level that the app needs to run.
    - You have now configured your app's Gradle file and your release builds will be signed automatically.
    - Review the app manifest and make sure everything is ready
    - The file AndroidManifest.xml will be located in /android/app/src/main. Open it and review the values and permissions you need before building.      
  - **Build and release the app**
  Now you'll build your app's APK so it can be uploaded to the Google Play Store. Go to your command line and follow these steps: 
   - Enter cd   
   - Run flutter build apk
   - If everything goes well, you will have an APK ready at /build/app/outputs/apk/release/app.apk
   - ## **IOS SCREENSHOOTS**


       