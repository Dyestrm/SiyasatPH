<h1 align="center" style="font-size:28px; line-height:1"><b>SiyasatPH</b></h1>
<div align="center">
    <img alt="Icon" src="assets\images\siyasat_logo.png" width="150px" >
</div>

<br />

<div align="center">
    <img alt="iOS App Store Badge" src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" height="50px">
    <img alt="Google Play Badge" src="https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" height="50px">
    <img alt="GitHub Badge" src="https://img.shields.io/badge/firebase-a08021?style=for-the-badge&logo=firebase&logoColor=ffcd34" height="50px">
</div>

<br />

**SiyasatPH** is a smishing detection app designed to protect vulnerable Filipino elders from fraudulent SMS messages. It instantly analyzes incoming texts and classifies them as Safe, Suspicious, or Likely Scam. The app features family notifications, one-click reporting to the NTC, message history tracking, and a modern user-friendly interface. Built during the 2026 InterCICSkwela Hackathon.

## Table of Contents
- [About the Project](#about-the-project)
- [Features](#features)
- [Installation and Setup](#installation-and-setup)
- [Usage](#usage)
- [Development](#development)
  
## About the Project
Smishing attacks in the Philippines are becoming increasingly difficult to detect. Fake messages impersonating banks like BDO and GCash now appear in the same SMS threads as legitimate ones, using identical formatting and fraudulent links. Filipino elders are the main targets, not because they are careless, but because they lack exposure to these convincing fakes. Research shows the SIM Registration Act has not fixed these vulnerabilities. Human behavior and knowledge gaps remain the primary reasons these attacks succeed. **SiyasatPH** addresses this through seven features.

### Features
- **SMS Analyzer** — Instantly classifies messages as <span style="color: #D6F0F0;">**Safe**</span>, <span style="color: #FDF5E0;">**Suspicious**</span>, or <span style="color: #FFE4E4;">**Likely Scam**</span>
- **URL Analysis** — Detects lookalike and phishing domains
- **Red Flag Explainer** — Clearly identifies risks in Filipino and English
- **Family Setup** — Personalizes protection settings for elders
- **Urgency Detection** — Flags manipulative and high-pressure language
- **Family Alerts** — Automatically notifies trusted contacts when a scam is detected
- **History Log** — Complete record of all analyzed messages for easy review
  
## Installation and Setup
**SiyasatPH** is a completed prototype and is not yet published on the Google Play Store or Apple App Store.

You can easily run the app on your own machine or build an APK to test it on any Android phone.

### 1. Pre-requisites
- Flutter SDK 3.41.4 or higher
- Android Studio 
- Git
- Android phone or Android emulator for testing
  
### 2. Clone the Repository
```Bash
git clone https://github.com/Dyestrm/SiyasatPH.git siyasat-ph
cd siyasat-ph
flutter pub get
```

### 3. Asset Configuration
Make sure these files are listed in the project's `pubspec.yaml`:
```YAML
assets:
  - assets/scam_patterns.json
  - assets/spam_patterns.json
  - assets/verified_domains.json
  - assets/images/
```

### 4. Run the App
If you are using an android emulator, you can skip the following steps, but if you are using an android phone for testing:
- Turn on developer options > USB debugging
- Plug-in your phone to your desktop/laptop

Run:
```Bash
flutter run
```

## Usage
1. Open the app and allow notifactions permission
2. Navigate through the onboarding process
3. Setup an account or skip the process
4. Navigate to 'Suriin', paste a sample message then press the 'Suriin' button. 
5. Follow the following depending on the flag type:
    1. <span style="color: #D6F0F0;">**Ligtas**</span> – Press the button that appears to go back 
    2. <span style="color: #FDF5E0;">**Kahina-hinala**</span> – Press the 'Sabihan ang Pamilya' to notify registered family members 
	3. <span style="color: #FFE4E4;">**Posibleng Scam**</span> – Press the 'I-report sa NTC' to check the auto-filled form details
6. Navigate to 'Kasaysayan' to view the history of analyzed messages
7. Navigate to 'Setup' to view profiles and family members

## Development Team
- Alido, Mary Dawn (Frontend Developer)
- Beunavista, Lyra Bellah (Frontend Developer)
- Ramos, Michael John (Backend Developer)
- Reyes, Joseph Junel (Project Manager)
- Panganiban, John Mark (Backend Developer)