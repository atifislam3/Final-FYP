Personal Medicine Reminder App

 

Developed By:
Atif Islam (B.S CS Aut-2022-M-A-0006)
Muhammad Awais Ali (B.S CS Aut-2022-M-A-0024)

BS (Computer Science)

Supervised by:
Dr Abdul Mateen

Department of Computer Science
Federal Urdu University of Arts, Science and Technology
Islamabad

Session [2022-2026] 

PMRA

A project submitted to the Department of Computer Science as partial fulfilment of the requirement for the award of Degree of Bachelor of Science in Computer Science.

Name	Registration Number
Atif Islam	Aut-22-M-A-0006
Muhammad Awais Ali	Aut-22-M-A-0024



Supervisor

Dr. Abdul Mateen
Assistant Professor 
Department of Computer Science
Federal Urdu University of Arts, Science and Technology
Islamabad

Final Approval

It is certified that I have read the project report submitted by Atif Islam (B.S CS Aut-2022-M-A-0006) and Muhammad Awais Ali (B.S CS Aut-2022-M-A-0024) and it is our judgment that this project is of sufficient standard to warrant its acceptance by the FUUAST university, Islamabad for the Degree of Bachelor of Science in Computer Science.

Committee:
External Examiner	

Internal Examiner	

Mr. Khawaja Tahir Mahmood
Lecturer
Department of Computer Science
Federal Urdu University of Arts, Science and Technology
Islamabad

Supervisor
	

 Dr. Abdul Mateen
 Assistant Professor 
 Department of Computer Science
Federal Urdu University of Arts, Science and Technology Islamabad
Declaration

We hereby declare that this software, neither as a whole nor as a part has been copied out from any source. It is further declared that we have developed this software and the accompanied report entirely on the basis of our personal efforts. If any part of this project is proved to be copied out from any source or found to be reproduction of some other, we will stand by the consequences. No portion of the work presented has been submitted in support of any application for any other degree or qualification of this or any other university or institute of learning.


Atif Islam

Muhammad Awais Ali




Dedicated to our beloved parents,
Teachers
And
The fellows

Acknowledgement

Thanks to Almighty Allah for giving us knowledge, power and strength to accomplish this task. We learned a lot while doing this project and this will certainly help us in our forthcoming life. Many of our teachers helped us during this project but we are really thankful to our supervisor Dr. Abdul Mateen for his help and support in all phases of our project. His encouragement helped us a lot during times of difficulties. In the end we would like to say thanks to all of our friends for their support and encouragement.




Atif Islam

Muhammad Awais Ali

Project in Brief
Project Title	Personal Medicine Reminder App
Organization	Federal Urdu University of Arts, Science and Technology
Objectives	1. To develop a centralized mobile application that helps users manage their daily medication schedules through intelligent reminders and dose tracking.
2. To enable users to easily add, schedule, and monitor medicines with support for complex dosage routines including daily, interval-based, and cyclic schedules.
3. To provide comprehensive health management features including appointment tracking, health records, inventory control, wellness journaling, and AI-powered health assistance. 
4. To implement a reliable offline-first system interactive push notifications, analytics, and streak tracking to ensure consistent medication adherence and improved health outcomes. 
Undertaken By	Atif Islam
Muhammad Awais Ali
Supervised By	Dr. Abdul Mateen
Date Started	Feb 16, 2026
Date Completed	Jun 26, 2026
Technologies Used	•	Framework: Flutter (Dart) 
•	Backend & Auth: Firebase (Authentication, Realtime Database) 
•	Local Storage: Hive (Offline-First) 
•	State Management: GetX 
•	Notifications: flutter_local_notifications 
•	AI Assistant: Google Gemini API 
•	Charts: fl_chart 
•	Media: image_picker, file_picker 
System used	5th Gen Core i5 Processor @ 2.60 GHz, 8 GB RAM, 256 SSD
ABSTRACT
Personal Medicine Reminder App

In today's fast-paced world, managing personal health and medication schedules remains a critical yet often neglected responsibility for individuals dealing with chronic illnesses, multiple prescriptions, or complex dosage routines. Forgetting a dose, missing an appointment, or losing track of medicine inventory can lead to serious health consequences. The absence of a centralized, intelligent, and offline-capable health management tool leaves patients vulnerable to inconsistent care and poor health outcomes.
MedCare is a cross-platform mobile application built to bridge this gap by providing users with a comprehensive, all-in-one personal health companion that combines intelligent medicine reminders, appointment tracking, health record management, and AI-powered wellness features into a single, seamless experience.
A user registers or logs in via email/password or Google Sign-In, then lands on a dynamic dashboard displaying today's scheduled medicines and upcoming appointments. The medicine management module supports complex scheduling Daily, Specific Days, Interval-Based (every X days), and Cyclic (X days on, Y days off) with interactive push notifications featuring Take, Snooze, and Miss action buttons that work even when the app is killed. Each dose follows a structured lifecycle:Pending → Taken → Missed. The appointment module allows scheduling with configurable reminders, recurring frequencies, visit notes, and full history tracking.
Beyond reminders, MedCare includes an inventory control system with low-stock alerts, a wellness module with mood journaling, daily AI-generated challenges, and a visual streak tracker for medication adherence. An AI-powered chatbot assistant built on Google Gemini provides interactive health guidance with safety filters. Users can also upload and manage health documents, view analytics with adherence charts and missed dose reports, and maintain comprehensive health records including allergies, chronic illnesses, and dietary restraints all synced between local and cloud storage.
Built with Flutter (Dart) for a seamless cross-platform experience, Firebase (Authentication, Realtime Database) as the cloud backend, Hive for offline-first local storage, GetX for reactive state management, flutter_local_notifications for the reminder engine,and Google Gemini AI for intelligent health assistance, MedCare delivers a reliable, scalable, and user-friendly solution to empower individuals in taking complete control of their medication adherence and overall wellness.






Contents
CHAPTER#1: PROPOSAL	18
Revision History	19
1.1 Introduction	20
1.2 Problem Statement	20
1.3 Proposed System	21
1.4 Benefits of Proposed System	21
1.5 Scope of The Project	21
1.6 Survey Analysis	22
Table no 1.6.1. Survey Analysis	22
1.7 Module & Submodules	23
1.7.1 Authentication	23
1.7.2 Profile Management	24
1.7.3 Medicine Management	24
1.7.4 Schedule Management	24
1.7.5 User Health Records	24
1.7.6 Inventory Control	24
1.7.7 Appointment Management	24
1.7.8 Journaling & Motivation	25
1.7.9 Patient Report Management	25
1.7.10 ChatBot Assistant	25
1.7.11 Help & Support	25
1.7.12 Setting & Preferences	25
1.7.13 Analytics & Data Visualization	25
1.8 Primary Actor	25
1.9 Tools & Technologies	25
•	Back-End Tools	26
1.10 System Design Approach	26
1.11 Process Model Used	26
1.12 Limitations / Constraints	26
1.13 References	27
CHAPTER#2: ANALYSIS	28
Revision History	30
2.1 Introduction	30
2.1.1 Purpose	31
2.1.2 Scope	31
2.1.3 Definitions, Acronyms and Abbreviation	32
2.1.4 Overview	32
2.2 Functional Requirements	32
2.2.1 Authentication	32
2.2.2 Profile Management	35
2.2.3 Medicine Management	36
2.2.4 Schedule Management	38
2.2.5 User Health Records	38
2.2.6 Inventory Control	39
2.2.7 Appointment Management	39
2.2.8 Journaling & Motivation	40
2.2.9 Report Management	41
2.2.10 ChatBot Assistant	41
2.2.11 Help & Support	41
2.2.12 Settings & Preferences	42
2.2.13 Analytics & Data Visualization	42
2.3 Non-Functional Requirements	43
2.3.1 Performance:	43
2.3.2 Security:	43
2.3.3 Usability:	43
2.3.4 Reliability:	43
2.3.5 Availability:	43
2.3.6 Scalability:	43
2.3.7 Maintainability:	43
2.3.8 Compatibility:	43
2.3.9 Data Integrity:	44
2.3.10 Backup and Recovery:	44
2.4 Use Case Diagram	47
2.5 FULLY DRESSED USE CASES	52
CHAPTER # 3: DESIGN	129
3.1 System Sequence Diagram	132
SSD 01: Process SignIn	132
SSD 02: Process Login	132
SSD 03: Process Logout	133
SSD 04: Forget Password	133
SSD 05: Change Password	134
SSD 06: Process SocialLogin	134
SSD 07: View Profile	135
SSD 08: Update Profile	135
SSD 09: Manage Basic Health Information	135
SSD 10: Upload Profile Photo	136
SSD 11: Add Medicine	137
SSD 12: Update Medicine Details	137
SSD 13: Set Medicine Reminder	138
SSD 14: Disable Medicine Reminder	138
SSD 15: Categorize Medicine	139
SSD 16: View Calendar	139
SSD 17: View Daily Schedule	140
SSD 18: View Date Schedule	140
SSD 19: Apply Date Range Limitation	141
SSD 20: Add Allergies List	141
SSD 21: View Current Medication	142
SSD 22: View Past Medication	142
SSD 23: Add Restraints	143
SSD 24: Add Chronic Illnesses	143
SSD 25: View Current Stock	144
SSD 26: Update Current Stock	144
SSD 27: Generates Stock Alerts	145
SSD 28: Add Appointment	145
SSD 29: Update Appointment	146
SSD 30: Manage Appointment Categories/Status	146
SSD 31: Set Appointment Reminder	147
SSD 32: Add Visit Notes	147
SSD 33: View Appointment History	148
SSD 34: Record Mood & Notes Journal	148
SSD 35: Attempt User Challenges	149
SSD 36: Display Visual Streak Tracker	149
SSD 37: Add/Upload Report	150
SSD 38: Search Report	150
SSD 39: View Report	151
SSD 40: Access Chat Interface	151
SSD 41: Apply Safety Filters & Rules	152
SSD 42: View User Guide	152
SSD 43: Submit Contact & Feedback Form	153
SSD 44: View About Section	153
SSD 45: Change App Theme	154
SSD 46: Configure Notification Settings	154
SSD 47: Detect & Adjust Time Zone Automatically	155
SSD 48: View Medicine Consumption Reports	155
SSD 49: View Missed Doses Reports	156
SSD 50: Display Monthly Summary	156
SCHEMA DIAGRAM	157
3.2 Firebase (Realtime Database)	159
3.3 Hive	160
DOMAIN MODEL	162
3.4 Domain Model	164
CHAPTER # 4: CONSTRUCTION	165
4.1 Class Diagram	168
4.2 Project Code (Business Logic)	171
4.2.1 Authentication	171
4.2.2 Profile Management	176
4.2.3 Medicine Management	183
4.2.4 Schedule Management	190
4.2.5 User Health Records	194
4.2.6 Inventory Control	197
4.2.7 Appointment Management	199
4.2.8 Journaling & Motivation	202
4.2.9 Patient Report Management	205
4.2.10 ChatBot Assistant	208
4.2.11 Help & Support	211
4.2.12 Setting & Preferences	214
4.2.13 Analytics & Data Visualization	217
CHAPTER # 5: TESTING	221
5.1 Test Case	224
TC-01 Process SignIn	224
TC-02 Process Login	224
TC-03 Process Logout	225
TC-04 Forget Password	226
TC-05 Change Password	227
TC-06 Process SocialLogin	228
TC-07 View Profile	229
TC-08 Update Profile	230
TC-09 Manage Basic Health Information	231
TC-10 Upload Profile Photo	232
TC-11 Add Medicine	232
TC-12 Update Medicine Details	233
TC-13 Set Medicine Reminder	234
TC-14 Disable Medicine Alert	235
TC-15 Categorize Medicine	236
TC-16 View Calendar	237
TC-17 View Daily Schedule	238
TC-18 View Date Schedule	239
TC-19 Apply Date Range Limitation	239
TC-20 Add Allergies List	240
TC-21 View Current Medication	241
TC-22 View Past Medication	242
TC-23 Add Restraints	242
TC-24 Add Chronic Illnesses	243
TC-25 View Current Stock	244
TC-26 Update Current Stock	245
TC-27 Generate Stock Alerts	246
TC-28 Add Appointment	246
TC-29 Update Appointment	247
TC-30 Manage Appointment categories/Status	248
TC-31 Set Appointment Reminder	249
TC-32 Add Visit Notes	250
TC-33 View Appointment History	251
TC-34 Record Mood & Notes Journal	252
TC-35 Attempt User Challenges	253
TC-36 Display Visual Streak Tracker	253
TC-37 Add/Upload Report	254
TC-38 Search Report	255
TC-39 View Report	256
TC-40 Access Chat Interface	257
TC-41 Apply Safety Filters & Rules	258
TC-42 View User Guide	259
TC-43 Submit Contact/Feedback Form	259
TC-44 View About Section	260
TC-45 Change App Theme	261
TC-46 Configure Notification Settings	262
TC-47 Detect & Adjust Time Zone Automatically	263
TC-48 View Medicine Consumption Reports	264
TC-49 View Missed Doses Reports	265
TC-50 Display Monthly Summary	266
CHAPTER # 6:	267
USER MANUAL	267
6.1 Screen Shots	270
6.1.1 Splash Screen	270
6.1.2 SignIn Screen	271
6.1.3 Login Screen	272
6.1.4 Forgot Password Screen	273
6.1.5 Change password Screen	274
6.1.6 Home Dashboard Screen	275
6.1.7 Hub Screen	276
6.1.8 My Medicines (List & Stock) Screen	277
6.1.9 Add Medicine Screen	278
6.1.10 Update Medicine Screen	279
6.1.11 Medication History (Active) Screen:	280
6.1.12 Medication History (History) Screen	281
6.1.13 Appointments List Screen	282
6.1.14 New Appointment Screen	283
6.1.15 Edit Appointment Screen	284
6.1.16 Medical Archive Screen	285
6.1.17 Health Records (Vitals, Illnesses, Allergies) Screen	286
6.1.18 AI Health Assistant Screen	287
6.1.19 Health Analytics Screen	288
6.1.20 Wellness & Mood (Journal) Screen	289
6.1.21 Wellness & Mood (Motivation) Screen	290
6.1.22 Profile Screen	291
6.1.23 Edit Profile Screen	292
6.1.24 Settings Screen	293
6.1.25 Notification Sounds Screen	294
6.1.26 Help & Support Screen	295
6.2 User Manual	296
6.2.1 User Manual:	296
6.2.2 Sign In Screen	296
6.2.3 Sign Up Screen	296
6.2.4 Forgot Password Screen	297
6.2.5 Today Dashboard Screen	297
6.2.6 Add / Edit Medicine Screen	298
6.2.7 Calendar Schedule Screen	298
6.2.8 My Medicines (Inventory) Screen	298
6.2.9 Hub Screen	299
6.2.10 Health Records Screen	299
6.2.11 Appointment Management Screen	299
6.2.12 Wellness & Mood Screen	300
6.2.13 Medical Archive Screen	300
6.2.14 AI ChatBot Assistant Screen	300
6.2.15 Profile Management Screen	301
6.2.16 Analytics & Visualization Screen	301
6.2.17 Settings & Preferences Screen	301
6.2.18 Help & Support Screen	302






















CHAPTER#1: PROPOSAL
















PROJECT PROPOSAL
For
Personal Medicine Reminder
Version 1.1
Prepared By
Atif Islam
&
Muhammad Awais Ali
27th Nov, 2025





















Revision History
Version	Description	Author	Date

1.0	This is the Project Proposal for
Personal Medicine Reminder App	Atif Islam
&
Muhammad Awais Ali	
     6th October 2025


1.1	This is the Project Proposal for
Personal Medicine Reminder App	Atif Islam
&
Muhammad Awais Ali	
      27th  Nov,2025

















1.1 Introduction
Our client is a doctor working in a hospital where He/She often sees patients forget their medicines or struggle to manage multiple prescriptions. Since she does not have her own clinic, He/She deals with patients in the hospital environment and wants an easy solution that can help them take their medicines on time. To address this, we are developing an Android mobile application using Flutter, which will provide reminders, stock alerts, and health record management. A mobile app is chosen because smartphones are common and portable, making it easier for patients and caregivers to manage medicines anytime and anywhere.
1.2 Problem Statement
Right now, the client (doctor) does not have any special app or system for reminding patients about their medicines. Patients usually rely on paper prescriptions, memory, or basic phone alarms, which is not enough. Because of this, many patients forget their doses, get confused when using different medicines, or do not notice when their medicines are finished. Health records are also not managed properly, since most information is kept on paper and can be lost or forgotten. These problems cause patients to miss medicines, recover slowly, and create extra work for the doctor and caregivers.
1.3 Proposed System
The proposed system is an Android mobile application that will help patients take their medicines on time and manage their health more easily. The app will allow users to add their medicines, set reminders, and get notifications for every dose. It will also track medicine stock, give alerts for low quantity and store basic health information like allergies and prescriptions. Unlike simple alarm apps, this system will provide reports of medicine usage, show missed doses, and offer simple health tips to keep patients motivated. It will allow users to upload their medical reports for ease and also  allows user to add doctor appointment dates and reminders. The aim is to give patients an easy tool that makes medicine management simple, reliable, and effective.
1.4 Benefits of Proposed System
•	Reminds patients to take their medicines on time.
•	Reduces chances of forgetting or taking the wrong dose.
•	Helps manage many medicines at the same time.
•	Gives alerts when medicine stock is low.
•	Keeps health records safe and easy to access.
•	Provides simple reports about medicine usage and missed doses.
•	Easy design for elderly people and busy individuals.
•	Gives users quick help through a built-in chatbot.
•	Users can upload and store health-related reports within the application.
•	Users can schedule, edit, and set reminders for upcoming appointments.
1.5 Scope of The Project
The Personal Medicine Reminder Application will provide all the basic features needed to help patients   manage medicines and health records in one place. The system will allow users to add medicines, set reminders, get alerts for missed doses, and track medicine stock. It will also store important health details like allergies and prescriptions, and generate simple reports to check medicine usage.
This app is mainly designed for elderly people, patients with long-term illnesses, and busy individuals who often forget their medicines. 
In the future, the system can be improved with advanced features like wearable device integration, cloud backup, or connections with doctors and pharmacies. For now, the focus is on building a reliable, user-friendly Android app that makes medicine management simple and effective.
1.6 Survey Analysis
Table no 1.6.1. Survey Analysis
	My
Therapy	Mewdicate	Mediqation	Pill
Reminder	Cute
Pill	Proposed
System
System
Features
 						
User-Authentication		
 	
 	
 	
 	
Medicine
Management						
Profile
Management		
 
	
 	
 	
 	
Schedule
Management						
User
Health
Management	
 
	
 	
 	
 	
 
	
Inventory
Control		
 	
 	
 		
Analytics
& Data
Visualization		
 		
 	
 	
Setting
&
Preferences						
Appointment
Management		
 	
 	
 	
 	
Journaling
&
Motivation	
 	
 	
 
	
 
	
 
	
Patient
Report
Management	
 
	
 
	
 
	
 
	
 
	
ChatBot
Assistant		      
 
	
 
	
 	
 
	
Help
&
Support	
 
	
 	
 
	
 	
 
	
✔  (Check Mark): Indicates that the feature is available in the Application.
 X: Indicates that the feature is not available in the Application.
1.7 Module & Submodules
1.7.1 Authentication
•	SignIn(Register)
•	Login
•	Logout
•	Forget Password
•	Change Password
•	Social Login
1.7.2  Profile Management
•	View Profile
•	Update Profile
•	Basic Health Information
•	Upload Photo
1.7.3 Medicine Management
•	Add Medicine
•	Update/Edit Medicine
•	Medicine Reminder 
•	Remove/Disable Medicine Alert
•	Categorize Medicines (Tablets/Injections/etc.)
1.7.4   Schedule Management
•	Calendar View
•	Daily Schedule view
•	Date Schedule view
•	Date Range Limitation
1.7.5   User Health Records
•	Allergies list
•	Current Medications
•	Past Medications
•	Restraint
•	Chronic Illness 
1.7.6   Inventory Control
•	View Current Stock
•	Update Current Stock
•	Stock Alerts(Low Quantity)
1.7.7  Appointment Management
•	Add Appointment
•	Edit Appointment
•	Appointment Status
•	Appointment Reminder 
•	Visit Notes
•	Appointment History
1.7.8   Journaling & Motivation
•	Mood & Notes Journal
•	User Challenges
•	Visual Streak Tracker
1.7.9  Patient Report Management
•	Add/Upload Report
•	Search Report
•	View Report
1.7.10  ChatBot Assistant
•	Chat Interface
•	Safety Filters & Rules
1.7.11  Help & Support
•	User Guide
•	Contact/Feedback Form
•	About Section
1.7.12   Setting & Preferences
•	App Theme (Light/Dark)
•	Configure Notification Settings
•	Time Zone Detection
1.7.13 Analytics & Data Visualization 
•	Medicine Consumption Reports
•	Missed Doses Report
•	Monthly Summary(Charts)
1.8 Primary Actor  
•	User(Patient)
1.9 Tools & Technologies 
•	Front-End Tools 
o	Flutter (Dart)
o	Material Design Widgets
o	Flutter GetX / Provider (for State Management)
o	Dio Package (for API Integration)
o	Responsive UI with Media Query and Flexbox Layouts Flutter 
•	Back-End Tools 
o	Firebase Authentication
o	Hive Database/sqflite
o	RESTful API 
o	Firestore

•	Deployment & Testing
o	Testing Environment: Local emulator/ physical devices(Android)

•	Technique 
o	Cross-Platform Mobile & Web Application 
(Single codebase developed using Flutter for Android, Web, and potentially iOS) 
1.10   System Design Approach 
•	We will use MVVM(Model-View-View Model) approach for better performance of our project.
•	Unified Model Language(UML)
1.11 Process Model Used  
•	RUP (Rational Unified Process Model)  
1.12   Limitations / Constraints
•	The application requires a stable internet connection for services using Firebase (authentication, cloud backup, real-time sync). Core reminder functions work offline with locally stored data (after initial login).
•	Dependence on third-party services such as Firebase and Gemini API means that provider downtime, data limits, or policy changes can effect app functionality.
•	The system is optimized primarily for Android iOS and desktop versions are planned for later phases.
•	The current version provides self-management features only it does not directly connect to doctors or pharmacies.
•	Data security measures (authentication, encryption, access control) are in place, but ultimate responsibility for keeping credentials safe rests with the user.
1.13   References
•	Google (2024). Firebase Official Documentation. Retrieved from https://firebase.google.com/docs.
•	Flutter Team. (2024). Flutter Documentation- Build Apps for Any Screen. Retrieved from https://docs.flutter.dev/.
•	Medium. (2023). State Management in Flutter: Provider vs GetX Explained Simply. Retrieved from  https://medium.com/flutter-community/.
•	ResearchGate. (2023). Mobile Health Applications for Medication Adherence: A Systematic Review. Retrieved from https://www.researchgate.net/.
















CHAPTER#2: ANALYSIS













SOFTWARE REQUIRMENT SPECIFICATION
For
Personal Medicine Reminder
Version 1.0
Prepared By
Atif Islam
&
Muhammad Awais Ali
27th Nov, 2025


















Revision History
Version  	Description  	Author  	Date  
 1.0	This cover the major SRS documents 	Atif Islam
 & 
Muhammad Awais Ali 	27th  Nov,2025  












2.1 Introduction
The Personal Medicine Reminder Application (PMRA) is a mobile-based health management system designed to assist patients in organizing their daily medication intake, appointments, and health information. The app addresses a common healthcare problem: forgetting to take medicines on time or managing multiple prescriptions incorrectly. 
Developed using Flutter for cross-platform compatibility and integrated with Firebase (for storage, authentication) and local databases (for offline use), this system allows users to receive timely medicine reminders, manage stock levels, view health reports, and maintain essential medical records. 
The application targets patients, elderly individuals, and people with chronic conditions, while also supporting caregivers and doctors who help monitor treatment adherence. Its intuitive interface, smart reminders, and data organization aim to improve medication discipline, health awareness, and patient independence. 
2.1.1 Purpose 
The main purpose of the Personal Medicine Reminder Application is to create an intelligent, userfriendly platform that automates medicine management and reminder functions while maintaining key health information securely. 
This system will: 
•	Send timely notifications reminding users to take prescribed medicines. 
•	Enable multi-medicine management for users handling multiple prescriptions. 
•	Help users track medicine stock and receive alerts when supplies run low. 
•	Provide a daily, weekly, and monthly schedule overview for medicines and appointments. 
•	Store essential health details such as chronic conditions, allergies, and previous prescriptions. 
•	Offer report generation and visualization for missed doses and medicine trends. 
•	Allow profile customization, including personal information and health data. 
•	Support appointment scheduling, visit notes, and motivation journaling. 
•	Include a ChatBot Assistant for user guidance and a Help & Support section for troubleshooting. 

2.1.2 Scope 
The scope of the Personal Medicine Reminder Application includes all essential features needed for effective personal medicine and health management within a single mobile platform. It focuses on simplifying daily medication routines, organizing health information, and ensuring users never miss their prescribed doses through timely reminders. 
This application is primarily designed for patients who manage multiple or chronic medications and need assistance in keeping track of their schedules. It also supports elderly users who require simple, clear, and visual reminders to help them take their medicines on time and maintain a consistent health routine. 
The functional scope of the system includes the following main features:
•	Authentication Module 
•	Profile Management 
•	Medicine Management 
•	Schedule Management 
•	User Health Records 
•	Inventory Control 
•	Analytics & Data Visualization 
•	Settings & Preferences 
•	Appointment Management 
•	Journaling & Motivation 
•	Report Management 
•	ChatBot Assistant 
•	Help & Support 
2.1.3   Definitions, Acronyms and Abbreviation 
Table 2.1.3.1 Definition, Acronyms and Abbreviation
Term/Abbreviation 	Definition 
GUI 	Graphical User Interface 
RUP 	Rational Unified Process 
UML 	Unified Modeling Language 
API 	Application Programming Interface 
Firebase 	Backend as a Service paltform for authentication, cloud storage, and data handling 
AI 	Artificial Intelligence ( used in ChatBot Assistant) 
DB 	Database (used for local medicine and schedule storage) 
MVVM 	Model-view-viewmodel 
2.1.4  Overview 
This document describes the requirements for the Personal Medicine Reminder Application (PMRA).The requirements were gathered through consulations with healthcare professionals and patient feedback. The system aims to automate medicine scheduling, reminders, and health record management, ensuring accuracy, reliability, and convenience for users.It focuses on improving patient adherence, reducing missed doses, and providing an organized approach to personal healthcare management. 
2.2  Functional Requirements 
2.2.1  Authentication 
2.2.1.1 Process SignIn 
SRS-1        	The system shall allow new users to register by providing required personal information such as full name, email address, password and confirm-password. 
SRS-2      	 The system shall enforce the creation of a unique user ID or email during the registration process to ensure account uniqueness. 
SRS-3        	The system shall require users to create a password that meets defined security requirements (e.g. minimum 8 characters, at least one uppercase letter and one number). 
SRS-4        	The system shall validate that all mandatory fields are completed
before allowing registration submission. 
SRS-5        	The system shall send a verification email containing a clickabl link upon successful registration. 
SRS-6 	The system shall prevent duplicate accounts using the same email address. 
SRS-7 	The system shall redirect the user to the login screen after successful account creation. 
2.2.1.2 Process Login 
SRS-8        	The system shall allow registered users to log in by providing a valid email address and password. 
SRS-9       	The system shall validate user credentials against stored authentication data before granting access. 
SRS-10        	The system shall redirect authenticated users to their respective home or dashboard screens upon successful login. 
SRS-11      	The system shall display an appropriate error message if login credentials are invalid (active internet connection is required for initial authentication and cloud sync). 
2.2.1.3 Process Logout 
SRS-12     	The system shall allow users to securely log out using the logout button located at the bottom of the Profile screen. 
SRS-13     	The system shall terminate all active user sessions upon logout to prevent unauthorized access. 
SRS-14        	The system shall redirect users to the login screen after a successful logout. 
2.2.1.4  Forget Password 
SRS-15     	The system shall allow users to request a password reset using their registered email address. 
SRS-16     	The system shall send a password reset link to the user’s registered email. 
SRS-17        	The system shall verify the reset link and allow users to create a new password. 
SRS-18      	The system shall update and securely store the new password once it is successfully reset. 
2.2.1.5  Change Password 
SRS-19    	The system shall allow logged-in users to change their password through the profile section. 
SRS-20     	The system shall require users to enter their current password before setting a new one. 
SRS-21        	The system shall validate that the new password meets defined security requirements (e.g. minimum 8 characters, one uppercase letter and one number). 
SRS-22      	The system shall confirm that the new password and confirm password fields match before submission. 
SRS-23      	The system shall display an appropriate success message after the password is changed successfully. 
SRS-24 	The system shall disable the change password option for users authenticated via Google Login, as their credentials are managed externally by Google. 
2.2.1.6 Process SocialLogin 
SRS-25   	The system shall allow users to sign in using their Google account credentials. 
SRS-26     	The system shall retrieve basic user information such as full name and email address from Google. 
SRS-27        	The system shall automatically create a new user account if the Google account does not already exist in the system. 
SRS-28      	The system shall log in the user directly if their Google account is already registered. 
SRS-29      	The system shall redirect the user to the home screen upon successful Google authentication. 
SRS-30 	The system shall not allow users authenticated via Google to change passwords within the app, as credentials are managed by Google. 
2.2.2 Profile Management
2.2.2.1 View Profile 
SRS-31  	The system shall display the user’s full name and registered email address. 
SRS-32     	The system shall display the user’s blood group. 
SRS-33        	The system shall display the user’s weight and height 
SRS-34      	The system shall automatically calculate and display the user’s BMI based on weight and height. 
SRS-35      	The system shall display the user’s gender. 
SRS-36 	The system shall display the user’s date of birth (DOB). 
SRS-37 	The system shall display the profile photo uploaded in the Update Profile screen. 
2.2.2.2 Update Profile 
SRS-38 	The system shall allow users to update their full name. 
SRS-39     	The system shall allow users to update their blood group. 
SRS-40        	The system shall allow users to update their weight and height. 
SRS-41      	The system shall automatically recalculate BMI after weight or height changes. 
SRS-42      	The system shall allow users to update their gender. 
SRS-43 	The system shall allow users to update their date of birth (DOB). 
SRS-44 	The system shall save all updated information securely in Firebase under the user’s account. 
SRS-45 	The system shall provide a separate Change Password button at the bottom of the screen, which navigates users to the Change Password screen. 
SRS-46 	The system shall provide a Save button to save all profile changes to Firebase securely. 
SRS-47 	The system shall display a confirmation message after successfully saving profile updates. 
SRS-48 	The system shall allow users to upload or replace their profile photo, which will be reflected in the View Profile screen. 
2.2.2.3 Manage Basic Health Information 
SRS-49 	The system shall allow users to enter their height in centimeters. 
SRS-50     	The system shall allow users to enter their weight in kilograms. 
SRS-51        	The system shall allow users to select their blood group from a predefined list. 
SRS-52      	The system shall automatically calculate and display BMI based on height and weight. 
SRS-53      	The system shall validate all fields before saving to ensure data accuracy.  
SRS-54 	The system shall securely store all basic health information in Firebase when the Save button is pressed. 
SRS-55 	The system shall display a confirmation message after successfully saving basic health information. 
2.2.2.4 Upload Profile Photo 
SRS-56 	The system shall allow users to select a photo from their device gallery. 
SRS-57     	The system shall validate that the uploaded file is a supported image format (e.g. JPG, PNG). 
SRS-58        	The system shall resize or compress the image if needed to optimize storage and performance. 
SRS-59      	The system shall save the user’s profile photo URL/ path in Firebase Realtime Database and display it in the user’s profile.
SRS-60      	The system shall update the profile view to display the newly uploaded photo immediately. 
SRS-61 	The system shall Provide an option to remove or replace the existing profile photo. 
2.2.3 Medicine Management 
2.2.3.1 Add Medicine 
SRS-62 	The system shall allow users to add a new medicine by providing required details such as name, dosage, and frequency. 
SRS-63     	The system shall let users set medicine reminders with multiple notification per dose. 
SRS-64 	The system shall support complex schedules, including specific days of the week, interval-based (every X days), and cyclic schedules (X days on, Y days off). 
SRS-65        	The system shall allow users to enter an optional initial stock quantity for each medicine. 
SRS-66      	The system shall validate that all required fields are completed before adding a new medicine. 
SRS-67      	The system shall save the new medicine information securely in local storage. 
SRS-68 	The system shall display a confirmation message after successfully adding a new medicine. 
2.2.3.2 Update Medicine Details 
SRS-69 	The system shall allow users to edit the name, category, dosage. 
SRS-70     	The system shall allow users to update reminder schedules for each medicine. 
SRS-71        	The system shall validate all required fields before saving updates. 
SRS-72      	The system shall save updated medicine information securely in local storage. 
SRS-73      	The system shall display a confirmation message after successfully updating the medicine. 
2.2.3.3 Set Medicine Reminder 
SRS-74 	The system shall send notifications for each medicine according to the defined reminder schedule. 
SRS-75     	The system shall allow multiple notifications per dose (e.g. 5 minutes before, at exact time, and 2 after). 
SRS-76        	The system shall provide action buttons on notifications: “Take”, “Missed”, and “Snooze”. 
SRS-77      	The system shall update the status of each dose based on user interaction with notifications. 
SRS-78      	The system shall save all reminder schedules and statuses locally. 
2.2.3.4 Disable Medicine Alert 
SRS-79 	The system shall allow users to disable notifications for a selected medicine. 
SRS-80     	The system shall allow users to remove a medicine from the alert list while keeping the medicine in inventory. 
SRS-81        	The system shall update the reminder system immediately after any changes. 
2.2.3.5 Categorize Medicine 
SRS-82 	The system shall allow users to select a category for each medicine (e.g. Tablet, Syrup, Injection, Insulin). 
SRS-83     	The system shall allow users to create a custom category if the predefined options do not match. 
SRS-84        	The system shall save category information locally with the medicine data. 
2.2.4  Schedule Management 
2.2.4.1 View Calendar 
SRS-85 	The system shall display a calendar view highlighting dates with scheduled medicines or appointments. 
2.2.4.2 View Daily Schedule 
SRS-86 	The system shall display all medicines and appointments for the current day. 
2.2.4.3 View Date Schedule 
SRS-87 	The system shall allow users to view details of medicines and appointments for a specific date. 
2.2.4.4 Apply Date Range Limitation 
SRS-88 	The system shall display only 15 days of past data and 15 days of future data in the calendar relative to the current date. 
2.2.5  User Health Records 
2.2.5.1  Add Allergies List 
SRS-89 	The system shall allow users to add, view, and update a list of allergies. 
SRS-90 	The system shall validate allergy entries before saving. 
2.2.5.2 View Current Medication 
SRS-91 	The system shall display all medicines the user is currently taking. 
SRS-92 	The system shall allow users to mark medicines as active or completed. 
2.2.5.3 View Past Medication 
SRS-93 	The system shall display medicines previously taken by the user. 
SRS-94 	The system shall update past medications automatically when a medicine is removed or marked completed. 
2.2.5.4 Add Restraints 
SRS-95 	The system shall allow users to record any medication restrictions or dietary restraints. 
2.2.5.5 Add Chronic Illnesses 
SRS-96 	The system shall allow users to add, view, and update chronic illnesses. 
2.2.6  Inventory Control 
2.2.6.1 View Current Stock 
SRS-97 	The system shall display a list of all medicines with their current stock quantities. 
SRS-98 	The system shall automatically display medicines with stock ≤ 5 at the top of the list. 
2.2.6.2 Update Current Stock 
SRS-99 	The system shall allow users to increase or decrease stock quantities for a selected medicine. 
SRS-100 	The system shall save the updated stock quantity locally. 
SRS-101 	The system shall display a confirmation message after successfully updating stock. 
2.2.6.3 Generate Stock Alerts 
SRS-102 	The system shall trigger a notification when a medicine’s stock reaches each threshold. 
SRS-103 	The system shall display low-stock medicines in a dedicated “Low Stock” section for quick reference. 
SRS-104 	The system shall update stock alerts immediately after stock changes. 
 
2.2.7 Appointment Management 
2.2.7.1 Add Appointment 
SRS-105 	The system shall allow users to add a new appointment with date, time, doctor/clinic name, and category. 
SRS-106 	The system shall allow users to set a reminder for the appointment. 
2.2.7.2 Update Appointment 
SRS-107 	The system shall allow users to edit the appointment date, time, category, or doctor/clinic name. 
SRS-108 	The system shall allow users to update visit notes or reminder settings. 
2.2.7.3 Manage Appointment categories/Status 
SRS-109 	The system shall categorize appointments as “Upcoming” or “Completed” based on the date and time. 
SRS-110 	The system shall display upcoming appointments at the top for quick access. 
SRS-111 	The system shall allow users to manually mark an appointment as completed. 
2.2.7.4 Set Appointment Reminder 
SRS-112 	The system shall send a notification at a user-specified time before the appointment. 
SRS-113 	The system shall allow recurring reminders if enabled by the user. 
2.2.7.5 Add Visit Notes 
SRS-114 	The system shall allow users to add visit notes for an appointment 
2.2.7.6 View Appointment History 
SRS-115 	The system shall display a history of completed appointments. 
SRS-116 	The system shall allow users to filter or search past appointments by date or category. 
2.2.8 Journaling & Motivation 
2.2.8.1 Record Mood & Notes Journal 
SRS-117 	The system shall allow users to add daily mood entries using predefined mood options (e.g. happy, sad, neutral). 
SRS-118 	The system shall allow users to add optional text notes along with mood entries. 
SRS-119 	The system shall allow users to update  mood entries and notes. 
2.2.8.2 Attempt User Challenges 
SRS-120 	The system shall utilize the Gemini API to generate daily health challenges.
SRS-121 	The system shall provide a static fallback list of standard challenges (e.g. "Drink Water") to ensure functionality when the device is offline or the API is unreachable. 
SRS-122 	The system shall make all challenges optional, ensuring users are not penalized for skipping them. 
2.2.8.3 Display Visual Streak Tracker 
SRS-123 	The system shall calculate a "Streak" based on consecutive days where the user achieves 100% medication adherence 
SRS-124 	The system shall visually represent the streak using a prominent counter  
SRS-125 	The system shall reset the streak counter to zero if a user fails to log their medication for a full calendar day. 
2.2.9  Report Management 
2.2.9.1 Add/Upload Report 
SRS-126 	The system shall allow users to add new reports with title and date. 
SRS-127 	The system shall save reports securely in device storage. 
2.2.9.2 Search Report
SRS-128	The system shall allow users to search reports by title, date, or type. 
SRS-129 	The system shall display search results in a list.
2.2.9.3 View Report
SRS-130	The system shall allow users to view reports within the app using a built-in viewer.
2.2.10 ChatBot Assistant 
2.2.10.1 Access Chat Interface 
SRS-131 	The system shall allow users to open a chat interface to interact with the assistant. 
SRS-132 	The system shall display messages from both user and chatbot clearly. 
2.2.10.2 Apply Safety Filters & Rules 
SRS-133 	The system shall implement safety filters to block inappropriate or harmful content. 
SRS-134 	The system shall update safety rules on the backend without requiring an app update. 
2.2.11 Help & Support 
2.2.11.1 View User Guide 
SRS-135 	The system shall provide a user guide explaining app features and navigation. 
2.2.11.2 Submit Contact/Feedback Form 
SRS-136 	The system shall allow users to send feedback by launching their default email client. 
2.2.11.3 View About Section 
SRS-137 	The system shall provide an About section with app version, developer names, and contact info. 
2.2.12 Settings & Preferences 
2.2.12.1 Change App Theme 
SRS-138 	The system shall allow users to toggle between light and dark theme. 
SRS-139 	The system shall save the selected theme preference locally for future sessions. 
2.2.12.2 Configure Notification Settings 
SRS-140	The system shall allow users to set recurring reminders with a specified time and frequency. 
SRS-141 	The system shall allow users to select custom sounds for notifications. 
2.2.12.3 Detect & Adjust Time Zone Automatically 
SRS-142 	The system shall detect the device’s current time zone automatically. 
SRS-143 	The system shall adjust reminder notifications based on the detected time zone. 
 
2.2.13 Analytics & Data Visualization 
2.2.13.1 View Medicine Consumption Reports 
SRS-144 	The system shall display the number of doses taken for each medicine. 
SRS-145 	The system shall allow filtering by medicine or time period (daily/weekly/monthly). 
SRS-146 	The system shall highlight medicines with irregular intake. 
2.2.13.2 View Missed Doses Reports 
SRS-147 	The system shall list medicines with missed doses and corresponding dates/times. 
SRS-148 	The system shall provide a total count of missed doses per period. 
2.2.13.3 Display Monthly Summary 
SRS-149 	The system shall generate monthly charts for medicine intake and  missed doses. 

2.3 Non-Functional Requirements 
2.3.1 Performance: 
The system should handle multiple user operations simultaneously without lag and load each screen within 3 seconds on standard mobile devices. 
2.3.2 Security: 
All user credentials, personal health data, and medical records must be securely encrypted and protected from unauthorized access. 
2.3.3 Usability: 
The interface should be simple, accessible, and intuitive, allowing users of all age groups—especially elderly patients—to navigate easily. 
2.3.4  Reliability: 
The application must ensure accurate reminder notifications and maintain consistent local and cloud data synchronization. 
2.3.5 Availability: 
The app should remain operational 24/7, ensuring timely delivery of medicine reminders even in offline mode. 
2.3.6 Scalability: 
The system should support an increasing number of users and patients without performance degradation and allow future integration with additional features such as wearable devices, pharmacy systems, or telemedicine modules. 
2.3.7 Maintainability: 
The codebase should follow modular design principles and be well-documented to simplify debugging, updates, and new feature enhancements. 
2.3.8 Compatibility: 
The application should function smoothly across Android  devices and support various screen sizes and orientations. 
2.3.9 Data Integrity: 
All health and medicine data must remain consistent, accurate, and error-free during updates, reminders, and offline synchronization. 
2.3.10 Backup and Recovery: 
The system should perform regular cloud backups and enable data recovery in case of device loss, corruption, or system failure. 











USE CASE DIAGRAM
FOR 
Personal Medicine Reminder
Version 1.0
 
Prepared By 
Atif Islam
& 
Muhammad Awais Ali
27th  Nov, 2025 


















Revision History
Version	Description	Author	Date

1.0	This contains the Use Case Diagram for Personal Medicine Reminder App	Atif Islam 
&
Muhammad Awais Ali	
27th Nov,2025











2.4 Use Case Diagram
 

 


 







FULLY DRESSED USE CASES
FOR 
Personal Medicine Reminder
Version 1.0
 
Prepared By 
Atif Islam
& 
Muhammad Awais Ali
27th  Nov, 2025 


















Revision History
Version	Description	Author	Date

1.0	This contains the fully dressed use cases for Personal Medicine Reminder App	Atif Islam
&
Muhammad Awais Ali	
27th Nov,2025

	









2.5 FULLY DRESSED USE CASES

Use Case ID:                                  UC-01
Use Case Name:                            Process SignIn
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a new user creates an account by                                                                          
                                                        providing personal details and setting up security credentials.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to create a secure account to access app features.
				   System: Needs to ensure data uniqueness and security.
Pre-Conditions:                            1. System must be in running state.
                                                        2. User must not be currently logged in.
Main Success Scenario:
	User Action		System Response
1	User clicks on the Register or Sign Up button.		
		2	System displays the registration form requiring Full Name, Email, Password, and Confirm password.
 3	User enters full name and email address.		
4	User enters a password and confirms it.		
5	User clicks the Submit or Register button.		
		6	System validates that all mandatory fields are completed.
		7	System validates that the password meets security requirements (8 chars, 1 uppercase, 1 number).
		8	System checks if the email address is unique and not already registered.
		9	System creates the new user account in the database.
		10	System sends a verification email with a clickable link to the user.
		11	System redirects the user to the Login screen.
Post-Conditions: A new account is created, and the user is positioned at the Login screen awaiting 
		   email verification.
Extension Points:
                 6a. Missing Required Fields:
	    - System highlights missing fields and prevents submission.
	    - User is prompted to complete all fields.
                7a. Weak Password:
- System displays an error message “indicating password requirements” (min 8 chars, uppercase, number).
   - User re-enters a valid password.
   8a. Duplicate Email/Account Exists:
   - System detects the email is already in use.
  - System displays an error message “(Account already exists) and prevents duplicate creation”.
Priority:                HIGH
Frequency:            Less frequent in use.
Cross-Reference:  SRS-1, SRS-2, SRS-3, SRS-4, SRS-5, SRS-6, SRS-7

Use Case ID:                                  UC-02
Use Case Name:                            Process Login
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a registered user authenticates into the
				    system using their credentials to access their personal dashboard.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to access their personal health data securely.
System: Needs to prevent unauthorized access to private medical  
 records.
Pre-Conditions:                            1. System must be in running state.
                                                        2. User must have a valid, registered account.
				    3. User is on the Login screen.
Main Success Scenario:
	User Action		System Response
1	User navigates to the login screen.		
		2	System displays the login form requiring email and password.
 3	User enters their registered email address and password.		
4	User clicks the Login button.		
		5	System validates the entered credentials against stored authentication data.
		6	System confirms the credentials are valid.
		7	System redirects the user to the Home/Dashboard screen.
Post-Conditions: The user is successfully authenticated, an active session is started, and the user lands 
		   on the dashboard. 
Extension Points:
                 3a. Empty Fields:
	    - System detects missing email or password.
	    - System highlights the empty fields and prompts the user to fill them.
                5a. Invalid Credentials:
    - System checks credentials and finds a mismatch (wrong password or email).
    - System displays an appropriate error message (e.g., Invalid Email or Password).
   	    - User is prompted to re-enter credentials.
 	   5b. Network Error:
   - System cannot connect to the authentication server.
                - System displays a “Connection Error” message and asks the user to check their internet.
Priority:                HIGH
Frequency:            High frequent in use.
Cross-Reference:  SRS-8, SRS-9, SRS-10, SRS-11

Use Case ID:                                  UC-03
Use Case Name:                            Process Logout
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how an authenticated user securely ends 
				    their session via the profile section.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to securely exit the app.
   System: Needs to terminate the session to prevent unauthorized       
   access.
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be currently logged in.
				   3. User must be on the Profile Management screen.
Main Success Scenario:
	User Action		System Response
1	User navigates to the profile section.		
		2	System displays the user profile details.
 3	User scrolls to the bottom of the screen.		
4	User clicks on the Logout button.		
		5	System receives the logout request.
		6	System terminates all active user sessions immediately.
		7	System securely clears user authentication tokens from local storage.
		8	System redirects the user to the Login screen.
Post-Conditions: The user session is terminated, and the user is returned to the Login interface.

Extension Points:
                 5a. Network Failure:
	    - System fails to reach the server.
	    - System performs a force logout locally to ensure device security.
	    - System redirects to Login.
Priority:                HIGH
Frequency:            Most frequent in use.
Cross-Reference:  SRS-12, SRS-13, SRS-14

Use Case ID:                                  UC-04
Use Case Name:                            Forget Password
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user recovers their account by 
                                                        requesting a password reset link via email and setting a new 
 				    password.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to regain access to their account.
System: Needs to verify the user's identity before allowing a       password change.
Pre-Conditions:                            1. System must be in running state.
                                                        2. User is on the Login screen.
				   3. User possesses a valid, registered email address.
Main Success Scenario:
	User Action		System Response
1	User clicks on the Forgot Password?  link on the Login screen.		
		2	System displays a prompt requesting the user's registered email address.
 3	User enters their email address and clicks Send Reset Link.		
		4	System verifies that the email address exists in the database.
		5	System sends a password reset link to the provided email address.
		6	System displays a notification: Reset link sent. Please check your email.
		7	System confirms the reset email delivery and instructs the user to complete the password change through the email provider/Firebase reset link.
Post-Conditions: A password reset email has been sent. The user must complete the password update 
                through the external email reset flow before logging back in.
Extension Points:
                 4a. Email Not Found:
	    - System checks database and finds no matching account.
	    - System displays a generic message (If an account exists, a link has been sent) to prevent 
      email enumeration, or displays “Email not registered” (depending on security policy).
                 7a. Expired/Invalid Link (External Flow):
   	    - The password reset link in the email is old or already used.
	    - The external reset page displays an error: This link has expired.
  	    - The user is prompted to request a new reset email.
	    7b. Weak Password (External Flow):
	    - The external reset page rejects a password that does not meet security requirements.
 	    - The user is asked to choose a stronger password.

Priority:                HIGH
Frequency:            Less frequent in use.
Cross-Reference:  SRS-15, SRS-16, SRS-17, SRS-18

Use Case ID:                                  UC-05
Use Case Name:                            Change Password
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a logged-in user updates their account 
				    password for security purpose. It restricts access for users who 				    authenticated via external providers (Google).
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to secure their account with a new credential.
System: Needs to enforce security policies and update records    securely.
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be logged in.
				   3. User must be on the Profile Section.
				   4. User must NOT be logged in via Google (Social Login users have       
				    this option disabled).	
Main Success Scenario:
	User Action		System Response
1	User navigates to the profile section and clicks Change Password.		
		2	System displays the Change Password form requiring: Current Password, New Password, and Confirm Password.
 3	User enters their Current Password.		
4	User enters a New Password and re-enters it in Confirm Password.		
5	User clicks the Update or Save button.		
		6	System verifies that the Current Password matches the stored credentials.
		7	System validates that the New Password meets security requirements (min 8 chars, 1 uppercase, 1 number).
		8	System confirms that New Password and Confirm Password fields match.
		9	System updates the password in the secure database.
		10	System displays a success message confirming the change.
Post-Conditions: The user's password is updated. The user must use the new password for future 
		    logins.
Extension Points:
                 6a. Incorrect Current Password:
	    - System detects the current password entered is wrong.
	    - System displays an error: Incorrect current password.   
         	    - User is prompted to retry. 
    	    7a. Weak Password:
    - System detects the new password is too simple.
	    - System displays an error listing the missing requirements (e.g., Must contain 1 number).
   	    8a. Password Mismatch:
	    - System detects New and Confirm passwords do not match.
	    - System displays an error: Passwords do not match.
	    Alternate Flow (Google User):
  	    - If a Google-authenticated user views the Profile, the Change Password button is disabled     
	    (greyed out) or hidden entirely.
Priority:                HIGH
Frequency:            Less frequent in use.
Cross-Reference:  SRS-19, SRS-20, SRS-21, SRS-22, SRS-23, SRS-24 
 
Use Case ID:                                  UC-06
Use Case Name:                            Process SocialLogin
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user authenticates using their Google 
account. The system handles both registration (new users) and login (existing users) automatically.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants a quick, one-tap login without remembering a new 
				   password.
System: Needs to verify identity via a trusted third-party provider        (Google).
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must have an active internet connection (Required for Google 
				   API).
				   3. User must be on the Login or Registration screen.
Main Success Scenario:
	User Action		System Response
1	User clicks the Sign in with Google button.		
		2	System redirects the user to the Google Authentication interface.
 3	User selects their Google account and grants permission.
		
		4	System retrieves basic user information (Full Name, Email) from Google.
		5	System checks if the retrieved email address already exists in the database.
		6	Scenario A: Existing User) System identifies the account exists and logs the user in directly.
(Scenario B: New User) System automatically creates a new user account using the Google details.
		7	System establishes a secure session.
		8	System redirects the user to the Home screen.
Post-Conditions: The user is authenticated and directed to the dashboard. The system flags this user as 
		    Social Login disabling the ability to change password locally.
Extension Points:
                 3a. User Cancels / Denies Permission:
	    - User clicks Cancel on the Google screen.
	    - System returns the user to the Login screen without authenticating.
    	    4a. Google API/Network Failure:
    	    - System cannot connect to Google services.
    	    - System displays an error: Google Sign-In failed. Please check your connection.
   	    6c. Account Conflict:
	    - If the email exists but was created with a standard password (not Google), the system    
  	     informs the user that the account already exists with a different sign-in method.
	  - The user is prompted to sign in with the original method or link accounts through a supported. Priority:                HIGH
Frequency:            High frequent in use.
Cross-Reference:  SRS-25, SRS-26, SRS-27, SRS-28, SRS-29, SRS-30

Use Case ID:                                  UC-07
Use Case Name:                            View Profile
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user views their personal details, 
				    physical attributes, and calculated health metrics(BMI).
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to verify their personal and health information.
System: Needs to present accurate, up-to-date data and perform real-       time calculations (BMI).
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be logged in.
				   3. User data (weight, height, etc.) must exist in the database (or show 
				    as empty/default).
Main Success Scenario:
	User Action		System Response
1	User clicks on the Profile tab or menu option.		
		2	System retrieves user details (Name, Email, Photo) from authentication or database storage.
 		3	System retrieves health data (Blood Group, Weight, Height, Gender, DOB).
		4	System automatically calculates the BMI using the stored weight and height values.
		5	System displays the Profile Screen containing: Profile Photo, Full Name & Email, Gender & Date of Birth , Blood Group , Weight & Height , Calculated BMI
Post-Conditions: The user is viewing their current profile information.
Extension Points:
                 2a. Data Loading Error:
	    - System fails to fetch data due to network or database issues.
   	    - System displays a “Failed to load profile” message with a “Retry” button.
    	    3a. Missing Health Data:
    	    - If weight/height are not set, System displays “Not Set” or “—” in those fields.
    	    - System displays “—” for BMI (calculation cannot be performed).
	    - System provides a prompt/button: “Complete your Health Profile”.
   	    5a. No Profile Photo:
	    - If no photo was uploaded (SRS-37), System displays a default placeholder avatar.
Priority:                HIGH
Frequency:            High frequent in use.
Cross-Reference:  SRS-31, SRS-32, SRS-33, SRS-34, SRS-35, SRS-36, SRS-37

Use Case ID:                                  UC-08
Use Case Name:                            Update Profile
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user edits their personal information, 
health metrics, and profile photo. It also includes the ability to      navigate to the password change screen.
Primary Actors:                  	    <Patient>
Stakeholders & Interest:             User: Wants to keep their personal and health data current.
System: Needs accurate weight/height data to provide correct BMI       calculations.
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be logged in.
				   3. User is viewing the Profile screen.
Main Success Scenario:
	User Action		System Response
1	User clicks the Edit Profile button.		
		2	System displays the Update Profile screen with editable fields pre-filled with current data.
 3	User modifies personal details (Full Name,  Date of Birth, Gender).		
4	User modifies health details (Blood Group, Weight, Height).		
5	(Optional) User clicks on the profile image to upload or replace their photo.		
6	User clicks the Save button.		
		7	System automatically recalculates the BMI based on the new weight/height values.
		8	System validates the input formats (e.g. valid email).
		9	System saves all updated information securely to Firebase under the user’s account.
		10	System displays a confirmation message: Profile updated successfully.
		11	System redirects user back to the View Profile screen showing the updated details and photo.
Post-Conditions: User profile data is updated in the cloud (Firebase) and locally. The displayed BMI 
 		   reflects the new weight/height.
Extension Points:
                 8a. Invalid Input:
	    - User enters an invalid email format or unrealistic weight/height.
	    - System highlights the error and prevents saving.
    	    9a. Network/Firebase Error:
	    - System fails to connect to Firebase.
	    - System displays an error: “Failed to save changes. Check internet connection”.
	    - System retains the user's edits on screen so they can try again.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-38, SRS-39, SRS-40, SRS-41, SRS-42, SRS-43, SRS-44, SRS-45, SRS-46, 
                               SRS-47, SRS-48


Use Case ID:                                  UC-09
Use Case Name:                            Manage Basic Health Information
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user records specific physical 
attributes (height, weight, blood group) to allow the system to track      health   metrics and automatically calculate Body Mass Index(BMI).
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to track physical health changes.
				   System: Needs accurate data for BMI calculation and medical 
				   context.
Pre-Conditions:                            1. System must be in running state.
                                                        2. User must be logged in.
				   3. User is on the Basic Health Information or Edit Profile screen.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Health Information section.		
		2	System displays input fields for Height, Weight, and Blood Group.
 3	User enters their height in centimeters.		
4	User enters their weight in kilograms.		
		5	System automatically calculates and displays the BMI based on the entered height and weight values.
6	User selects their blood group from a predefined dropdown list (e.g., A+, O-).		
7	User clicks the Save button.		
		8	System validates all fields to ensure data accuracy (e.g., non-negative values).
		9	System securely stores the health information in Firebase.
		10	System displays a confirmation message indicating the data was saved successfully.
Post-Conditions: The user's health metrics are updated in the cloud database, and the latest BMI is 
		    visible on the profile.
Extension Points:
                 5a. Incomplete Data for BMI:
    - If user enters only Weight but deletes Height (or vice versa).
    - System clears the BMI display or shows “—” until both fields are valid.
    	    8a. Validation Failure:
    - User enters unrealistic data (e.g., Height = 0 or negative weight).
    - System highlights the invalid field and displays an error message.
    - System prevents saving until corrected.
    	    9a. Network Failure:
    - System fails to connect to Firebase.
 	    - System displays a “Save failed” error and prompts the user to retry.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-49, SRS-50, SRS-51, SRS-52, SRS-53, SRS-54, SRS-55 


Use Case ID:                                  UC-10
Use Case Name:                            Upload Profile Photo
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user personalizes their account by 
uploading, validating, and saving a profile picture from their device gallery.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to personalize their profile experience.
				   System: Needs to manage storage efficiently and ensure file safety.
Pre-Conditions:                            1. System must be in running state.
                                                        2. User must be logged in.
				   3. User must be on the Update Profile or View Profile screen.
Main Success Scenario:
	User Action		System Response
1	User clicks on the current profile picture or Edit Photo icon.		
		2	System displays options: Choose from Gallery or Remove Photo.
 3	User selects Choose from Gallery.		
		4 	System opens the device's native image picker (Gallery).
5	User selects an image file.		
		6	System validates that the file is a supported format (JPG, PNG).
		7	System resizes or compresses the image to optimize performance and storage.
		8	System uploads the processed image securely to Firebase Realtime Database and links it to the user's account.
		9	System updates the profile view immediately to display the newly uploaded photo.
Post-Conditions: The user's profile photo is updated in the cloud and visible in the app.
Extension Points:
                 6a. Invalid File Format:
    - User selects an unsupported file (e.g. PDF, GIF).
    - System displays an error: “Invalid format. Please select a JPG or PNG image”.
    - System aborts the upload.
    	    8a. Upload Failure (Network):
    	    - System fails to complete the upload to Firebase.
    - System displays “Upload failed. Please check your internet connection”.
   Alternate Flow:	    
    	    3b. User selects “Remove Photo”. 
    	    - System asks for confirmation.
    - System deletes the current photo association from the database.
     - System reverts the profile view to a default avatar.
Priority:                LOW
Frequency:           Less frequent in use.
Cross-Reference:  SRS-56, SRS-57, SRS-58, SRS-59, SRS-60, SRS-61


Use Case ID:                                  UC-11
Use Case Name:                            Add Medicine
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user adds a new medicine to their 
schedule, defining complex dosage routines, reminders, and inventory tracking.
Primary Actors:                  	    <Patient>
Stakeholders & Interest:             User: Wants accurate tracking and reminders for complex 
				   prescriptions.
				   System: Needs precise scheduling data to trigger timely local 
				   notifications.
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be logged in.
				   3. User is on the Medicine Management screen.

Main Success Scenario:
	User Action		System Response
1	User clicks on the Add Medicine Button.		
		2	System displays the add medicine form requesting name, dosage, frequency, and stock.
 3	User enters the medicine name and dosage (e.g. 500mg).		
4	User selects a frequency/schedule type.		
		5	System presents scheduling options: daily, specific days, interval, or cyclic.
6	User configures the complex schedule: 
•	Specific Days: Select mon, wed, Fri.
•	Interval: Selects every 2 days.
•	Cyclic: Sets 21 days, 7 days off.		
7	User sets reminders, defining multiple notification times per dose (e.g. 8:00 AM, 8:00 PM).		
8	(Optional) User enters the initial stock quantity.		
9	User clicks the Save button.		
		10	System validates that all required fields (name, dosage, schedule) are completed.
		11	System saves the medicine data and schedule securely in local storage.
		12	System schedules the background notifications based on the complex rules defined.
		13	System displays a confirmation message ("Medicine added successfully").
Post-Conditions: The medicine is added to the local database, and reminders are active. The inventory 
		   count is initialized if provided.
Extension Points:
                 9a. Missing Required Fields:
	    - System detects missing Name or Frequency.
	    - System highlights the empty fields and displays an error message.
	    - User must complete fields to proceed.
    	    10a. Storage Error:
	    - System fails to write to the local database (e.g. insufficient storage).
	    - System displays an error: “Failed to save medicine”. Check device storage.
Priority:                 HIGH
Frequency:            Most frequent in use.
Cross-Reference:  SRS-62, SRS-63, SRS-64, SRS-65, SRS-66, SRS-67, SRS-68


Use Case ID:                                  UC-12
Use Case Name:                            Update Medicine Details
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user modifies an existing medicine 
entry, including changing the dosage, category, or rescheduling the  reminder notification.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to adjust their medication regimen as prescriptions 
				   change.
				   System: Needs to update local data and reset background alarm 
			                triggers.
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be logged in.
				   3. User has selected a specific medicine from the inventory list.
Main Success Scenario:
	User Action		System Response
1	User clicks the edit button on the Medicine Details Screen.		
		2	System displays the update medicine form with existing data pre-filled.
 3	User modifies the name, category, or dosage.		
4	User modifies the reminder schedule (time, frequency, or complex intervals).		
5	User clicks the update or save button.		
		6	System validates that all required fields are completed and valid.
		7	System overwrites the existing record in local storage with the new information.
		8	System cancels old notifications and reschedules new ones based on the updated schedule.
		9	System displays a confirmation message (“medicine updated successfully”).
		10	System redirects user to the updated medicine details view.
Post-Conditions: The medicine record is updated locally. Old alarms are cancelled, and new alarms 
		    are active.
Extension Points:
                 6a. Validation Failure:
	    - System detects that the Medicine Name is empty.
	    - System highlights the field and displays an error.
	    - User must enter a valid name to proceed.
    	    7a. Database Error:
	    - System fails to update the record in local storage.
	    - System displays “Update failed. Please try again.”
Priority:                 HIGH
Frequency:            Most frequent in use.
Cross-Reference:  SRS-69, SRS-70, SRS-71, SRS-72, SRS-73


Use Case ID:                                  UC-13
Use Case Name:                            Set Medicine Reminder
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user configures multiple alerts for a 
single dose and how they interact with the notification (take/ snooze/ miss) when its arrives. 
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants flexible reminders (e.g., 5 min before) and quick actions 
  to mark medicines as taken.
System: Needs to reliably trigger alerts and log the adherence status   locally.
Pre-Conditions:                           1. System must be in running state.
                                                      2. A medicine with a dosage schedule must exist in the database.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Reminder Settings for a specific medicine.		
2	User selects Notification Preferences.		
 		3	System displays options for before time, exact time, and after time.
4	User enables multiple notifications per dose (e.g. 5 mins before, Exact time).		
5	User clicks Save.		
		6	System saves the reminder schedule locally.
		7	System schedules the notification with the local notification service according to the saved schedule.
		8	System detects the scheduled time and triggers the notification.
		9	System displays the notification with action buttons: take, missed, and snooze.
10	User taps the take button on the notification.		
		11	System marks the dose as taken and updates the status locally.
		12	System cancels any remaining pending alerts for this specific dose (e.g. the "2 mins after" alert).
Post-Conditions: The medicine dose status is updated in the local database (used for reports), and the 
		    reminder cycle for that specific dose is completed.
Extension Points:
                 8a. User Taps “Snooze”:
	    - System reschedules the notification to trigger again after a predefined interval.
	    - Status remains “Pending”.
    	    8b. User Taps “Missed”:
	    - System marks the dose as “Missed” in the local database.
	    - System stops further notifications for this dose.
	    8c. No Action (User ignores):
	    - System keeps the notification visible in the tray.
	    - If “Post-Time” alerts are set (SRS-74), System triggers the next reminder (e.g., “2 mins        
         	    after”).  	
Priority:                 HIGH
Frequency:            High frequent in use.
Cross-Reference:  SRS-74, SRS-75, SRS-76, SRS-77, SRS-78


Use Case ID:                                  UC-14
Use Case Name:                            Disable Medicine Alert
Use Case Prepared by:                 Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                  M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user temporarily or permanently turns 
off reminders for a specific medicine without deleting the medicine from their inventory list.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:             User: Wants to stop annoying notifications for meds they aren't 
   currently taking but wants to keep the record.
   System: Needs to cancel scheduled tasks while preserving data          
   integrity.
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be logged in.
				   3. The target medicine must exist in the list and have active 
				    reminders.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Medicine Management or Medicine Details screen.		
2	User selects the specific medicine they wish to silence.		
 		3	System displays the medicine details, including a toggle switch or checkbox for reminders active.
4	User toggles the switch to OFF (Disable).		
		5	System prompts for confirmation (optional, depending on UI design) or processes the request immediately.
		6	System removes the medicine from the active alert queue immediately.
		7	System cancels any pending background notifications for this medicine.
		8	System updates the local database to flag reminders as disabled while keeping the medicine record in the inventory
		9	System displays a confirmation message (e.g. Alerts disabled for [Medicine Name]).
Post-Conditions: The medicine remains in the user's list (inventory), but no further notifications will 
		    be triggered.
Extension Points:
                 4a. Re-enabling Alerts:
	    - User toggles the switch back to ON.
	    - System checks the previously defined schedule.
	    - System re-schedules the notifications starting from the current time.
    	    6a. System Error:
	    - System fails to cancel the background alarm service.
	    - System displays an error “Failed to update settings” and reverts the toggle to ON.	
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-79, SRS-80, SRS-81


Use Case ID:                                  UC-15
Use Case Name:                            Categorize Medicine
Use Case Prepared by:                Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                 M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how a user assigns a form/type to a medicine 
(e.g. tablet, syrup) to organize their inventory. It includes the ability       to   define custom categories if the default options are insufficient.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:        	   User: Wants to visually distinguish between different types of                      
	   medication.
  System: Needs to structure data for filtering and reporting.
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be logged in.
				   3.User is currently in the Add Medicine or Update Medicine process.
Main Success Scenario:
	User Action		System Response
1	User taps the Category field while adding or editing a medicine.		
		2	System displays a list of predefined categories (e.g. Tablet, Syrup, Injection, Insulin).
 3	User selects a specific category from the list.		
		4	System highlights the selection and closes the list.
		5	User proceeds to save the medicine.
		6	System saves the selected category information locally linked to the specific medicine data.
Post-Conditions: The medicine is associated with a specific category, allowing for organized views 
		    and icons in the schedule.
Extension Points:
                 3a. Create Custom Category:
	    - User does not find the desired option in the list.
	    - User selects “Add Custom Category” (or “Other”).
	    - System displays a text input prompt.
	    - User enters the new category name (e.g. “Inhaler”).
	    - System saves the new category to the local list.
                 - System automatically selects this new category for the current medicine.
    	    3b. Cancel Selection:
	    - User taps outside the list.
	    - System retains the previously selected (or default) category.	
Priority:                 LOW
Frequency:            Less frequent in use.
Cross-Reference:  SRS-82, SRS-83, SRS-84 


Use Case ID:                                  UC-16
Use Case Name:                            View Calendar
Use Case Prepared by:                Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                 M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                  This use case describes how the user views a monthly or weekly 
calendar interface that visually marks dates containing scheduled medication doses or medical appointments.
Primary Actors:                  	   <Patient>
Stakeholders & Interest:        	   User: Wants a high-level overview of their upcoming and past health   
    schedule.
   System: Needs to query stored records to visualize data distribution.
Pre-Conditions:                            1. System must be in running state.
                                                       2. User must be logged in.
				   3. Local database must contain scheduled medicines or 
				   appointments.
Main Success Scenario:
	User Action		System Response
1	User taps on the Schedule or Calendar tab in the bottom navigation bar		
		2	System loads the calendar interface (defaulting to the current month/week).
 		3	System queries the local database for any medicines or appointments scheduled for the displayed dates.
		4	System highlights the dates that have events using visual indicators (e.g. a dot, color coding, or icon).
5	User swipes to view the next or previous month.		
		6	System updates the view and loads markers for the new date range.
Post-Conditions: The user is presented with a visual representation of their schedule.
Extension Points:
                 3a. No Events Found:
	    - System finds no scheduled medicines or appointments for the current month.
	    - System displays the calendar without any date highlights/markers.
    	    4a. Distinction of Event Types:
	    - (Optional Enhancement) System uses different colors (e.g., Red for Meds, Blue for 
    Appointments) to distinguish the type of highlight on the calendar.
Priority:                 MEDIUM
Frequency:            High frequent in use.
Cross-Reference:  SRS-85


Use Case ID:                                  UC-17
Use Case Name:                            View Daily Schedule
Use Case Prepared by:                Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                 M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                 This use case describes how the system presents the user with a 
comprehensive list of all medication doses and medical appointments  scheduled specifically for the current day. 
Primary Actors:                  	  <Patient>
Stakeholders & Interest:        	 Users: Wants to know exactly what they need to do today to stay     adherent. 
System: Needs to filter the database for the current date stamp.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
				 3. The device date/time must be set correctly.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Home Screen or Schedule Tab.		
		2	System retrieves the current system date.
 		3	System queries the local database for all medicines scheduled for this specific date.
		4	System queries the local database for all appointments scheduled for this specific date.
		5	System organizes the items (likely chronologically by time).
		6	System displays the Daily Schedule list containing all medicines and appointments for the current day.
Post-Conditions: The user is informed of their immediate health tasks for the day.
Extension Points:
                 3a/4a. No Scheduled Items:
	    - System finds no medicines or appointments for the current day.
	    - System displays a “No tasks for today” or “You are all caught up!” message (Empty State).
    	    6a. Interaction:
	    - User taps on an item in the list.
	    - System navigates to the details of that specific Medicine or Appointment.
Priority:                 HIGH
Frequency:            High frequent in use.
Cross-Reference:  SRS-86
Use Case ID:                                 UC-18
Use Case Name:                           View Date Schedule
Use Case Prepared by:                Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                 M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                 This use case describes how a user selects a specific date from the 
calendar to view the detailed list of medicines and appointments     scheduled for that day.
Primary Actors:                  	  <Patient>
Stakeholders & Interest:        	 User: Wants to plan ahead or review past adherence for a specific day.
System: Needs to filter database records based on the user-selected  date.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
				 3. User is viewing the Calendar screen.
Main Success Scenario:
	User Action		System Response
1	User taps on a specific date in the Calendar view.		
		2	System captures the selected date.
 		3	System queries the local database for medicines scheduled for that date.
		4	System queries the local database for appointments scheduled for that date.
		5	System displays a list or modal view showing the details of medicines and appointments for the selected date.
6	User views the details (time, dosage, doctor name).		
Post-Conditions: The user is presented with the schedule for the chosen date.
Extension Points:
                 3a/4a. No Events:
	    - System finds no entries for the selected date.
	    - System displays an empty state message (e.g. “No schedule for this date”).
    	    Alternate Flow: Date Switching
	    - User swipes or taps a different date immediately.
	    - System refreshes the list view with data for the newly selected date.
Priority:                 MEDIUM
Frequency:            Most frequent in use.
Cross-Reference:  SRS-87


Use Case ID:                                  UC-19
Use Case Name:                            Apply Date Range Limitation
Use Case Prepared by:                Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                 M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                 This use case describes how the system restricts the calendar view to 
a specific time window (15 days past and 15 days future) to maintain relevance and performance.
Primary Actors:                  	 <Patient><System>
Stakeholders & Interest:        	 User: Wants a focused view of their immediate schedule without  clutter from distant dates.
System: Wants to minimize data fetching load by limiting the query range.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User navigates to the Calendar View.
Main Success Scenario:
	User Action		System Response
1	User opens the Calendar screen.		
		2	System identifies the Current Date from the device settings.
 		3	System calculates the valid date range: Current Date - 15 days (Start Limit) and Current Date + 15 days (End Limit).
		4	System queries the local database for medicines and appointments only within this calculated 30-day window.
		5	System renders the calendar view, enabling interaction only for dates within this range.
6	User attempts to swipe or scroll to a date outside this range.		
		7	System prevents navigation beyond the limit (e.g., disables the Next Month button or stops scrolling).
Post-Conditions: The calendar is displayed with a restricted view. Data outside the ±15 day window 
    is hidden or not loaded.	
Extension Points:
                 7a. Visual Feedback:
- When a user tries to scroll past the limit, the system displays a toast message: “Calendar is  limited to 15 days past and future”.
    	    Alternate Flow (Date Change):
	    - If the user changes the device date, the system recalculates the window and refreshes the    
    view immediately.
Priority:                 LOW
Frequency:            Most frequent in use.
Cross-Reference:  SRS-88


Use Case ID:                                 UC-20
Use Case Name:                          Add Allergies List
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                This use case describes how a user maintains a digital record of their 
allergies. It covers adding new allergies, viewing the current list and updating existing entries.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	 User: Wants to store critical health data for reference by doctors or      caregivers.
 System: Needs to store this data to provide a complete health profile.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
				 3. User is on the User Health Records screen.
Main Success Scenario:
	User Action		System Response
1	User taps on the Allergies section.		
		2	System displays the list of currently recorded allergies (View).
 3	User taps the Add Allergy button.		
		4	System displays a text input field.
5	User enters the allergy name (e.g. Penicillin or Peanuts).		
6	User taps Save.		
		7	System validates the entry (checks for empty strings or special characters).
		8	System saves the new allergy to the user's health record.
		9	System refreshes the list to display the newly added allergy.
Post-Conditions: The allergy list is updated in the database and visible to the user.	
Extension Points:
                 7a. Validation Failure:
    - System detects an empty field or invalid characters.
    	    - System displays an error: “Please enter a valid allergy name”.
    - User is prompted to re-enter.
    	 
   Alternate Flow: Update/Edit Allergy:
    3b. User taps on an existing allergy.
	    4b. System enables editing mode for that entry.
	    5b. User modifies the text.
	    6b. User saves, and system validates before updating.
	    Alternate Flow: Duplicate Entry:
	    - System detects the allergy is already in the list.
	    - System displays: “This allergy is already recorded”.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-89, SRS-90


Use Case ID:                                UC-21
Use Case Name:                          View Current Medication
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                This use case describes how a user views their list of currently active 
prescriptions and manages their status by marking them as active or  completed.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to see a clear list of what they should be taking now vs.    what they have finished.
 System: Needs to segregate active reminders from historical records.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
				 3. User must have added at least one medicine.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Current Medication tab in Health Records.		
		2	System queries the local database for medicines with status Active.
 	.	3	System displays the list of all medicines the user is currently taking.
4	User identifies a medicine course that has ended.		
5	User selects the option to mark the medicine as Completed.		
		6	System prompts for confirmation (e.g. Are you sure you finished this course?).
7	User confirms the action.		
		8	System updates the medicine status from Active to Completed in the database.
		9	System removes the medicine from the Current list and moves it to the Past Medication history.
		10	System disables further reminders for this medicine.
Post-Conditions: The medicine status is updated. It no longer appears in the active list but is preserved 
    in the history records.
Extension Points:
                 3a. No Active Medicines:
   	    - System finds no active records.		
    	    - System displays an empty state message (“No active medications”).
    	    Alternate Flow: Re-activate Medicine:
	    - User views a “Completed” medicine (in Past view).
	    - User marks it as “Active”.
	    - System moves it back to the “Current Medication” list and re-enables reminders.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-91, SRS-92



Use Case ID:                                UC-22
Use Case Name:                          View Past Medication
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user accesses their medication history 
				 to view a list of prescription they have finished taking or discontinued.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to recall previous prescriptions for doctor visits or 
  				personal reference.
System: Needs to archive completed treatments separately from active   alerts.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
3. Medicines must have been previously marked as Completed or removed from the active list.
Main Success Scenario:
	User Action		System Response
1	User navigates to the User Health Records section.		
2	User selects the Past Medication tab/ option.		
 	.	3	System queries the local database for all medicines with the status Completed or Inactive.
		4	System automatically updates the list to include any medicine recently marked as completed or removed from the active view.
		5	System displays the list of past medicines, showing details like Name, Dosage, and Date Stopped.
6	User scrolls through the history list.		
Post-Conditions: The user has successfully viewed their medication history.
Extension Points:
                 3a. No History Found:
   	    - System finds no records with “Completed” status.		
    	    - System displays an empty state message (e.g. “No past medication history”).
    	    Alternate Flow: Search History:
	    - User enters a medicine name in a search bar within the Past Medication screen.
	    - System filters the historical list to match the query.
Priority:                 LOW
Frequency:            Less frequent in use.
Cross-Reference:  SRS-93, SRS-94


Use Case ID:                                UC-23 
Use Case Name:                          Add Restraints
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                This use case describes how a user records specific medication 
restrictions (e.g. No Aspirin) or dietary restraints (e.g. Low Sugar) to   maintain a complete health profile.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to document restrictions to avoid adverse health effects.
System: Needs this context to potentially warn users (future  enhancement) or display to caregivers.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
3. User is on the User Health Records screen.


Main Success Scenario:
	User Action		System Response
1	User taps on the Restraints or Restrictions section.		
		2	System displays the list of currently recorded restraints (if any).
 3	User taps the Add Restraint button.		
		4	System displays a form with fields for Type (e.g. Dietary, Medication) and Description.
5	User selects the Type and enters the Description (e.g. Gluten Intolerance).		
6	User clicks the Save button.		
		7	System validates that the description field is not empty.
		8	System securely saves the restraint entry to the user's health record.
		9	System updates the list view to include the new restraint.
Post-Conditions: The user's health record is updated with the new restriction data.
Extension Points:
                 7a. Missing Information:
   	    - System detects the Description is empty.		
    	    - System displays an error message.
	    - User must enter text to proceed.
    	    Alternate Flow: Remove Restraint:
	    - User selects an existing restraint.
	    - User taps “Delete”.
	    - System removes the entry from the list.
Priority:                 LOW
Frequency:            Less frequent in use.
Cross-Reference:  SRS-95


Use Case ID:                                UC-24
Use Case Name:                          Manage Chronic Illnesses
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user maintains a record of their long-
 term health conditions (e.g Diabetes, Hypertension). It covers viewing the list, adding new conditions, and updating existing ones.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to keep a central record of their medical history for easy reference.
System: Needs this data to potentially correlate with medication types (future scope).
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
3. User is on the User Health Records screen.
Main Success Scenario:
	User Action		System Response
1	User taps on the Chronic Illnesses section.		
		2	System displays the list of currently recorded illnesses (View). 
 3	User taps the Add Illness button.		
		4	System displays a form field for the illness name (and optional start date).
5	User enters the illness name (e.g. Asthma).		
6	User clicks the Save button.		
		7	System validates that the name field is not empty.
		8	System securely saves the new entry to the user's health profile.
		9	System updates the list view to include the new illness.
Post-Conditions: The user's medical profile is updated with the new chronic condition.
Extension Points:
                 Alternate Flow: Update Illness:
   	    3b. User taps on an existing illness in the list.	
    	    4b. System opens the entry in “Edit Mode”.
	    5b. User modifies the name or details.
	    6b. User saves the changes.
    	    7a. Validation Error:
	    - User attempts to save an empty field.
	    - System displays “Please enter an illness name”.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-96


Use Case ID:                                UC-25
Use Case Name:                          View Current Stock
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user monitors their medicine inventory. 
The system prioritizes low-stock items to ensure the user is aware of what needs replenishment.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to avoid running out of critical medication.
System: Needs to sort data to highlight urgent items.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. Medicines must exist in the database with stock tracking enabled.


Main Success Scenario:
	User Action		System Response
1	User navigates to the Inventory or Stock section.		
		2	System queries the local database for all registered medicines and their current stock counts.
 		3	System analyzes the stock levels for each item.
		4	System applies a sorting algorithm to identify medicines with stock ≤ 5.
		5	System displays the list of medicines with their quantities, placing the low-stock items (≤ 5) at the very top of the list.
6	User views the stock status.		
Post-Conditions: The user is presented with a prioritized view of their medicine inventory.
Extension Points:
                 2a. No Medicines Found:
   	    - System finds no medicine records.
    	    - System displays an empty state (“No inventory to display”).
    	    5a. Visual Highlighting:
	    - (UI Enhancement) System displays the low-stock items in Red or with a warning icon to   
	    Distinguish them further from normal stock items.
Priority:                 MEDIUM
Frequency:            Most frequent in use.
Cross-Reference:  SRS-97, SRS-98


Use Case ID:                                UC-26
Use Case Name:                          Update Current Stock
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                This use case describes how a user manually adjusts the inventory
count for a medicine, typically when refilling a prescription or correction a count discrepancy.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to keep inventory accurate to ensure alerts work correctly.
System: Needs accurate data to trigger "Low Stock" warnings.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. The user must have medicines added to their inventory.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Inventory or Medicine Details screen.		
		2	System displays the current stock quantity.
 3	User selects a specific medicine to update.		
4	User inputs the new quantity or uses “+” / “-” buttons to increase or decrease the count.		.
5	User clicks the Update or Save button.		
		6	System validates the new quantity (e.g. ensures it is not a negative number).
		7	System saves the updated stock quantity securely in the local database.
		8	System displays a confirmation message (Stock updated successfully).
		9	System refreshes the view to show the new stock level.
Post-Conditions: The local database reflects the new stock count. If the new count is low (≤ 5), the 
		    system may trigger a low-stock alert (referenced in next module).

Extension Points:
                 5a. Negative Value Entered:
   	    - User attempts to decrease stock below zero.
    	    - System prevents the action and displays an error: “Stock cannot be negative”.
    	    6a. Write Error:
	    - System fails to update the local record.
	    - System displays an error message and retains the previous value.
Priority:                 HIGH
Frequency:            Most frequent in use.
Cross-Reference:  SRS-99, SRS-100, SRS-101


Use Case ID:                                UC-27
Use Case Name:                          Generate Stock Alerts
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                This use case describes how the system automatically monitors 
inventory levels and triggers alerts to the user when medicine stock falls below a defined threshold, ensuring the user has time to refill prescriptions.
Primary Actors:                  	 <System>
Stakeholders & Interest:        	User: Wants to be reminded to buy medicine before running out.
System: Needs to enforce inventory rules and trigger proactive   notifications.
Pre-Conditions:                         1. System must be in running state.
                                                    2. Medicines must have stock tracking enabled.
3. A Stock Change event has just occurred (e.g., user took a dose or manually adjusted stock).


Main Success Scenario:
	User Action		System Response
1	User performs an action that reduces stock (e.g. marks a dose as Taken or manually edits stock).		
		2	System calculates the new remaining stock quantity for that medicine.
 		3	System compares the new quantity against the defined Low Stock Threshold (e.g. ≤ 5 units).
		4	(Condition Met: Low Stock) System detects the stock has reached or fallen below the threshold.
		5	System triggers a notification alerting the user that the specific medicine is running low.
		6	System immediately updates the Low Stock section, adding this medicine to the list for quick reference.
		7	System ensures the alert status persists until the stock is replenished.
Post-Conditions: The user receives a notification, and the dashboard/inventory screen highlights the 
		    low-stock item.
Extension Points:
   	    3a. Stock Above Threshold:
    	    - System calculates stock is still sufficient (> 5).
	    - System takes no further action regarding alerts.
    - If the item was previously in the “Low Stock” list (e.g., user just refilled it), System removes 
	    it from that section.
    	    5a. Notification Settings:
	    - User has disabled “Inventory Alerts” in settings.
	    - System skips the push notification but still updates the “Low Stock” UI section.
Priority:                 HIGH
Frequency:            High frequent in use.
Cross-Reference:  SRS-102, SRS-103, SRS-104


Use Case ID:                                UC-28
Use Case Name:                          Add Appointment
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user schedule a new visit to a doctor or 
clinic, categorizes the visit, and configures reminder notification to ensure they attend on time.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to organize their medical visits and receive timely reminders.
System: Needs to store schedule data and trigger alerts at the correct time.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. User is on the Appointment Management screen.
Main Success Scenario:
	User Action		System Response
1	User taps the Add Appointment button.		
		2	System displays a form with fields for Doctor/Clinic Name, Date, Time, Category, and Reminder Settings.
 3	User enters the Doctor or Clinic Name.		
4	User selects the Date and Time of the visit.		
5	User selects a Category (e.g. General Checkup, Dentist, Cardiology).		
6	User enables the Reminder option and sets a notification time (e.g. 1 hour before).		
7	User clicks the Save button.		
		8	System validates that mandatory fields (Name, Date, Time) are filled.
		9	System saves the appointment details locally.
		10	System schedules the reminder notification based on the user's preference.
		11	System displays a confirmation message and adds the appointment to the calendar/ list view.
Post-Conditions: The appointment is recorded in the system, and a background alert is set for the 
		    specified reminder time.
Extension Points:
   	    4a. Invalid Date:
    	    - User selects a date/time in the past.
	    - System displays a warning: “Appointment cannot be in the past”. (Unless intended for 
	     Record-keeping, depending in business logic).
    	    8a. Missing Fields:
	    - System detects missing Doctor Name or Date.
	    - System highlights the field and displays “Required field”.
	    - User must complete the form to proceed.
Priority:                 HIGH
Frequency:            Most frequent in use.
Cross-Reference:  SRS-105, SRS-106


Use Case ID:                                UC-29
Use Case Name:                          Update Appointment
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user modifies the details of an existing 
appointment, such as rescheduling the date/time, changing the doctor’s name, or updating reminder preferences and visit notes. 
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to keep their schedule accurate when plans change.
System: Needs to update local records and reschedule any pending notification triggers.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. An existing appointment must be selected.
Main Success Scenario:
	User Action		System Response
1	User navigates to the appointment details view and clicks the Edit button.		
		2	System displays the Update Appointment form with current data pre-filled.
 3	User modifies the Doctor/Clinic Name, Category, Date, or Time.		
4	User updates the Visit Notes or adjusts the Reminder Settings (e.g. changing the alert time).		
5	User clicks the Update or Save button.		
		6	System validates the updated information (e.g. ensures the date is valid).
		7	System saves the changes securely in local storage.
		8	System cancels the old reminder notification and schedules a new one based on the updated settings.
		9	System displays a confirmation message (Appointment updated successfully).
		10	System redirects the user to the updated Appointment Details view.
Post-Conditions: The appointment record is updated locally. The previous reminder is cancelled, and 
		    the new reminder is active.
Extension Points:
   	    6a. Validation Failure:
    	    - System detects that the new Date/Time is invalid.
	    - System highlights the error and prompts the user to correct it.
    	    8a. System Error:
	    - System fails to update the local database.
	    - System displays an error message and discards the changes.
Priority:                 MEDIUM
Frequency:            Most frequent in use.
Cross-Reference:  SRS-107, SRS-108

Use Case ID:                                UC-30
Use Case Name:                          Manage Appointment Categories/Status
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                This use case describes how the system organizes appointments by 
status (upcoming/completed) and allow the to manually update the status of a visit.
Primary Actors:                  	 <Patient><System>
Stakeholders & Interest:        	User: Wants to see immediate upcoming tasks first and clear out finished tasks.
System: Needs to maintain order and accurate history records.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. Appointments must exist in the database.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Appointments list view.		
		2	System compares the current date and time against stored appointment schedules.
 		3	System automatically categorizes appointments as Upcoming (future dates) or Completed (past dates).
		4	System sorts and displays the list, placing Upcoming appointments at the top for quick access.
5	User identifies an appointment that they have attended.		
6	User selects the option to Mark as Completed (via checkbox, swipe action, or button).		
		7	System updates the appointment status in the local database to Completed.
		8	System moves the appointment from the Upcoming section to the Completed/ History section.
		9	System displays a confirmation message (Appointment marked as completed).
Post-Conditions: The appointment status is updated, and the list is re-organized to prioritize remaining 
		    future visits.
Extension Points:
   	    2a. No Appointments:
    	    - System finds no records.
	    - System displays an empty state (“No upcoming appointments”).
    	    6a. Accidental Completion:
	    - User marks an appointment as completed by mistake.
	    - User navigates to the “Completed” section.
	    - User selects “Mark as Upcoming/Incomplete”.
	    - System restores the appointment to the active list.
Priority:                 MEDIUM
Frequency:            High frequent in use.
Cross-Reference:  SRS-109, SRS-110, SRS-111
Use Case ID:                                UC-31
Use Case Name:                          Set Appointment Reminder
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user configures notification alerts for 
medical visits, including setting a specific lead time (e.g. 30 mins before) and enabling recurring alerts for regular treatments.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to be reminded sufficiently in advance to travel to the clinic.
System: Needs to register a scheduled task in the background service.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. User is in the process of Adding or Editing an appointment.
Main Success Scenario:
	User Action		System Response
1	User locates the Reminder Settings section within the Appointment form.		
		2	System displays a toggle to Enable Reminder and options for timing.
3	User toggles the reminder to ON.		
4	User selects a User-Specified Time (e.g. 15 minutes, 1 hour, or 1 day before).		
5	(Optional) User enables the Recurring Reminder option for regular visits (e.g. weekly therapy).		
6	User clicks Save or Done.		
		7	System calculates the exact trigger time based on the appointment date and the user-specified lead time.
		8	System schedules the notification in the local background service.
		9	System saves the preference locally and displays a confirmation icon (e.g. a bell icon next to the appointment).
Post-Conditions: A background alarm is active. At the calculated time, the system will trigger a push 
		   notification.
Extension Points:
   	    4a. Invalid Time:
    	    - User sets a reminder time that has already passed (e.g., reminder 1 hour before an 
     appointment that is in 30 mins).
	    - System displays a warning: “Reminder time is in the past”.
    	    5a. Recurring Logic:
	    - If “Recurring” is selected, System prompts for frequency (e.g., Weekly, Monthly).
	    - System creates a series of appointment instances or sets a repeating alarm logic.
Priority:                 MEDIUM
Frequency:            Most frequent in use.
Cross-Reference:  SRS-112, SRS-113

Use Case ID:                                UC-32
Use Case Name:                          Add Visits Notes
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                This use case describes how a user attaches textual notes to a specific 
appointment, allowing them to record doctor's instructions, diagnosis    details, or personal observations.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to remember key details discussed during the   consultation.
System: Needs to store unstructured text data linked to the appointment record.
Pre-Conditions:                         1. System must be in running state.
                                                    2. User must be logged in.
3. An appointment record (upcoming or past) must exist.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Appointment Details screen for a specific visit.		
2	User taps on the Add Visit Notes or Edit Notes field		
		3	System displays a multi-line text input area.
4	User enters relevant information (e.g., Doctor said to increase water intake, Next follow-up in 2 weeks).		
5	User clicks the Save button.		
		6	System validates the input (e.g. checks character limits).
		7	System saves the notes securely in the local database linked to the specific appointment ID.
		8	System displays a confirmation message and shows the saved notes on the Appointment Details screen.
Post-Conditions: The appointment record is updated with the new notes, which are viewable in the 
    appointment history.
Extension Points:
   	    6a. Empty Note:
    	    - User saves an empty field.
	    - System either clears previous notes (if editing) or saves nothing, returning to the detail view 
      	      without error.
    	    7a. Storage Error:
	    - System fails to write to the database.
	    - System displays “Failed to save notes” and preserves the user's text so they can try again.
Priority:                 LOW
Frequency:            Most frequent in use.
Cross-Reference:  SRS-114


Use Case ID:                                UC-33
Use Case Name:                          View Appointment History
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                This use case describes how a user accesses the archive of their past 
medical visits. It includes functionality to search for specific records or filter the list by date and category.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to review past doctor visits, diagnosis notes, or follow-
 up dates.
System: Needs to retrieve archived data efficiently without loading active schedules.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. User must have appointments marked as Completed in the database.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Appointments section.		
2	User selects the History or Completed tab.		
		3	System queries the local database for all appointments with status Completed.
		4	System displays the list of past appointments, showing details like Date, Doctor Name, and Category.
		5	System displays options to filter by Category (e.g. Dentist) or search by Date.
6	(Optional) User clicks the Filter/Search icon.		
7	User selects a specific category or enters a date range.		
		8	System filters the displayed list to show only the matching records.
9	User taps on a specific history item.		
		10	System opens the detailed view of the past appointment (including visit notes).
Post-Conditions: The user has successfully retrieved specific information regarding their past medical 
    visits.
Extension Points:
   	    3a. No History Found:
    	    - System finds no completed appointments.
	    - System displays an empty state message (e.g. “No appointment history available”).
    	    7a. No Search Results:
	    - User applies a filter that yields no matches.
	    - System displays: “No appointments found matching your criteria”.
	    - System provides a “Clear Filters” button.
    Alternate Flow: Reset Filter:
	    - User taps “Clear Filters”.
	    - System reloads the full list of completed appointments.
Priority:                 LOW
Frequency:            Less frequent in use.
Cross-Reference:  SRS-115, SRS-116


Use Case ID:                                UC-34
Use Case Name:                          Record Mood & Notes Journal
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user logs their daily emotional state 
using predefined icons and optional text notes, and how they can  modify these entries later.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to track their mental well-being alongside their physical 
health.
System: Needs to store subjective health data for trend analysis.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. User is on the Journaling or Dashboard screen.
Main Success Scenario:
	User Action		System Response
1	User taps on the Daily Journal or Mood Tracker section.		
		2	System displays a set of predefined mood options (e.g. Happy, Sad, Neutral, Energetic).
3	User selects a Mood Icon representing their current state.		
		4	System highlights the selection.
5	(Optional) User taps the Add Note field.		
		6	System displays a text input area.
7	User types a personal reflection or note (e.g. Feeling tired after medication).		
8	User clicks the Save button.		
		9	System saves the mood selection and text note locally with the current timestamp.
		10	System displays a confirmation (Entry saved) and updates the daily streak or journal view.
Post-Conditions: The user's mood and notes are recorded for the specific date.

Extension Points:
   	    Alternate Flow: Update Entry:
    	    1a. User navigates to a past date in the journal.
	    2a. System displays the previously recorded mood/note.
    	    3a. User taps “Edit”.
	    4a. User changes the mood icon or modifies the text note.
	    5a. User saves.
	    6a. System updates the existing record in the database.
	    6a. Empty Selection:
	    - User attempts to save without selecting a mood.
	    - System prompts: “Please select a mood to save your entry”.
Priority:                 LOW
Frequency:            High frequent in use.
Cross-Reference:  SRS-117, SRS-118, SRS-119


Use Case ID:                                UC-35
Use Case Name:                          Attempt User Challenges
Use Case Prepared by:               Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:                M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how  system uses the Gemini API to generate 
personalized daily health challenges based on the user's mood and health profile, and how the user attempts them.
Primary Actors:                  	 <Patient><Gemini API>
Stakeholders & Interest:        	User: Wants relevant, non-repetitive tasks to improve motivation.
System: Wants to leverage AI to increase user retention.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. Internet connection must be available (for API generation).

Main Success Scenario:
	User Action		System Response
1	User navigates to the Motivation or Challenges tab.		
		2	System sends a prompt to the Gemini API: Generate 3 simple, optional health challenges for a diabetic user who is feeling tired. Return as JSON.
		3	System receives the API response and parses the JSON data.
		4	System displays the daily challenges (e.g. Drink Sugar-Free Electrolytes, 10 Min Stretch, Read a positive quote).
5	User views the challenges and taps Accept on one.		
		6	System marks the challenge as In Progress.
7	User completes the task and taps Complete.		
		8	System updates the visual streak tracker.
		9	System saves the completion status locally.
Post-Conditions: The user's streak is updated. The challenges for the day are cached locally.
Extension Points:
   	    3a. Network Unavailable (Offline Mode):
    	    - System detects no internet connection.
	    - System falls back to a local list of pre-defined static challenges (e.g. “Drink Water”, “Walk 
      1000 steps”).
    	    - System displays: “Showing offline challenges”.
	    5a. API Error / Safe Content Filter:
	    - Gemini API returns an error or flags content.
	    - System defaults to the local static list to ensure the screen is never empty.
	    Alternate Flow: User Ignores:
	    - User does not interact with challenges.
	    - System resets challenges the next day without penalty.
Priority:                 LOW
Frequency:            Most frequent in use.
Cross-Reference:  SRS-120, SRS-121, SRS-122


Use Case ID:                                UC-36
Use Case Name:                          Display Visual Streak Tracker
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                 This use case describes how the system visualizes the user consistency 
(streaks) in taking medication or completing challenges to motivate    them.
Primary Actors:                  	 <Patient><System>
Stakeholders & Interest:        	User: Wants to see progress and feel motivated by a "winning streak."
System: Wants to retain users by gamifying adherence.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. User must have at least one day of activity recorded.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Dashboard or Motivation tab.		
		2	System calculates the Current Streak (consecutive days with 100% medication adherence or completed challenges).
		3	System retrieves the Max Streak (highest record ever achieved).
		4	System displays the streak visually (e.g. a Fire icon with a number, a filled calendar ring, or a progress bar).
5	User taps on the Streak icon.		
		6	System displays a detailed view (e.g. You have been consistent for 5 days! Keep it up).
Post-Conditions: The user is informed of their progress.
Extension Points:
   	    2a. Broken Streak:
    	    - System detects the user missed a day.
	    - System resets the “Current Streak” to 0.
    	    - System displays an encouraging message (e.g. “Don't worry, start a new streak today!”).
	    2b. Offline Calculation:
	    - System calculates streaks based on the last known local data sync.
Priority:                 LOW
Frequency:            Most frequent in use.
Cross-Reference:  SRS-123. SRS-124, SRS-125


Use Case ID:                                UC-37
Use Case Name:                          Add/Upload Report
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:                 This use case describes how a user uploads a digital copy of a medical 
report (e.g., lab result, prescription) by providing a title, date, and selecting a file from their device.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to store and organize medical documents centrally.
System: Needs to handle file input and local storage securely.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. User is on the Report Management screen.

Main Success Scenario:
	User Action		System Response
1	User taps the Add Report button.		
		2	System displays a form requesting Report Title and Date.
3	User enters the Title (e.g. Blood Test) and selects the Date.		
4	User taps the Upload File button.		
		5	System opens the device's native file picker or gallery.
6	User selects a document (PDF) or image file.		
7	User clicks the Save button.		
		8	System validates that the Title and File are present.
		9	System saves the report file securely in Device Storage.
		10	System saves the report metadata (Title, Date, Path) in the local database.
		11	System displays the new report in the list and shows a success message.
Post-Conditions: The report is saved locally and is viewable in the app list.
Extension Points:
   	    5a. File Selection Cancelled:
    	    - User closes the file picker without selecting a file.
	    - System returns to the form view without attaching a file.
    	    8a. Storage Error:
	    - System attempts to save but device storage is full or permission is denied.
	    - System displays an error message: “Failed to save report. Please check storage 
    permissions”.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-126. SRS-127
Use Case ID:                                UC-38
Use Case Name:                          Search Report
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user finds specific medical documents 
within their archive by filtering results based on report title, date, or category type.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to quickly locate a specific document among many 
uploads.
System: Needs to query metadata efficiently to filter the display list.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. Reports must already be saved in the system.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Report Management screen.		
		2	System displays the full list of existing reports.
3	User taps the Search Bar or Filter Icon.		
4	User enters a keyword (Title) OR selects a Date or chooses a Type (e.g. Lab Result).		
		5	System processes the input and filters the stored report records based on the criteria.
		6	System updates the view to display the search results in a list format.
7	User taps on a specific result to view the document.		
Post-Conditions: The view displays only the reports matching the search criteria.

Extension Points:
   	    4a. No Matches Found:
    	    - System queries the database and finds no matching records.
	    - System displays an empty state message (e.g. “No reports found matching ‘Xray’”).
	    - System allows the user to clear the search and try again.
    	    Alternate Flow: Clear Search:
	    - User taps the “X” or “Clear” button in the search bar.
	    - System restores the full list of all reports.
Priority:                 Less
Frequency:            Less frequent in use.
Cross-Reference:  SRS-128. SRS-129


Use Case ID:                                UC-39
Use Case Name:                          View Report
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user opens and views a stored medical 
document (PDF or Image) directly within the application interface without needing external apps.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to quickly read their medical results without leaving the 
app.
System: Needs to render different file formats (PDF, JPG) securely.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. A valid report file must exist in local storage.
Main Success Scenario:
	User Action		System Response
1	User taps on a Report Item in the list view.		
		2	System retrieves the file path of the selected report.
		3	System identifies the file type (e.g. PDF or Image).
		4	System launches the Built-in Viewer (PDF Renderer or Image Viewer).
		5	System displays the document content on the screen.
6	User interacts with the document (e.g. pinch-to-zoom, scroll).		
7	User taps the Back or Close button.		
		8	System closes the viewer and returns the user to the Report List.
Post-Conditions: The user has successfully viewed the document content.
Extension Points:
   	    2a. File Not Found:
    	    - System attempts to load the file but the path is broken (e.g. file deleted outside app).
	    - System displays an error: “File not found”.
	    - System prompts user to remove the broken record.
    	    3a. Unsupported Format:
	    - System detects a format the built-in viewer cannot handle.
	    - System prompts: “Cannot preview this file. Open in external app?”.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-130

Use Case ID:                                UC-40
Use Case Name:                          Access Chat Interface
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user opens the AI Assistant, sends 
queries, and views a clear, readable conversation history between themselves and the bot.
Primary Actors:                  	 <Patient><Gemini API>
Stakeholders & Interest:        	User: Wants instant answers to health questions in a readable format.
System: Wants to facilitate natural language interaction.
Pre-Conditions:                          1. System must be in running state.
                                                     2. User must be logged in.
 3. Internet connection must be active.
Main Success Scenario:
	User Action		System Response
1	User taps the Assistant floating action button or menu item.		
		2	System opens the Chat Interface overlay or screen.
3	User types a health-related question (e.g. How do I take this med?) and taps Send.		
		4	System immediately renders the User's message on the right side of the screen (or distinct color) to distinguish it.
		5	System sends the text to the AI Backend (Gemini).
		6	System receives the response and renders the Chatbot's message on the left side (or distinct color) clearly.
7	User scrolls through the conversation to read past messages.		
Post-Conditions: The conversation is displayed clearly, and the user has received an answer.
Extension Points:
   	    2a. Offline Mode:
    	    - System detects no internet.
	    - System disables the input field and displays: “Assistant is offline”.
    	    6a. Long Response:
	    - Bot response is very long.
	    - System formats the text with proper spacing/bullets to ensure it remains “clear” and 
      readable.
Priority:                 MEDIUM
Frequency:            Most frequent in use.
Cross-Reference:  SRS-131,SRS-132


Use Case ID:                                UC-41
Use Case Name:                          Apply Safety Filters & Rules
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how the system monitors chat interactions to 
detect and block harmful, inappropriate, or unsafe content using dynamic backend rules.
Primary Actors:                  	 <Patient><Gemini API>
Stakeholders & Interest:        	User: Wants a safe environment free from harassment or dangerous 
medical misinformation.
System: Needs to mitigate liability and ensure safe AI usage.
Pre-Conditions:                         1. User is engaged in a chat session.
2. Safety rules are defined on the backend server.
Main Success Scenario:
	User Action		System Response
1	User types a query into the chat interface and hits Send.		
		2	System intercepts the message before processing the AI response.
		3	System checks the content against the current safety rules retrieved from the backend.
		4	(Scenario: Harmful Content) System detects inappropriate keywords or unsafe medical requests (e.g. self-harm queries).
		5	System blocks the message processing.
		6	System displays a standard safety warning (e.g. I cannot answer this query. If this is an emergency, please call 911).
Post-Conditions: The unsafe interaction is halted, and the user is redirected to safe resources.
Extension Points:
   	    3a. Rule Update:
    	    - Developers update the safety keyword list on the server.
	    - System applies these new rules immediately to the next message without the user needing 
      to update the app from the App Store.
    	    4a. Content is Safe:
	    - System validates the content is clean.
	    - System passes the query to the Gemini API for a normal response.
Priority:                 HIGH
Frequency:            High frequent in use.
Cross-Reference:  SRS-133,SRS-134


Use Case ID:                                UC-42
Use Case Name:                          View User Guide
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user accesses the built-in text-based 
documentation to read instructions on how to use the application features.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants clear, readable instructions on how to use the app.
System: Wants to provide lightweight, offline-accessible help.
Pre-Conditions:                         1. System must be in running state.
2. User navigates to the Help & Support screen.
Main Success Scenario:
	User Action		System Response
1	User taps on User Guide in the Help menu.		
		2	System displays a list of help topics (e.g. Adding Medicine, Setting Reminders).
3	User taps on a specific topic title.		
		4	System opens the detail view for that topic.
		5	System displays the text-only instructions explaining the feature step-by-step.
6	User reads the text and scrolls down if necessary.		
7	User taps Back to return to the topic list.		
Post-Conditions: The user has read the information.
Extension Points:
   	    2a. Search Guide:
    	    - User types a keyword into the search bar.
	    - System filters the text topics to show only those matching the keyword.
    	    5a. Offline Access:
	    - Since the guide is text-only, it loads instantly from the local JSON/Database without 
     needing an internet connection.
Priority:                 LOW
Frequency:            Less frequent in use.
Cross-Reference:  SRS-135


Use Case ID:                                UC-43
Use Case Name:                          Submit Contact/Feedback Form
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user sends feedback by launching their 
device's default email client. The system pre-fills the recipient address and subject line for convenience.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to send an email to support without copying/pasting the 
 address.
System: Offloads the message handling to the external email app.
Pre-Conditions:                         1. System must be in running state.
2. User must be logged in.
3. User must have an email app (e.g., Gmail) installed and configured 
on their device.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Help & Support section.		
2	User taps the Send Feedback or Contact Developer button.		
		3	System constructs a mailto link containing the developer's email address and a default subject (e.g. App Feedback).
		4	System launches the external Default Email Application (e.g. Gmail).
		5	The Email App opens a Compose window with the To field pre-filled with the developer's email.
6	User types their message in the email body.		
7	User taps the Send arrow/button within the email app.		
		8	The email is sent via the user's personal email account.
9	User manually switches back to the Medicine Reminder App.		
Post-Conditions: An email is sent to the developer. The user returns to the app manually.
Extension Points:
   	    4a. No Email App Installed:
    	    - System attempts to launch the email client but fails.
	    - System displays an error: “No email app found. Please contact us at dev@example.com”.
    	    - System copies the email address to the user's clipboard as a fallback.
Priority:                 LOW
Frequency:            Less frequent in use.
Cross-Reference:  SRS-136


Use Case ID:                                UC-44
Use Case Name:                          View About Section
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user views administrative details about 
the application, including the current software version, developer credits, and contact information.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to check the installed version or developer details.
Developer: Wants to provide credit and version context for support.
Pre-Conditions:                         1. System must be in running state.
2. User navigates to the Help & Support or Settings screen.
Main Success Scenario:
	User Action		System Response
1	User taps on the About or App Info menu option.		
		2	System displays the About Screen.
		3	System renders the App Logo and App Name.
		4	System displays the Current Version Number (e.g. v1.1).
		5	System lists the Developer Names (Atif Islam & Muhammad Awais Ali) and Contact Info.
6	User reads the information and taps Back.		
Post-Conditions: The user is informed about the app details.
Extension Points:
   	    Alternate Flow: Copy Info:
    	    - User long-presses the contact email.
	    - System copies the text to the clipboard.
Priority:                 LOW
Frequency:            Less frequent in use.
Cross-Reference:  SRS-137


Use Case ID:                                UC-45
Use Case Name:                          Change App Theme
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user customizes the visual appearance 
of the application by switching between Light and Dark modes to suit their lighting environment or preference.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to reduce eye strain (Dark mode) or improve visibility in 
bright light (Light mode).
System: Needs to persist visual preferences across app restarts.
Pre-Conditions:                         1. System must be in running state.
2. User navigates to the Settings screen.

Main Success Scenario:
	User Action		System Response
1	User taps on the Appearance or Theme option in Settings.		
		2	System displays the current selection (e.g.  Light) and a toggle switch or radio buttons.
3	User selects the alternative theme (e.g. switches from Light to Dark).		
		4	System immediately updates the application's colors, backgrounds, and text styles to match the Dark Theme.
		5	System saves the selected theme preference locally so it remains active for future sessions.
6	User navigates back to other screens.		
		7	System maintains the selected theme throughout the application.
Post-Conditions: The application UI is updated, and the preference is stored. If the user closes and 
    reopens the app, it will load in the selected theme.
Extension Points:
   	    3a. System Default:
    - User selects “System Default”.
    - System detects the device's OS setting (Android Dark/Light mode).
	    - System matches the app theme to the OS setting automatically.
    4a. UI Glitch:
    - System fails to update a specific icon or text color immediately.
    - System refreshes the current screen to correct the display.
Priority:                 LOW
Frequency:            Less frequent in use.
Cross-Reference:  SRS-138, SRS-139


Use Case ID:                                UC-46
Use Case Name:                          Configure Notification Settings
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user selects custom sounds, and        
 configuring recurrence preferences.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants alerts that are distinct (sound) and easy to read (size) 
without being annoying.
System: Needs to apply these preferences to the local notification 
manager.
Pre-Conditions:                         1. System must be in running state.
2. User navigates to the Settings screen.
Main Success Scenario:
	User Action		System Response
1	User taps on Notifications within the Settings menu.		
		2	System displays notification preferences, featuring a dedicated Custom Sound option.
3	User taps on Custom Sound.		
		4	System fetches and lists all available pre-loaded custom app sounds and system tones.
5	User selects a specific custom sound (e.g., Chime).		
		6	System plays a short audio preview of the selected custom sound.
7	User taps Save (or navigates back).		
		8	System saves the selected sound choice and updates the local notification manager preferences.
Post-Conditions: Future notifications will use the selected sound and visual style.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-140, SRS-141


Use Case ID:                                UC-47
Use Case Name:                          Detect & Adjust Time Zone Automatically
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how the system automatically detects changes 
in the device's time zone (e.g. during travel) and adjusts pending medication reminders to ensure they trigger at the correct local time.
Primary Actors:                  	 <Patient><System>
Stakeholders & Interest:        	User: Wants to take medication at the correct “wall-clock” time (e.g.
8 AM) regardless of location.
System: Needs to resync the local notification schedule to match the new device time.
Pre-Conditions:                         1. System must be in running state.
2. User device settings allow Automatic Date & Time.
Main Success Scenario:
	User Action		System Response
1	User travels to a different time zone (or manually changes device time zone).		
		2	System detects the device’s current time zone change automatically.
		3	System retrieves the list of pending reminders.
		4	System recalculates the trigger times relative to the new local time.
		5	System adjusts reminder notifications to ensure they ring at the user-defined time (e.g. 8:00 AM) in the new time zone.
		6	System displays a toast/notification: Time zone updated. Reminders adjusted.
Post-Conditions: All future reminders are synchronized with the new local time.
Extension Points:
   	4a. Skipped Dose (Time Jump):
- The time zone change moves the clock forward past a scheduled dose (e.g. 1 PM to 4 PM,  skipping a 2 PM dose).
- System detects a missed alarm due to the shift.	
- System triggers a notification: “You may have missed your 2 PM dose due to time zone change”.
 4b. Duplicate Dose (Time Fallback):
  - The time zone change moves the clock backward (e.g. 2 PM back to 11 AM).
  - System ensures the 8 AM dose (already taken) does not ring again for the “same” day, 
   preventing double dosing.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-142, SRS-143



Use Case ID:                                UC-48
Use Case Name:                          View Medicine Consumption Report
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how a user views detailed medication 
adherence reports, filters them by time or medicine, and identifies irregular intake patterns.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to identify adherence gaps or trends over time.
System: Needs to query historical data and apply logic to detect irregularities.
Pre-Conditions:                         1. System must be in running state.
2. User must be logged in.
3. Medication logs exist in the database.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Analytics section.		
		2	System retrieves medication history from the local database.
		3	System displays the number of doses taken for each medicine.
		4	System analyzes timestamps to identify medicines with irregular intake (e.g. frequently missed or taken late).
		5	System highlights these irregular medicines visually (e.g. with an amber warning icon or red text).
6	User taps the Filter option.		
		7	System displays filter criteria: Medicine Name and Time Period (Daily, Weekly, Monthly).
8	User selects a specific time period (e.g. Monthly).		
		9	System refreshes the report to show data only for the selected period.
Post-Conditions: The user views a filtered, analyzed report of their medication history.
Extension Points:
   	4a. No Irregularities:
 - System analysis finds 100% consistent adherence.
 	 - System displays a “Perfect Adherence” badge instead of warning highlights.	
 6a. Specific Medicine Filter:	
  - User filters by a specific medicine name (e.g. “Insulin”).
 	  - System hides all other medicines and shows the detailed timeline for that specific drug only.
Priority:                 MEDIUM
Frequency:            Most frequent in use.
Cross-Reference:  SRS-144, SRS-145, SRS-146 


Use Case ID:                                UC-49
Use Case Name:                          View Misses Doses Report
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how the system generates a specific report 
highlighting non-adherence, showing exactly which doses were missed, when they were missed, and the total count for the selected period.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants to understand patterns in their forgetfulness to improve 
future adherence.
System: Needs to track negative compliance data for accurate health scoring.
Pre-Conditions:                         1. System must be in running state.
2. User must be logged in.
3. The database must contain logs where the status is recorded as missed.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Missed Doses section within Reports or Analytics.		
		2	System queries the local database for medication logs with the status Missed.
		3	System aggregates the data to calculate the total count of missed doses for the current/selected period.
		4	System generates a detailed list displaying:
•	Medicine Name
•	Date & Time of the missed dose.
		5	System displays the Total Missed Count prominently at the top of the screen.
6	User reviews the list to identify specific days or times where they struggled.		
Post-Conditions: The user is informed of their specific non-adherence instances.
Extension Points:
   	2a. No Missed Doses:
- System finds no logs with “Missed” status.
- System displays a “Great Job!” or “Perfect Adherence” message.
- Total count is shown as 0.
 Alternate Flow: Filter by Date:
 - User changes the view from “Weekly” to “Monthly”.
 - System recalculates the total count and refreshes the list for the new range.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-147, SRS-148 

Use Case ID:                                UC-50
Use Case Name:                          Display Montly Summary
Use Case Prepared by:              Atif Islam           Use Case Prepared On: 26th Nov, 2025
Use Case Updated by:               M.Awais Ali       Use Case Updated On: 27th Nov, 2025
Use Case Description:               This use case describes how the system aggregates 30 days of 
medication data to generate visual charts comparing successful intake versus missed doses, helping the user see long-term trends.
Primary Actors:                  	 <Patient>
Stakeholders & Interest:        	User: Wants a visual overview of their monthly performance.
System: Needs to render graphical charts (bar/pie) from statistical data.
Pre-Conditions:                         1. System must be in running state.
2. User must be logged in.
3. Sufficient data (at least a few days) exists to generate a meaningful chart.
Main Success Scenario:
	User Action		System Response
1	User navigates to the Reports or Summary tab.		
2	User selects the Monthly View option.		
		3	System retrieves all medication logs for the current calendar month.
		4	System calculates the totals for Taken and Missed doses.
		5	System generates a visual chart (e.g. Bar Chart or Pie Chart) representing these statistics.
		6	System displays the chart with a legend (Green = Taken, Red = Missed).
7	User interacts with the chart (e.g. taps a bar to see the exact count).		
Post-Conditions: The user is presented with a graphical summary of their monthly health adherence.
Extension Points:
   	3a. New Month/No Data:
 - System detects the current month has no logs yet.
 - System displays an empty chart placeholder or text: “No data for this month yet”.
 5a. Interactive Drill-down:
 - User taps on the “Missed” section of the pie chart.
 - System navigates to the “Missed Doses Report” for that specific month.
Priority:                 MEDIUM
Frequency:            Less frequent in use.
Cross-Reference:  SRS-149
































CHAPTER # 3: DESIGN













SYSTEM SEQUENCE DIAGRAM
FOR
Personal Medicine Reminder
VERSION 1.0
Prepared by
Atif Islam
&
Muhammad Awais Ali
 4th Jan, 2026




















Revision History
Version	Description	Author	Date

1.0	This contains the system sequence diagram for Personal Medicine Reminder App	Atif Islam 
&
Muhammad Awais Ali	
4th Jan, 2026

















3.1 System Sequence Diagram
SSD 01: Process SignIn
 


SSD 02: Process Login
 


SSD 03: Process Logout
 


SSD 04: Forget Password
 

SSD 05: Change Password
 

SSD 06: Process SocialLogin
 



SSD 07: View Profile
 


SSD 08: Update Profile
 


SSD 09: Manage Basic Health Information

 


SSD 10: Upload Profile Photo
 

SSD 11: Add Medicine
 


SSD 12: Update Medicine Details
 


SSD 13: Set Medicine Reminder
 


SSD 14: Disable Medicine Reminder
 



SSD 15: Categorize Medicine
 


SSD 16: View Calendar
 



SSD 17: View Daily Schedule
 


SSD 18: View Date Schedule
 



SSD 19: Apply Date Range Limitation
 


SSD 20: Add Allergies List
 



SSD 21: View Current Medication
 


SSD 22: View Past Medication
 



SSD 23: Add Restraints
 


SSD 24: Add Chronic Illnesses
 



SSD 25: View Current Stock
 


SSD 26: Update Current Stock
 



SSD 27: Generates Stock Alerts
 


SSD 28: Add Appointment
 



SSD 29: Update Appointment
 


SSD 30: Manage Appointment Categories/Status
 



SSD 31: Set Appointment Reminder
 


SSD 32: Add Visit Notes
 



SSD 33: View Appointment History
 


SSD 34: Record Mood & Notes Journal
 



SSD 35: Attempt User Challenges
 



SSD 36: Display Visual Streak Tracker
 

SSD 37: Add/Upload Report
 


SSD 38: Search Report
 



SSD 39: View Report
 


SSD 40: Access Chat Interface
 



SSD 41: Apply Safety Filters & Rules 
 


SSD 42: View User Guide
 



SSD 43: Submit Contact & Feedback Form
 


SSD 44: View About Section
 



SSD 45: Change App Theme
 


SSD 46: Configure Notification Settings
 



SSD 47: Detect & Adjust Time Zone Automatically
 


SSD 48: View Medicine Consumption Reports
 



SSD 49: View Missed Doses Reports
 


SSD 50: Display Monthly Summary
 


SCHEMA DIAGRAM
FOR 
Personal Medicine Reminder
Version 1.0
 
Prepared By 
Atif Islam
& 
Muhammad Awais Ali
4th Jan, 2026 




















Revision History
Version	Description	Author	Date

1.0	This contains the  schema diagram for Personal Medicine Reminder App	Atif Islam
&
Muhammad Awais Ali	
4th Jan,2026









3.2 Firebase (Realtime Database)

 





3.3 Hive
 
 











DOMAIN MODEL
FOR 
Personal Medicine Reminder
Version 1.0
 
Prepared By 
Atif Islam
& 
Muhammad Awais Ali
4th Jan, 2026 



















Revision History
Version	Description	Author	Date

1.0	This contains the  domain model for Personal Medicine Reminder App	Atif Islam
&
Muhammad Awais Ali	
4th Jan,2026









3.4 Domain Model
 











CHAPTER # 4: CONSTRUCTION














CLASS DIAGRAM

FOR
Personal Medicine Reminder
VERSION 1.0

Prepared by
Atif Islam
Muhammad Awais Ali

15th May,2026



















REVISION HISTORY
Version	Description	Author	Date
1.0	This covers the major Class Diagram	Atif Islam
&
Muhammad Awais Ali	15th May ,2026















4.1 Class Diagram
 







PROJECT CODE

FOR
Personal Medicine Reminder
VERSION 1.0

Prepared by
Atif Islam
Muhammad Awais Ali

15th May,2026
























REVISION HISTORY
Version	Description	Author	Date
1.0	This covers the major project code	Atif Islam
&
Muhammad Awais Ali	15th May ,2026
















4.2 Project Code (Business Logic)
4.2.1 Authentication
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/firebase_auth_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/realtime_database_service.dart';
import '../data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthController extends GetxController {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  var isLoading = false.obs;
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 8) return "Min 8 characters required";
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).*$').hasMatch(value)) {
      return "Must have 1 Uppercase & 1 Number";
    }
    return null;
  }
4.2.1.1 Process SignIn(Register)
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match", backgroundColor: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.signUp(email, password, name);
      if (user != null) {
        // Enforce Email Verification Requirement
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        // Redirect to Login to prevent unverified access
        Get.offAllNamed('/login');
        Get.snackbar("Success", "Account created! Verification link sent.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
4.2.1.2 Process Login
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        await user.reload();
        // Reject login if email remains unverified
        if (!user.emailVerified) {
          Get.snackbar("Verification Required", "Please verify your email first.");
          return;
        }
        // Generate Local Offline Session
        await HiveService.saveUserSession(user.uid);
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
4.2.1.3 Process Logout
  Future<void> logout() async {
    // Terminate Cloud Session
    await FirebaseAuth.instance.signOut();
    // Wipe Secure Local Tokens
    await HiveService.clearSession();
    // Redirect to Auth Gateway
    Get.offAllNamed('/login');
  }
}
4.2.1.4 Forget Password
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }
    isLoading.value = true;
    try {
      await _authService.sendPasswordResetEmail(email);
      Get.back();
      Get.snackbar("Email Sent", "Check your inbox for reset link");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
4.2.1.5 Change Password
  Future<void> updatePassword(
      String currentPass, String newPass, String confirmPass) async {
    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match");
      return;
    }
    String? error = validatePassword(newPass);
    if (error != null) {
      Get.snackbar("Weak Password", error);
      return;
    }
    isLoading.value = true;
    try {
      await _authService.changePassword(currentPass, newPass);
      Get.back();
      Get.snackbar("Success", "Password updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

4.2.1.6 Process SocialLogin
  Future<void> googleLogin() async {
    isLoading.value = true;
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        await HiveService.saveUserSession(user.uid);
        final existingUser = await _dbService.getUser(user.uid);
        if (existingUser == null) {
          // Profile does not exist -> Generate new compliant Profile Entity
          UserModel newUser = UserModel(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Google User',
            photoUrl: user.photoURL,
          );
          // Sync Cloud & Local Storage
          await _dbService.saveUser(newUser);
          await HiveService.saveUserProfile(newUser.toHiveMap());
        } else {
          // Profile exists -> Sync existing data
          await HiveService.saveUserProfile(existingUser.toHiveMap());
        }
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
4.2.2 Profile Management
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/services/realtime_database_service.dart';
import '../data/services/hive_service.dart';
import '../data/models/user_model.dart';
class ProfileController extends GetxController {
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  var isLoading = false.obs;
  // Edit Fields
  var pickedImage = Rxn<XFile>();
  var removePhoto = false.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedGender = 'Male'.obs;
  var selectedBloodGroup = 'A+'.obs;
  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  // Live BMI Tracker
  final RxString liveBMI = '0.0'.obs;
  @override
  void onInit() {
    super.onInit();
    heightController.addListener(_updateBMI);
    weightController.addListener(_updateBMI);
    loadProfile();
  }
4.2.2.1 View Profile
  // Retrieves the user's profile instantly from local Hive storage for offline 
  // capabilities, while simultaneously fetching the latest updates from the 
  // Firebase Realtime Database to ensure seamless cloud synchronization.
  void loadProfile() async {
    isLoading.value = true;
    String? uid = _auth.currentUser?.uid ?? HiveService.getUserId();
    if (uid == null) {
      isLoading.value = false;
      return;
    }
    // 1. Local Load (Instant display from Hive)
    var localData = HiveService.getUserProfile();
    if (localData != null) {
      currentUser.value = UserModel.fromMap(localData);
    }
    // 2. Cloud Sync (Realtime DB)
    if (_auth.currentUser != null) {
      try {
        UserModel? cloudUser = await _dbService.getUser(uid);
        if (cloudUser != null) {
          currentUser.value = cloudUser;
          await HiveService.saveUserProfile(cloudUser.toHiveMap());
        }
      } catch (e) {
        print("Sync error: $e");
      }
    }
    isLoading.value = false;
  }
4.2.2.2 Update Profile
  // Pre-populates the edit fields with the user's current data. When updated,
  // it pushes the new model to the Firebase Realtime Database and updates the 
  // local Hive cache, ensuring strict data consistency across both storage mediums.
  void prepareEditData() {
    final user = currentUser.value;
    removePhoto.value = false;
    if (user != null) {
      nameController.text = user.fullName;
      heightController.text = user.height?.toString() ?? '';
      weightController.text = user.weight?.toString() ?? '';
      selectedDate.value = user.dateOfBirth;
      if (user.gender != null) selectedGender.value = user.gender!;
      if (user.bloodGroup != null) selectedBloodGroup.value = user.bloodGroup!;
      _updateBMI();
    }
  }
  Future<void> updateProfile() async {
    if (currentUser.value == null) return;
    isLoading.value = true;
    try {
      UserModel updatedUser = UserModel(
        uid: currentUser.value!.uid,
        email: currentUser.value!.email,
        fullName: nameController.text.trim(),
        photoUrl: removePhoto.value
            ? ''
            : pickedImage.value?.path ?? currentUser.value?.photoUrl,
        gender: selectedGender.value,
        dateOfBirth: selectedDate.value,
        bloodGroup: selectedBloodGroup.value,
        height: double.tryParse(heightController.text),
        weight: double.tryParse(weightController.text),
        allergies: currentUser.value!.allergies,
        chronicIllnesses: currentUser.value!.chronicIllnesses,
        restraints: currentUser.value!.restraints,
      );
      // Save to Cloud and Sync Local Storage
      await _dbService.saveUser(updatedUser);
      await HiveService.saveUserProfile(updatedUser.toHiveMap());
      currentUser.value = updatedUser;
      Get.back();
      Get.snackbar("Success", "Profile updated!", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
4.2.2.3 Basic Health Information
  // Dynamically tracks and recalculates the user's Body Mass Index (BMI) in 
  // real-time as they adjust their height and weight. Also manages the CRUD 
  // operations for critical medical records (allergies, illnesses, restraints).
  void _updateBMI() {
    double h = double.tryParse(heightController.text) ?? 0;
    double w = double.tryParse(weightController.text) ?? 0;
    if (h <= 0 || w <= 0) {
      liveBMI.value = '0.0';
    } else {
      liveBMI.value = (w / ((h / 100) * (h / 100))).toStringAsFixed(1);
    }
  }
  Future<void> addAllergy(String allergy) async {
    if (currentUser.value == null || allergy.trim().isEmpty) return;
    currentUser.update((user) {
      user?.allergies.add(allergy.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }
  Future<void> removeAllergy(String allergy) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.allergies.remove(allergy);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }
  Future<void> addIllness(String illness) async {
    if (currentUser.value == null || illness.trim().isEmpty) return;
    currentUser.update((user) {
      user?.chronicIllnesses.add(illness.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }
  Future<void> removeIllness(String illness) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.chronicIllnesses.remove(illness);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }
  Future<void> addRestraint(String restraint) async {
    if (currentUser.value == null || restraint.trim().isEmpty) return;
    currentUser.update((user) {
      user?.restraints.add(restraint.trim());
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }
  Future<void> removeRestraint(String restraint) async {
    if (currentUser.value == null) return;
    currentUser.update((user) {
      user?.restraints.remove(restraint);
    });
    await HiveService.saveUserProfile(currentUser.value!.toHiveMap());
  }
  @override
  void onClose() {
    heightController.removeListener(_updateBMI);
    weightController.removeListener(_updateBMI);
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.onClose();
  }
}
4.2.2.4 Upload Photo
  // Handles gallery selection and strict file type validation (JPG, PNG, WEBP).
  // Critically, it compresses the image locally to optimize storage space and 
  // minimize bandwidth consumption before the profile is updated.
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    if (!_isSupportedImage(image.path)) {
      Get.snackbar('Unsupported Image', 'Select a JPG, PNG, or WEBP image.');
      return;
    }
    final XFile? compressedImage = await _compressImage(image);
    if (compressedImage != null) {
      pickedImage.value = compressedImage;
      removePhoto.value = false;
    }
  }
  bool _isSupportedImage(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') || lower.endsWith('.jpeg') ||
           lower.endsWith('.png') || lower.endsWith('.webp');
  }
  Future<XFile?> _compressImage(XFile image) async {
    try {
      final file = File(image.path);
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;
      final resized = img.copyResize(decoded, width: 800);
      final encoded = img.encodeJpg(resized, quality: 85);
final tempFile = File('${Directory.systemTemp.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(encoded);
      return XFile(tempFile.path);
    } catch (e) {
      return null;
    }
  }
  void removeImage() {
    pickedImage.value = null;
    removePhoto.value = true;
  }
4.2.3 Medicine Management
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/medicine_model.dart';
import '../data/models/medicine_log_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';
class MedicineController extends GetxController with WidgetsBindingObserver {
  var medicines = <MedicineModel>[].obs;
  var logs = <MedicineLogModel>[].obs;
  var isLoading = false.obs;
  // Form Controllers
  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final stockController = TextEditingController();
  final customTypeController = TextEditingController();
  var frequency = 'Daily'.obs;
  var reminderTimes = <TimeOfDay>[].obs;
  var selectedDays = <int>[].obs;
  var interval = 1.obs;
  var cycleOn = 21.obs;
  var cycleOff = 7.obs;
  var startDate = DateTime.now().obs;
4.2.3.1 Add & Update Medicine
  // Handles the creation and modification of medicine records. It processes the 
  // complex scheduling parameters (Cyclic, Specific Days, Intervals), updates the 
  // local database, and immediately synchronizes the native OS notifications.
  Future<void> saveMedicine({String? id}) async {
    if (nameController.text.isEmpty || dosageController.text.isEmpty) {
      Get.snackbar("Error", "Missing required fields");
      return;
    }
    isLoading.value = true;
    try {
      String type = selectedType.value == 'Other'
          ? customTypeController.text.trim()
          : selectedType.value;
      final med = MedicineModel(
        medicineId: id ?? const Uuid().v4(),
        name: nameController.text.trim(),
        dosage: dosageController.text.trim(),
        type: type,
        stock: int.tryParse(stockController.text) ?? 0,
        reminderTimes: _toDateTimeList(reminderTimes),
        frequencyType: frequency.value,
        specificDays: frequency.value == 'SpecificDays' ? selectedDays.toList() : null,
        interval: frequency.value == 'Interval' ? interval.value : null,
        cycleOnDays: frequency.value == 'Cyclic' ? cycleOn.value : null,
        cycleOffDays: frequency.value == 'Cyclic' ? cycleOff.value : null,
        startDate: startDate.value,
        isActive: true,
      );
      if (id == null) {
        await HiveService.addMedicine(med);
        Get.snackbar("Added", "${med.name} added to schedule!");
      } else {
        await HiveService.updateMedicine(med);
        Get.snackbar("Updated", "${med.name} details updated");
      }
      // Automatically sync notifications for this medicine
      _rescheduleNotifications(med);
      loadMedicines();
      Get.back();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  void prepareEdit(MedicineModel med) {
    nameController.text = med.name;
    dosageController.text = med.dosage;
    stockController.text = med.stock.toString();
    selectedType.value = defaultTypes.contains(med.type) ? med.type : 'Other';
    if (selectedType.value == 'Other') customTypeController.text = med.type;
    frequency.value = med.frequencyType;
    reminderTimes.value = med.reminderTimes.map((d) => TimeOfDay.fromDateTime(d)).toList();
    // (Other parameters populated similarly...)
  }
4.2.3.2 Set Medicine Reminder 
Scheduling
  // Cancels existing OS-level alarms and calculates the precise next valid 
  // occurrence based on the user's custom frequency logic (Daily vs Interval/Cyclic).
  void _rescheduleNotifications(MedicineModel med) {
    int baseId = med.medicineId.hashCode;    
    // Clear old ID range to prevent phantom alarms
    for (int i = 0; i < 20; i++) {
      NotificationService.cancel(baseId + i);
    }
    if (med.isActive) {
      for (int i = 0; i < med.reminderTimes.length; i++) {
        final timeOfDay = TimeOfDay.fromDateTime(med.reminderTimes[i]);
        if (med.frequencyType == 'Daily') {
          // Native Daily Recurrence for performance optimization
          DateTime scheduledDate = _getNextDailyTime(timeOfDay);
          NotificationService.scheduleMedicine(
            id: baseId + i,
            medicineId: med.medicineId,
            name: med.name,
            dosage: med.dosage,
            time: scheduledDate,
            repeat: Repeat.daily,
          );
        } else {
          // Manual calculation for complex recurring schedules
          final nextTime = _getNextValidOccurrence(med, timeOfDay);
          if (nextTime != null) {
            NotificationService.scheduleMedicine(
              id: baseId + i,
              medicineId: med.medicineId,
              name: med.name,
              dosage: med.dosage,
              time: nextTime,
              repeat: Repeat.none,
            );
          }
        }
      }
    }
  }
Action Handling
  // Acts as the callback receiver when a user interacts with a notification 
  // outside the app. Logs the dose as Taken, Missed, or Snoozes the alarm 
  // for 10 minutes.
  Future<void> handleNotificationAction(
      String action, String medId, DateTime scheduledTime) async {      
    final med = medicines.firstWhereOrNull((m) => m.medicineId == medId);
    if (med == null) return;
    final normalizedTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day,
        scheduledTime.hour, scheduledTime.minute);
    if (action == 'take') {
      await markAsTaken(med, normalizedTime, normalizedTime);
      _rescheduleNotifications(med); // Reschedule next occurrence
    } else if (action == 'miss') {
      await markAsSkipped(med, normalizedTime);
    } else if (action == 'snooze') {
      final snoozeTime = DateTime.now().add(const Duration(minutes: 10));
      int id = med.medicineId.hashCode + DateTime.now().millisecondsSinceEpoch;
      await NotificationService.scheduleMedicine(
        id: id,
        medicineId: med.medicineId,
        name: med.name,
        dosage: med.dosage,
        time: snoozeTime,
        repeat: Repeat.none,
      );
    }
  }


4.2.3.3 Remove/Disable Medicine Alert
  // Safely deactivates or completely deletes a medicine record. In both scenarios,
  // it rigorously cleans up the OS notification registry to ensure alarms do not
  // ring for disabled or deleted medications.
  Future<void> toggleStatus(MedicineModel med) async {
    med.isActive = !med.isActive;
    await HiveService.updateMedicine(med);
    if (med.isActive) {
      _rescheduleNotifications(med);
      Get.snackbar("Alerts On", "Reminders enabled");
    } else {
      int baseId = med.medicineId.hashCode;
      for (int i = 0; i < 20; i++) NotificationService.cancel(baseId + i);
      Get.snackbar("Alerts Off", "Reminders disabled");
    }
    medicines.refresh();
  }
  Future<void> deleteMedicine(MedicineModel med) async {
    int baseId = med.medicineId.hashCode;
    for (int i = 0; i < 20; i++) {
      NotificationService.cancel(baseId + i);
    }
    medicines.remove(med);
    await HiveService.deleteMedicine(med.medicineId);
    Get.snackbar("Deleted", "${med.name} removed");
  }
  // Completing a course sets active to false and preserves historical data
  Future<void> completeMedicine(MedicineModel med) async {
    med.isActive = false;
    med.dateEnded = DateTime.now();
    await HiveService.updateMedicine(med);
    int baseId = med.medicineId.hashCode;
    for (int i = 0; i < 20; i++) NotificationService.cancel(baseId + i);
    medicines.refresh();
  }
  // Utility helpers...
  Future<void> rescheduleAllNotifications() async {
    for (var med in medicines) {
      _rescheduleNotifications(med);
    }
  }
  List<DateTime> _toDateTimeList(List<TimeOfDay> times) {
    final now = DateTime.now();
    return times.map((t) => DateTime(now.year, now.month, now.day, t.hour, t.minute)).toList();
  }
  DateTime _getNextDailyTime(TimeOfDay timeOfDay) {
    DateTime now = DateTime.now();
    DateTime scheduledDate = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
 // Method signature for complex scheduling algorithm (simplified for documentation)
  DateTime? _getNextValidOccurrence(MedicineModel med, TimeOfDay time) {
    // Computes cyclic / interval dates ...
    return null; 
  }  
  // Method signatures for logging (simplified for documentation)
  Future<void> markAsTaken(MedicineModel med, DateTime date, DateTime timeSlot) async {}
  Future<void> markAsSkipped(MedicineModel med, DateTime scheduledTime) async {}}
4.2.4 Schedule Management
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/medicine_model.dart';
import '../data/models/appointment_model.dart';
import 'medicine_controller.dart';
import 'appointment_controller.dart';
enum ScheduleItemType { medicine, appointment }
enum ScheduleItemStatus { taken, missed, pending, upcoming }
class ScheduleItem {
  final String id;
  final ScheduleItemType type;
  final String title;
  final String subtitle;
  final DateTime scheduledTime;
  final ScheduleItemStatus status;
  final Color color;
  final String? category;
  const ScheduleItem({
    required this.id, required this.type, required this.title,
    required this.subtitle, required this.scheduledTime,
    required this.status, required this.color, this.category,
  });
}
class ScheduleController extends GetxController {
  late final MedicineController _medCtrl;
  late final AppointmentController _aptCtrl;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  @override
  void onInit() {
    super.onInit();
    _medCtrl = Get.find<MedicineController>();
    _aptCtrl = Get.find<AppointmentController>();
  }
4.2.4.1 View Calendar
  // Computes a set of dates that contain at least one scheduled event. 
  // The UI uses this to render 'dots' or highlights on the monthly calendar, 
  // giving users a birds-eye view of their upcoming commitments.
  Set<DateTime> get markedDates {
    final dates = <DateTime>{};
    for (final med in _medCtrl.medicines) {
      final rangeLength = rangeEnd.difference(rangeStart).inDays;
      for (int i = 0; i <= rangeLength; i++) {
        final d = rangeStart.add(Duration(days: i));
        if (_medCtrl.isScheduledForDate(med, d)) {
          dates.add(DateTime(d.year, d.month, d.day));
        }
      }
    }
    for (final apt in _aptCtrl.appointments) {
      dates.add(DateTime(apt.dateTime.year, apt.dateTime.month, apt.dateTime.day));
    }
    return dates;
  }
  // Utility logic
  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
  Future<void> markMedicineTaken(MedicineModel med, DateTime scheduledTime) async {
    await _medCtrl.markAsTaken(med, scheduledTime, scheduledTime);
  }
}

4.2.4.2 View Daily Schedule 
  // Dynamically generates the unified agenda for any given date. It iterates 
  // through all medicines and appointments, transforms them into abstract 
  // ScheduleItems, resolves their statuses (taken/missed/pending), and sorts 
  // them chronologically for the UI.
  List<ScheduleItem> scheduleForDate(DateTime date) {
    final items = <ScheduleItem>[];
    final dateKey = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    // 1. Process Medicine Doses
    for (final med in _medCtrl.medicines) {
      if (!_medCtrl.isScheduledForDate(med, dateKey)) continue;
      for (final timeSlot in med.reminderTimes) {
        final scheduled = DateTime(
          dateKey.year, dateKey.month, dateKey.day,
          timeSlot.hour, timeSlot.minute,
        );
        final taken = _medCtrl.isTaken(med.medicineId, dateKey, timeSlot);
        final isPast = scheduled.isBefore(now);
        ScheduleItemStatus status;
        if (taken) status = ScheduleItemStatus.taken;
        else if (isPast) status = ScheduleItemStatus.missed;
        else if (isSameDay(dateKey, _today)) status = ScheduleItemStatus.pending;
        else status = ScheduleItemStatus.upcoming;
        items.add(ScheduleItem(
          id: '${med.medicineId}_${scheduled.millisecondsSinceEpoch}',
          type: ScheduleItemType.medicine,
          title: med.name,
          subtitle: med.dosage,
          scheduledTime: scheduled,
          status: status,
          color: const Color(0xFF6C63FF),
          category: med.type,
        ));
      }
    }
    // 2. Process Appointments
    for (final apt in _aptCtrl.appointments) {
      final aptDate = DateTime(apt.dateTime.year, apt.dateTime.month, apt.dateTime.day);
      if (!isSameDay(aptDate, dateKey)) continue;
      ScheduleItemStatus status;
      if (apt.isCompleted) status = ScheduleItemStatus.taken; 
      else if (apt.dateTime.isBefore(now)) status = ScheduleItemStatus.missed;
      else status = ScheduleItemStatus.upcoming;
      items.add(ScheduleItem(
        id: apt.id,
        type: ScheduleItemType.appointment,
        title: apt.doctorName,
        subtitle: apt.category,
        scheduledTime: apt.dateTime,
        status: status,
        color: const Color(0xFF00BFA6),
        category: apt.category,
      ));
    }
    // Sort chronologically
    items.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return items;
  }
  // Reactive getter for the current view
  List<ScheduleItem> get itemsForSelectedDate => scheduleForDate(selectedDate.value);
4.2.4.3 View Date Schedule
  // Handles user interaction with the calendar. It rigorously checks the 
  // selected date against the allowed limits and rejects out-of-bounds dates 
  // with a visual warning to the user.
  void onDaySelected(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    if (d.isBefore(rangeStart) || d.isAfter(rangeEnd)) {
      Get.snackbar(
        'Out of Range',
        'Calendar is limited to 15 days past and future',
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
      );
      return;
    }
    selectedDate.value = d;
  }
4.2.4.4 Apply Date Range Limitation
  // Defines strict boundaries for the calendar (±15 days from today). 
  // This prevents infinite scrolling, reduces memory load when calculating 
  // complex cyclical patterns, and keeps the user focused on relevant data.
  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }
  DateTime get rangeStart => _today.subtract(const Duration(days: 15));
  DateTime get rangeEnd => _today.add(const Duration(days: 15));
4.2.5 User Health Records
import 'package:get/get.dart';
import '../data/services/hive_service.dart';
import '../data/models/user_model.dart';
import '../data/models/medicine_model.dart';
import 'profile_controller.dart';
import 'medicine_controller.dart';
class HealthRecordsLogic {
  final ProfileController profileCtrl = Get.find<ProfileController>();
  final MedicineController medicineCtrl = Get.find<MedicineController>();
4.2.5.1  Add Allergies list
  // Manages the user's known allergies. Updates are pushed to the user's 
  // reactive model and synced instantly to local Hive storage for offline 
  // access, ensuring critical data is always available.
  Future<void> addAllergy(String allergy) async {
    final user = profileCtrl.currentUser.value;
    if (user == null || allergy.trim().isEmpty) return;    
    profileCtrl.currentUser.update((u) {
      u?.allergies.add(allergy.trim());
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }
  Future<void> removeAllergy(String allergy) async {
    profileCtrl.currentUser.update((u) {
      u?.allergies.remove(allergy);
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }
4.2.5.2 View Current & Past Medications
  // Dynamically filters the global medicine list based on the 'isActive' flag.
  // Current medications are actively scheduled and trigger OS reminders, while
  // past medications represent completed courses preserved strictly for medical history.
  List<MedicineModel> get currentMedications {
    return medicineCtrl.medicines.where((med) => med.isActive).toList();
  }
  List<MedicineModel> get pastMedications {
    return medicineCtrl.medicines.where((med) => !med.isActive).toList();
  }
4.2.5.3 Add Restraint
  // Tracks medical restraints or contraindications (e.g., "Cannot take NSAIDs", 
  // "Allergic to Penicillin variants") which are critical for safe medicine scheduling.
  Future<void> addRestraint(String restraint) async {
    final user = profileCtrl.currentUser.value;
    if (user == null || restraint.trim().isEmpty) return;   
    profileCtrl.currentUser.update((u) {
      u?.restraints.add(restraint.trim());
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }
  Future<void> removeRestraint(String restraint) async {
    profileCtrl.currentUser.update((u) {
      u?.restraints.remove(restraint);
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }
}
4.2.5.4 Add Chronic Illness 
  // Maintains a record of long-term health conditions to provide essential 
  // context for the user's overall medication regimen.
  Future<void> addIllness(String illness) async {
    final user = profileCtrl.currentUser.value;
    if (user == null || illness.trim().isEmpty) return;  
    profileCtrl.currentUser.update((u) {
      u?.chronicIllnesses.add(illness.trim());
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }
  Future<void> removeIllness(String illness) async {
    profileCtrl.currentUser.update((u) {
      u?.chronicIllnesses.remove(illness);
    });
    await HiveService.saveUserProfile(profileCtrl.currentUser.value!.toHiveMap());
  }
4.2.6 Inventory Control
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/medicine_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';
class InventoryControlLogic extends GetxController {
  // Reactive list observing the global medication database
  var medicines = <MedicineModel>[].obs;
4.2.6.1 View Current Stock
  // Retrieves the active medication inventory. It uses a custom sorting 
  // algorithm to automatically bubble up medications with critically low 
  // stock (<= 5 doses) to the very top of the UI, ensuring immediate user visibility.
  List<MedicineModel> get sortedMedicines {
    List<MedicineModel> sorted = medicines.where((m) => m.isActive).toList();
    sorted.sort((a, b) {
      bool aLow = a.stock <= 5;
      bool bLow = b.stock <= 5;
      if (aLow && !bLow) return -1; // 'a' floats to the top
      if (!aLow && bLow) return 1;  // 'b' floats to the top
      return 0; // Maintains original order if both are fine or both are low
    });
    return sorted;  }
4.2.6.2 Update Current Stock
  // Allows users to manually overwrite stock quantities (e.g., after returning 
  // from a pharmacy refill). Instantly updates the local Hive database and 
  // triggers a reactive UI refresh.
  Future<void> updateStock(MedicineModel med, int newQty) async {
    med.stock = newQty;
    await HiveService.updateMedicine(med);
    medicines.refresh();
    Get.snackbar(
      "Stock Updated",
      "${med.name} stock set to $newQty",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 1500),
    );
  }
4.2.6.3 Generate Stock Alerts
  // This critical business logic fires every time a user marks a dose as 'Taken'. 
  // It handles automatic inventory deduction and checks against the low-stock threshold.
  // If the threshold is breached, it dispatches an urgent OS-level notification.
  Future<void> _processInventoryOnDoseTaken(MedicineModel med) async {
    if (med.stock > 0) {
      // 1. Auto-decrement stock upon consumption
      med.stock--;
      await HiveService.updateMedicine(med);
      medicines.refresh();    
      // 2. Low Quantity Alert Trigger
      if (med.stock <= 5) {
        // Dispatches a native system notification advising an immediate pharmacy refill
        NotificationService.showLowStockNotification(med);
      }
    }
  }
}

4.2.7   Appointment Management
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/appointment_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';
class AppointmentController extends GetxController {
  var appointments = <AppointmentModel>[].obs;
4.2.7.1 Add & Update Appointment
  // Consolidates form data (including rich visit notes) into a unified model.
  // It handles both the creation of new records and the modification of existing 
  // ones, seamlessly syncing them to the local Hive database.
  Future<void> saveAppointment({String? id}) async {
    final dt = DateTime(selectedDate.value.year, selectedDate.value.month,
       selectedDate.value.day, selectedTime.value.hour, selectedTime.value.minute);
    final newApt = AppointmentModel(
      id: id ?? const Uuid().v4(),
      doctorName: doctorController.text.trim(),
      category: selectedCategory.value,
      dateTime: dt,
      reminderMinutes: reminderOption.value > 0 ? reminderOption.value : null,
      visitNotes: notesController.text.trim(), // Captures specialized medical notes
      isCompleted: false,
      isRecurring: reminderOption.value > 0 && isRecurring.value,
      recurringFrequency: isRecurring.value ? recurringFrequency.value : null,
    );
    if (id == null) {
      await HiveService.addAppointment(newApt);
    } else {
      await HiveService.updateAppointment(newApt);
    }
    // Automatically trigger notification scheduling algorithm upon save
    _scheduleAlert(newApt);
    loadAppointments();
  }
4.2.7.2 Manage Appointment Categories/Status
  // Manually moves an active appointment into the historical archive.
  // Critically, it destroys any pending OS-level alarms to prevent the user 
  // from being erroneously reminded about a visit they have already concluded.
  Future<void> markCompleted(AppointmentModel apt) async {
    apt.isCompleted = true;
    await HiveService.updateAppointment(apt);    
    // Rigorously clean up native alarms
    NotificationService.cancel(apt.id.hashCode); 
    loadAppointments();
  }
}
4.2.7.3 Set Appointment Reminder 
  // Calculates the precise notification trigger time by subtracting the user's 
  // requested lead time (e.g., 60 minutes) from the actual appointment time. 
  // It natively supports both one-off alerts and recurring (Weekly/Monthly) schedules.
  void _scheduleAlert(AppointmentModel apt) {
    // 1. Cancel old alert first to strictly prevent phantom duplicate alarms
    NotificationService.cancel(apt.id.hashCode);
    // 2. Schedule new alarm if reminders are enabled
    if (apt.reminderMinutes != null && !apt.isCompleted) {
      final triggerTime = apt.dateTime.subtract(Duration(minutes: apt.reminderMinutes!));

      if (triggerTime.isAfter(DateTime.now())) {
        DateTimeComponents? repeatComponents;
        if (apt.isRecurring) {
          repeatComponents = apt.recurringFrequency == 'Weekly'
              ? DateTimeComponents.dayOfWeekAndTime
              : DateTimeComponents.dayOfMonthAndTime;
        }
        NotificationService.scheduleNotification(
          id: apt.id.hashCode,
          title: "Appointment: ${apt.doctorName}",
          body: "Your appointment is in ${apt.reminderMinutes} minutes.",
          scheduledTime: triggerTime,
          useShortSound: true, // Dynamically maps to user's sound preference inside service
          matchDateTimeComponents: repeatComponents,
        );
      }
    }
  }
4.2.7.4 View Appointment History
  // Dynamically filters the global appointment list. Upcoming appointments 
  // must be active and in the future. Past appointments include anything 
  // explicitly marked as completed or where the date has already physically passed.
  List<AppointmentModel> get upcomingAppointments => appointments
      .where((a) => !a.isCompleted && a.dateTime.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  List<AppointmentModel> get historyAppointments => appointments
      .where((a) => a.isCompleted || a.dateTime.isBefore(DateTime.now()))
      .toList()
    ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
4.2.8   Journaling & Motivation
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../data/models/journal_model.dart';
import '../data/models/streak_model.dart';
import '../data/services/gemini_service.dart';
import '../data/services/hive_service.dart';
import 'medicine_controller.dart';
class WellnessController extends GetxController {
  final MedicineController _medController = Get.find<MedicineController>();
  var journalHistory = <JournalModel>[].obs;
  var currentStreak = 0.obs;
  var maxStreak = 0.obs;
  var dailyChallenge = "Loading challenge...".obs;
  @override
  void onInit() {
    super.onInit();
    loadJournal();
    calculateStreak();
    generateDailyChallenge();
  }
4.2.8.1 Record Mood & Notes Journal
  // Captures the user's daily emotional state and custom notes.
  // Entries are immediately persisted to the local Hive database and 
  // automatically sorted chronologically (newest first) for the UI.
  Future<void> addEntry(String mood, String? note) async {
    final entry = JournalModel(
      id: const Uuid().v4(),
      date: DateTime.now(),
      mood: mood,
      note: note,
    );
    await HiveService.addJournal(entry);
    loadJournal(); // Reloads and sorts the history
    Get.snackbar("Saved", "Mood logged successfully!");
  }
  void loadJournal() {
    journalHistory.value = HiveService.getAllJournals();
    // Sort by date descending (newest at the top)
    journalHistory.sort((a, b) => b.date.compareTo(a.date));
  }
4.2.8.2 Attempt User Challenges
// Uses the Gemini AI Service to dynamically generate a personalized 
  // daily wellness challenge based on the user's current mood. Includes a 
  // robust offline/fallback mechanism (SRS-121) if the API is unreachable.
  Future<void> generateDailyChallenge() async {
    final fallbackChallenges = [
      "Drink 8 glasses of water today 💧",
      "Take a 15-minute walk outside 🚶",
      "Eat a colorful fruit or vegetable 🍎",
      "Meditate for 5 minutes 🧘",
    ];
    try {
      final mood = journalHistory.isNotEmpty ? journalHistory.first.mood : "neutral";
      final prompt =
          "Generate ONE short, motivating daily health challenge (max 12 words) for a medicine app user who is feeling \$mood today. Make it actionable, positive, and health-focused. Return only the challenge text with a relevant emoji at the end.";
      final text = await GeminiService.generateText(prompt);
      if (text != null) {
        dailyChallenge.value = text;
      } else {
        dailyChallenge.value = (fallbackChallenges..shuffle()).first;
      }
    } catch (e) {
      // Offline fallback
      dailyChallenge.value = (fallbackChallenges..shuffle()).first;
    }
  }
  Future<void> _saveStreak() async {
    // Implementation omitted for brevity
  }
}
4.2.8.3 Display Visual Streak Tracker
  // Evaluates historical medication logs to calculate consecutive days 
  // of 100% adherence. It checks each day backwards from today. 
  // A "perfect day" is defined as a day where every scheduled dose was taken.
  void calculateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int streak = 0;
    // Check Today first
    if (_wasPerfectDay(today)) streak++;
    // Check Yesterday backwards iteratively
    DateTime checkDate = today.subtract(const Duration(days: 1));
    while (_wasPerfectDay(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    currentStreak.value = streak;
    if (streak > maxStreak.value) maxStreak.value = streak;
    // Persist highest score
    _saveStreak();
  }
  bool _wasPerfectDay(DateTime date) {
    // Retrieves all medicines physically scheduled for the specific date
    final scheduledMeds = _medController.medicines
        .where((m) => _medController.isScheduledForDate(m, date))
        .toList();
    if (scheduledMeds.isEmpty) return false;
    // Cross-references each dose against the MedicineLog database
    for (var med in scheduledMeds) {
      for (var time in med.reminderTimes) {
        if (!_medController.isTaken(med.medicineId, date, time)) {
          return false; // Broken adherence
        }
      }
    }
    return true; // 100% Adherence achieved
  }
4.2.9   Patient Report Management
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import '../data/models/report_model.dart';
import '../data/services/hive_service.dart';
class ReportController extends GetxController {
  var reports = <ReportModel>[].obs;
  var filteredReports = <ReportModel>[].obs;
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;
  var selectedDate = Rxn<DateTime>();
  final List<String> categories = [
    'All',
    'Prescription',
    'Lab Result',
    'Other',
  ];
  @override
  void onInit() {
    super.onInit();
    loadReports();
  }
4.2.9.1 Add/Upload Report
  // Bridges the app with the native OS file system using FilePicker.
  // Securely logs the file's absolute path, category, and metadata into Hive.
  Future<void> pickAndAddReport({required String title, required String category}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final newReport = ReportModel(
        id: const Uuid().v4(),
        title: title,
        dateUploaded: DateTime.now(),
        category: category,
        filePath: filePath, // Stores a permanent reference to the local file
      );
      await HiveService.addReport(newReport);
      loadReports();
      Get.snackbar("Success", "Report added successfully.");
    }
  }

4.2.9.2 Search Report
  // Reactively cascades through the entire archive. Applies a triple-layer filter
  // combining Category matches, exact Date matches, and a fuzzy-string Search Query 
  // checking against both the Title and the formatted Date strings.
  void filterReports() {
    final query = searchQuery.value.toLowerCase().trim();
    final selectedCat = selectedCategory.value;
    final selectedDt = selectedDate.value;
    filteredReports.value = reports.where((r) {
      if (selectedCat != 'All' && r.category != selectedCat) return false; 
     if (selectedDt != null) {
        if (r.dateUploaded.year != selectedDt.year ||
            r.dateUploaded.month != selectedDt.month ||
            r.dateUploaded.day != selectedDt.day) {
          return false;
        }
      }
      if (query.isEmpty) return true;
      final dateLabel = DateFormat('dd MMM yyyy').format(r.dateUploaded);
      return r.title.toLowerCase().contains(query) ||
          r.category.toLowerCase().contains(query) ||
          dateLabel.toLowerCase().contains(query);
    }).toList();
    // Sort heavily prioritizes the most recently uploaded files
    filteredReports.sort((a, b) => b.dateUploaded.compareTo(a.dateUploaded));
  }
4.2.9.3 View Report
  // Intelligent dispatch system: Internalizes PDF rendering for seamless UX, 
  // but intelligently offloads obscure file types to the native OS handlers.
  Future<void> openReport(String filePath) async {
    if (filePath.toLowerCase().endsWith('.pdf')) {
      Get.toNamed('/reportPdf', arguments: filePath);
      return;
    }
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      Get.snackbar("Error", "Could not open file: \${result.message}");
    }
  }
4.2.9.4 Record Delete
  Future<void> deleteReport(String id) async {
    await HiveService.deleteReport(id);
    loadReports();
    Get.snackbar("Deleted", "Report removed.");
  }
}
4.2.10   ChatBot Assistant
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';
import '../data/models/chat_message_model.dart';
import '../data/services/gemini_service.dart';
import '../data/services/hive_service.dart';
import '../data/services/safety_rules_service.dart';
class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  var isLoading = false.obs;
  var isInitialized = false.obs;
  GenerativeModel? _model;
  ChatSession? _chat;
  // UC-41 / SRS-133 / SRS-134: Client-side safety pre-filter
  final SafetyRulesService _safetyRules = SafetyRulesService();
  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
    _initGemini();
    // SRS-134: Start listening for backend rule updates
    _safetyRules.startListening();
  }
4.2.10.1 Access Chat Interface
  // Sets up the Gemini API with strict system instructions
  // restricting the bot's persona strictly to health-related matters.
  void _initGemini() {
    try {
      _model = GeminiService.buildChatModel(
        systemInstruction:
            "You are a friendly, concise health assistant for a personal medicine reminder app called MedCare. "
            "Help users with medication questions, dosage reminders, health tips, and general wellness advice. "
            "IMPORTANT: Never provide emergency medical diagnosis — always advise consulting a doctor for serious concerns. ",
      );
      _chat = _model!.startChat();
      isInitialized.value = true;
    } catch (e) {
      isInitialized.value = false;
    }
  }
4.2.10.2 Apply Safety Filters & Rules
  // Handles incoming queries. Actively routes the string through a dynamic 
  // Safety Filter before passing it to the Gemini backend.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    // 1. Instantly render user message
    final userMsg = ChatMessageModel(
      id: const Uuid().v4(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMsg);
    _persistMessage(userMsg);
    isLoading.value = true;
    // 2. Pre-flight Safety Filter (SRS-133)
    // Aborts network request instantly if malicious/emergency terms are detected.
    if (_safetyRules.isBlocked(trimmed)) {
      isLoading.value = false;
      _addBotMessage(
        "🚨 I cannot answer this query. "
        "If this is an emergency, please call 911 or your local emergency services immediately.",
        isBlocked: true,
      );
      return;
    }
    // 3. Network Request Generation
    try {
      final response = await _chat!
          .sendMessage(Content.text(trimmed))
          .timeout(const Duration(seconds: 30));
      if (response.text != null && response.text!.isNotEmpty) {
        _addBotMessage(response.text!);
      }
    } on GenerativeAIException catch (e) {
      _addBotMessage("⚠️ API Error: Please try again later.");
      _restartChatSession();
    } catch (e) {
      _addBotMessage("⚠️ Network error. Please check your internet connection.");
      _restartChatSession();
    } finally {
      isLoading.value = false;
    }
  }
  // PERSISTENCE 
  // Silently caches the conversation via Hive for session restoration.
  void _persistMessage(ChatMessageModel msg) {
    HiveService.saveChatMessage(msg);
  }
}
4.2.11   Help & Support
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/orb_painter.dart';
import '../utils/app_theme_colors.dart';
class HelpSupportView extends StatefulWidget {
  const HelpSupportView({super.key});
  @override
  State<HelpSupportView> createState() => _HelpSupportViewState();
}
class _HelpSupportViewState extends State<HelpSupportView> with TickerProviderStateMixin 
4.2.11.1 View User Guide
// A clean, modular ExpansionTile system explaining core modules
  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required String content,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppThemeColors.glassBg(Brightness.dark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppThemeColors.glassBorder(Brightness.dark), width: 1.2),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: accentColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content),
          ),
        ],
      ),
    );
  }
4.2.11.2 Submit Contact/Feedback Form
  // Utilizes the url_launcher package to offload email composition to the user's 
  // native OS email client, prepopulating the subject and body for bug reports or feedback.
  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@medcare.com',
      queryParameters: {
        'subject': 'Feedback for Personal Medicine Reminder',
        'body': 'Hello Support Team, \\n\\n',
      },
    );
    if (!await launchUrl(emailLaunchUri)) {
      Get.snackbar(
        "Error",
        "Could not launch email client",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
4.2.11.3 View About Section
  // Displays critical app metadata including versions, developers, and copyright
  Widget _buildAboutCard() {
    return Column(
      children: [
        _buildInfoRow("Developers", "Atif Islam & Muhammad Awais Ali"),
        _buildInfoRow("Contact", "support@medcare.com"),
        _buildInfoRow("Copyright", "© 2026 MedCare"),
      ],
    );
  }  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
  }
}
4.2.12   Setting & Preferences
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:audioplayers/audioplayers.dart';
import '../data/models/notification_settings_model.dart';
import '../data/services/hive_service.dart';
import '../data/services/notification_service.dart';
import 'medicine_controller.dart';
import 'appointment_controller.dart';
class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  var currentTimeZone = "Unknown".obs;
  // Notification sound settings
  var selectedShortSound = 'mixkit_bell_notification_933'.obs;
  var selectedLongSound = 'mixkit_marimba_waiting_ringtone_1360'.obs;
  var useShortForMedicine = true.obs;
  var useShortForAppointments = false.obs;
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadNotificationSettings();
    _initTimeZone();
  }
4.2.12.1 Change App Theme 
  // Toggles the global GetX ThemeMode, updates the system UI overlay 
  // (status bar text color), and persists the choice in Hive.
  void toggleTheme(bool isDark) async {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
    var box = await Hive.openBox("settingsBox");
    await box.put("isDarkMode", isDark);
  }
4.2.12.2 Configure Notification Settings
  // Saves the selected audio profiles into Hive, physically rebuilds 
  // the Android Notification Channels to bypass OS-level channel locks, 
  // and dynamically reschedules all active alarms.
  Future<void> _saveNotificationSettings() async {
    final settings = NotificationSettingsModel(
      shortSoundName: selectedShortSound.value,
      longSoundName: selectedLongSound.value,
      useShortForMedicine: useShortForMedicine.value,
      useShortForAppointments: useShortForAppointments.value,
    );
    await HiveService.saveNotificationSettings(settings);
    // Recreate notification channels with the new sound
    await NotificationService.init();
    // Cancel ALL pending notifications and reschedule with new sound.
    // Required because Android locks a channel's sound after first creation.
    await NotificationService.cancelAll();
    try {
      final medController = Get.find<MedicineController>();
      await medController.rescheduleAllNotifications();
    } catch (_) {}
    try {
      final aptController = Get.find<AppointmentController>();
      await aptController.rescheduleAllNotifications();
    } catch (_) {}
  }
  // SOUND PREVIEW 
  // Live previews the chosen local asset using AudioPlayers
  Future<void> previewSound(String soundName, bool isShort) async {
    final fileName = soundName.replaceAll('_', '-');
    final ext = soundName.contains('marimba') ? '.mp3' : '.wav';
    final assetPath = isShort ? 'sounds/short/$fileName$ext' : 'sounds/long/$fileName$ext';
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(assetPath));
  }
  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
  }
}
4.2.12.3 Detect & Adjust Time Zone Detection
  // Automatically detects the device's current timezone to ensure
  // local notifications are fired accurately regardless of travel.
  Future<void> _initTimeZone() async {
    try {
      currentTimeZone.value = (await FlutterTimezone.getLocalTimezone()) as String;
    } catch (e) {
      currentTimeZone.value = "UTC (Fallback)";
    }
  }
4.2.13 Analytics & Data Visualization
import 'package:get/get.dart';
import '../data/models/medicine_log_model.dart';
import '../data/models/medicine_model.dart';
import '../data/services/hive_service.dart';
class AnalyticsController extends GetxController {
  var logs = <MedicineLogModel>[].obs;
  var medicines = <MedicineModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  void loadData() {
    logs.value = HiveService.getAllLogs();
    medicines.value = HiveService.getAllMedicines();
  }
  //FILTERS 
  // Global filter state modifying the underlying dataset for all charts
  var selectedMedicineId = 'All'.obs;
  var selectedPeriod = 'Monthly'.obs; // 'All', 'Daily', 'Weekly', 'Monthly'
  List<MedicineLogModel> getFilteredLogs() {
    var filtered = logs.toList();
    if (selectedMedicineId.value != 'All') {
      filtered = filtered.where((l) => l.medicineId == selectedMedicineId.value).toList();
    }
    final now = DateTime.now();
    if (selectedPeriod.value == 'Daily') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays == 0 && l.scheduledTime.day == now.day).toList();
    } else if (selectedPeriod.value == 'Weekly') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays < 7).toList();
    } else if (selectedPeriod.value == 'Monthly') {
      filtered = filtered.where((l) => now.difference(l.scheduledTime).inDays < 30).toList();
    }
    return filtered;
  }
4.2.13.1 View Medicine Consumption Reports
  // Generates aggregated status distribution (Taken vs Missed) specifically 
  // formatted for the Overview Pie Chart.
  Map<String, double> getStatusDistribution() {
    final filtered = getFilteredLogs();
    if (filtered.isEmpty) {
      return {'Taken': 0, 'Missed': 0, 'Skipped': 0};
    }
    int taken = filtered.where((l) => l.status == 'Taken').length;
    int skipped = filtered.where((l) => l.status == 'Skipped' || l.status == 'Miss' || l.status == 'Missed').length;
    return {
      'Taken': taken.toDouble(),
      'Missed': skipped.toDouble(),
    };
  }

4.2.13.2 View Missed Doses Report
  // Proactively scans the last 28 days to isolate specific medications 
  // suffering from an irregular intake rate (>30% missed rate).
  List<Map<String, dynamic>> getIrregularMedicines() {
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(days: 28));
    final recentLogs = logs.where((l) => l.scheduledTime.isAfter(cutoff)).toList();
    final Map<String, List<MedicineLogModel>> logsByMed = {};
    for (var log in recentLogs) {
      logsByMed.putIfAbsent(log.medicineId, () => []).add(log);
    }
    final List<Map<String, dynamic>> irregular = [];
    for (final entry in logsByMed.entries) {
      final medLogs = entry.value;
      final total = medLogs.length;
      if (total < 3) continue; // Minimum baseline required to flag
      final missed = medLogs.where((l) => l.status == 'Skipped' || l.status == 'Miss' || l.status == 'Missed').length;
      final missedRate = missed / total;
      if (missedRate > 0.30) {
        irregular.add({
          'name': getMedicineName(entry.key),
          'missedRate': missedRate,
          'missed': missed,
          'total': total,
        });
      }
    }
    // Sort primarily by highest missed rate
    irregular.sort((a, b) => (b['missedRate'] as double).compareTo(a['missedRate'] as double));
    return irregular;}}
4.2.13.3 Display Monthly Summary(Charts)
  // Processes logs over a rolling 28-day window and buckets them into 4 distinct weeks.
  // Outputs nested maps containing exact 'taken' and 'missed' counts per week 
  // for the stacked Bar Chart visualization.
  Map<int, Map<String, int>> getMonthlyWeeklyCounts() {
    final now = DateTime.now();
    final Map<int, Map<String, int>> weekData = {
      0: {'taken': 0, 'missed': 0},
      1: {'taken': 0, 'missed': 0},
      2: {'taken': 0, 'missed': 0},
      3: {'taken': 0, 'missed': 0},
    };
    for (var log in logs) {
      final diff = now.difference(log.scheduledTime).inDays;
      if (diff < 0 || diff >= 28) continue;
      final weekIndex = 3 - (diff ~/ 7); // 3=this week, 0=3 weeks ago
      if (log.status == 'Taken') {
        weekData[weekIndex]!['taken'] = (weekData[weekIndex]!['taken'] ?? 0) + 1;
      } else if (log.status == 'Skipped' || log.status == 'Miss' || log.status == 'Missed') {
        weekData[weekIndex]!['missed'] = (weekData[weekIndex]!['missed'] ?? 0) + 1;
      }
    }
    return weekData;
  }



















CHAPTER # 5: TESTING

















Test Case
 						FOR
Personal Medicine Reminder
VERSION 1.0

Prepared by
Atif Islam
Muhammad Awais Ali

3rd June,2026


























REVISION HISTORY
Version	Description	Author	Date
1.0	This covers the major Test case	Atif Islam 
&
Muhammad Awais Ali	3rd June, 2026
















5.1 Test Case
TC-01 Process SignIn 
Test case ID:	TC-01
Test Case Name:	Process SignIn
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that a new user can register a secure, unique account by providing name, email, password, and confirm password.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User clicks register or sign up button.		
2- 	User enters name, email, password, and confirm password.		
		3- 	System validates all mandatory fields. Checks password strength (min 8 chars, 1 uppercase, 1 number) and uniqueness of email.
4- 	User submits registration.		
		5- 	System creates the account in Firebase Auth, sends verification email, and redirects to Login screen.
Testing Requirement:
Testing Condition:	System must be in running state and connected to internet. Email must not be already registered.
Input Data:	Full Name, Email Address, Password, Confirm Password
Expected Result:	Account created in Firebase, email verification sent, and user redirected to Login screen.
Actual Result:	Account successfully created and verification email received.
Priority:	High.
Frequency:	Less frequent
Test Acceptance:	Passed

TC-02 Process Login 
Test case ID:	TC-02
Test Case Name:	Process Login 
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that a registered user can log in by providing valid email and password. Blocks login if email is not verified.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User inputs registered email and password. Taps "Login".		
		2- 	System validates credentials against Firebase Auth. Checks email verification status.
		3- 	If email is verified, user session is started and redirected to Home/Dashboard. If not verified, login is blocked and resend link is offered.
Testing Requirement:
Testing Condition:	User must have a registered account. System must have internet connection.
Input Data:	Email, Password
Expected Result:	Successful login redirects user to home screen dashboard. Invalid inputs show precise validation/credential error toast.
Actual Result:	User authenticated successfully and navigated to home dashboard.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed

TC-03 Process Logout 
Test case ID:	TC-03
Test Case Name:	Process Logout
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that an authenticated user can securely terminate their session via the profile settings.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1-	User navigates to profile, scrolls to bottom, and taps "Logout".		
		2- 	System signs out from Firebase, clears local authentication tokens/caches.
		3- 	System redirects user back to the Login screen, disabling back navigation to authenticated pages.
Testing Requirement:
Testing Condition:	User must be logged in.
Input Data:	None
Expected Result:	User session ended, tokens cleared, navigated to login.
Actual Result:	User session cleared and redirected to login screen immediately.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed

TC-04 Forget Password 
Test case ID:	TC-04
Test Case Name:	Forget Password
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that a user can request a password reset email link for their registered account.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User clicks "Forgot Password" link on the login screen.		
2- 	User enters registered email address and taps "Send Link".		
	3- 	System checks if email exists in Firebase database. Sends reset email. Shows confirmation message.
Testing Requirement:
Testing Condition:	Active internet connection. Email must be correct format.
Input Data:	Registered Email
Expected Result:	Reset link sent, user receives email, and user can complete reset via link.
Actual Result:	Password reset email sent and received. User redirected to login.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-05 Change Password 
Test case ID:	TC-05
Test Case Name:	Change Password
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that a logged-in user can change their password through profile settings. Restricts Google-authenticated users.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User goes to profile settings, clicks Change Password.		
2- 	User inputs current password, new password, and confirms it. Saves change.		
	3- 	System checks if current password is correct. Validates new password criteria (8 chars, 1 uppercase, 1 number). Updates database and displays success message.
Testing Requirement:
Testing Condition:	User must be logged in. Not applicable for Google sign-in accounts (option must be disabled/hidden).
Input Data:	Current Password, New Password, Confirm Password
Expected Result:	Password updated and success message displayed. Incorrect old password or mismatch triggers error message.
Actual Result:	Password updated successfully. Option disabled on profile for Google accounts.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-06 Process SocialLogin 
Test case ID:	TC-06
Test Case Name:	Process SocialLogin (Google)
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that a user can sign in using their Google account. Auto-registers new users and logs in existing users.
Primary Actor:	<Patient>
Main success scenario:
User Action			System Response
1-	User clicks "Sign in with Google" button.		
2- 	User selects their Google account and authorizes access.		
		3- 	System retrieves Google profile information (Name, Email). Checks database for matches.
		4- 	Logs user in directly if registered, otherwise registers details and redirects to Home dashboard. Flags user as SocialLogin (disabling local password edits).
Testing Requirement:
Testing Condition:	Device must have internet connection and Google services enabled.
Input Data:	Google Authentication credentials
Expected Result:	Successful login or automatic registration, and redirection to Home dashboard.
Actual Result:	User logged in/registered with Google, redirected to Home.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed

TC-07 View Profile 
Test case ID:	TC-07
Test Case Name:	View Profile
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that the profile tab displays full name, email, blood group, height, weight, BMI, gender, DOB, and profile photo.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User clicks on Profile tab from the bottom navigation menu.		
		2- 	System retrieves user information and basic health info from Firebase and local database cache.
		3- 	System calculates BMI automatically based on height and weight.
		4- 	System renders profile screen with name, email, health metrics, and profile avatar. Shows placeholders for empty items.
Testing Requirement:
Testing Condition:	User must be logged in.
Input Data:	None
Expected Result:	User health stats, calculated BMI, and photo are fetched and displayed accurately.
Actual Result:	Profile loaded. Weight/height rendered, and BMI matches calculations.
Priority:	High.
Frequency:	High frequent
Test Acceptance:	Passed

TC-08 Update Profile 
Test case ID:	TC-08
Test Case Name:	Update Profile
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that a user can update their personal information and successfully save the changes to Firebase.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User clicks Edit Profile on Profile screen.		
2- 	User updates name, gender, blood group, height, weight, and DOB, then clicks Save.		
		3-	System recalculates BMI. Validates input values. Saves changes to Firebase Realtime DB and local cache
		4- 	System displays success confirmation toast, and redirects user back to the View Profile screen.
Testing Requirement:
Testing Condition:	User must be logged in. Fields must not contain empty or invalid values.
Input Data:	Updated Name, DOB, Gender, Weight, Height, Blood Group
Expected Result:	Profile data successfully updated in database and changes immediately visible on profile view.
Actual Result:	Profile updated successfully and reflected in View Profile view.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed


TC-09 Manage Basic Health Information 
Test case ID:	TC-09
Test Case Name:	Manage Basic Health Information
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that the system calculates BMI correctly when height (cm) and weight (kg) are entered, and saves values to database.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User enters weight in kilograms (e.g. 70) and height in centimeters (e.g. 175) on Edit Profile screen.		
		2- 	System automatically calculates BMI in real-time ($BMI = weight / (height/100)^2 = 22.86$) and displays it.
3- 	User selects blood group from predefined list and clicks Save.		
		4- 	System validates entries. Saves health information securely in Firebase. Displays confirmation message.
Testing Requirement:
Testing Condition:	Inputs must be positive numbers. Selectable blood group from dropdown list.
Input Data:	Height (cm), Weight (kg), Blood Group (Dropdown)
Expected Result:	BMI calculated and health parameters saved successfully. Zero/negative inputs trigger validation errors.
Actual Result:	Metrics saved. Invalid values caught by client validation filters.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed


TC-10 Upload Profile Photo 
Test case ID:	TC-10
Test Case Name:	Upload Profile Photo
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can pick an image from their device gallery, crop/resize it, upload it, and update profile visual.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User clicks on profile image in Edit Profile and selects "Choose from Gallery".		
2- 	User selects a valid image file (JPG/PNG).		
		3- 	System checks image file type, resizes/compresses the image to optimize storage, and saves photo reference URL locally/Firebase.
		4- 	System updates the profile views to show the newly selected picture immediately. Option to remove photo exists.
Testing Requirement:
Testing Condition:	Supported format (JPG, PNG). File must be readable.
Input Data:	Selected Image File
Expected Result:	Image uploaded, and profile picture updated on the view. Unsupported file formats show validation warning.
Actual Result:	Image compressed, stored, and displayed immediately on profile.
Priority:	Low.
Frequency:	Less frequent
Test Acceptance:	Passed

TC-11 Add Medicine 
Test case ID:	TC-11
Test Case Name:	Add Medicine
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that a user can add a new medicine by specifying name, dosage, category, complex schedules, and initial stock.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1-	User navigates to Add Medicine screen		
2- 	User inputs Medicine Name, Dosage (e.g. 500mg), Category, complex schedule options (e.g. Specific Days or Intervals), multiple reminders, and stock. Saves medicine.		
		3- 


	System validates required inputs. Saves medicine object locally in Hive database.
		4- 	System triggers local notification manager to register reminder alarms. Displays confirmation dialog/toast.
Testing Requirement:
Testing Condition:	Database must have write access. Mandatory fields (Name, dosage, schedule) must not be empty.
Input Data:	Medicine Name, Dosage, Category, Schedule settings, Reminder Times, Initial Stock count
Expected Result:	Medicine added successfully, notifications scheduled, and confirmation shown. Empty fields trigger input warnings.
Actual Result:	Medicine recorded in Hive database, schedule set, and success dialog triggered.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed

TC-12 Update Medicine Details 
Test case ID:	TC-12
Test Case Name:	Update Medicine Details
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that a user can update dosage, name, category, or reminder intervals of an existing medicine.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User selects medicine from list and clicks edit/update details.		
2- 	User updates name, category, dosage or updates reminder schedule, then clicks save.		
		3- 	System checks input validation. Rewrites record in local Hive storage.
		4- 	System cancels old active notification alarms, registers new notifications, and displays success toast.
Testing Requirement:
Testing Condition:	Medicine record must exist. New values must be valid.
Input Data:	Modified fields (Name, Dosage, Schedule, etc.)
Expected Result:	Medicine data updated, previous alarms cancelled, new alerts programmed.
Actual Result:	Medicine updated and new alarms programmed in system notification service.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed

TC-13 Set Medicine Reminder 
Test case ID:	TC-13
Test Case Name:	Set Medicine Reminder
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that notifications trigger per schedule (pre, exact, post-dose alerts) and accept user action choices.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	System reaches the scheduled dose reminder time.		
		2- 	System triggers local notification sound and pops up alert panel with "Take", "Snooze", and "Missed" options.
3- 	User taps "Take" on notification.		
		4- 	System registers dose as completed/taken locally. Cancels subsequent post-dose alerts for this specific schedule.
Testing Requirement:
Testing Condition:	Notification permission granted. Background execution enabled.
Input Data:	Dose Action Choice ("Take" / "Snooze" / "Missed")
Expected Result:	Alarms play sound, action buttons record choice, dose state updates inside DB. Tapping "Snooze" reschedules alarm for later.
Actual Result:	Notification triggered. Tapping "Take" marked the dose taken and updated streak logs.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed

TC-14 Disable Medicine Alert 
Test case ID:	TC-14
Test Case Name:	Disable Medicine Alert
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can disable alerts for a medicine while retaining the medicine record inside inventory.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User selects medicine details, switches the "Alerts Active" toggle to OFF.		
		2- 	System cancels all pending scheduled notifications for this specific medicine from background alarm queue.
		3- 	System updates the flags locally in Hive. Displays confirmation toast. Keeps medicine active in lists.
Testing Requirement:
Testing Condition:	Medicine record must exist with active reminders.
Input Data:	Toggle Alerts Option (Boolean)
Expected Result:	Alarms deactivated. Medicine still viewable in inventory/lists. No alarms fired thereafter.
Actual Result:	Alarms successfully cancelled. Medicine remains listed.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-15 Categorize Medicine 
Test case ID:	TC-15
Test Case Name:	Categorize Medicine
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can assign categories (Tablet, Syrup, Injection, Insulin) or input custom categories under "Other".
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens Category field dropdown in Add/Edit Medicine view.		
2- 	User selects predefined category, or selects "Other" and inputs a custom category name (e.g. Inhaler).		
		3- 	System maps category text to field. Saves selection locally with medicine object. Renders custom icons/details.
Testing Requirement:
Testing Condition:	Selection field active. Custom text fields must not contain symbols.
Input Data:	Dropdown Selection / Custom Category text input
Expected Result:	Category assigned to medicine record, displayed in lists, and saved locally.
Actual Result:	Category assigned correctly and custom categories displayed.
Priority:	Low.
Frequency:	Less frequent
Test Acceptance:	Passed

TC-16 View Calendar
Test case ID:	TC-16
Test Case Name:	View Calendar
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can open schedule view and check monthly/weekly calendar containing colored indicator markers for active tasks.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User clicks on Schedule/Calendar tab from navigation.		
		2-	System queries Hive database for active medicine alerts and doctor appointments.
		3- 	System highlights dates on calendar containing events (e.g. medicine doses or clinic schedules) using color dots/icons.
Testing Requirement:
Testing Condition:	User must be logged in. Local database contains records.
Input Data:	None
Expected Result:	Calendar loaded with event indicator highlights corresponding to scheduled items.
Actual Result:	Calendar rendered with indicator dots showing schedules.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed

TC-17 View Daily Schedule 
Test case ID:	TC-17
Test Case Name:	View Daily Schedule
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that daily schedule lists all medicine doses and appointments scheduled for the current system date.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User views Home or Schedule main view.		
		2- 	System fetches current system date from device settings.
		3- 	Queries local database. Generates sorted list of all active medicine reminder slots and appointments for the current day. Displays chronological list.
Testing Requirement:
Testing Condition:	System date must be configured.
Input Data:	None
Expected Result:	All active schedules for today are displayed. If no events exist, a clean empty-state greeting card is displayed.
Actual Result:	Cron-list for today rendered cleanly showing medicine categories and times.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed
TC-18 View Date Schedule 
Test case ID:	TC-18
Test Case Name:	View Date Schedule
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can click a date on the calendar, filtering and displaying events scheduled for that specific day.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User taps on a specific date tile in Calendar view.		
		2- 	System captures selected date. Queries database records for matching date parameters.
		3- 	Updates screen with detailed list of medicines, scheduled doses, and doctor visits for selected date.
Testing Requirement:
Testing Condition:	Selected date must fall within calendar bounds.
Input Data:	Selected Calendar Date
Expected Result:	List updates immediately on click with correct records. Empty date displays "No items scheduled for this date."
Actual Result:	Date selected, and items display correctly.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed

TC-19 Apply Date Range Limitation 
Test case ID:	TC-19
Test Case Name:	Apply Date Range Limitation
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that calendar limits views to 15 days of past data and 15 days of future data relative to the current date.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1-	User opens Calendar view and attempts to scroll beyond 15 days in past or 15 days in future.		
		2- 	System detects current date. Limits the table calendar page navigation range to CurrentDate - 15 to CurrentDate + 15.
		3-	Prevents further swipe actions and greys out dates outside range boundaries.
Testing Requirement:
Testing Condition:	Table Calendar controller must apply range limits in state builder.
Input Data:	Scroll/Swipe gesture action
Expected Result:	User restricted from accessing days outside range. Only 31 days (past 15 + today + future 15) are selectable.
Actual Result:	Calendar range restricted to ±15 days, scrolling blocked past boundary.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-20 Add Allergies List 
Test case ID:	TC-20
Test Case Name:	Add/Update Allergies List
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can record, view, and update list of active food/drug allergies in Health Records.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User goes to Health Records tab, selects Allergies.		
2- 	User types allergy details (e.g. Penicillin) and clicks Add.		
		3- 	System validates entry text format, adds allergy string, updates local storage, and renders it in the list.
Testing Requirement:
Testing Condition:	Input must contain text. Duplicate entries should be filtered.
Input Data:	Allergy String Value
Expected Result:	Allergy added to local database, view lists item immediately. User can remove item with delete icon.
Actual Result:	Allergy added to database and listed in the UI. Delete deletes item successfully.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-21 View Current Medication 
Test case ID:	TC-21
Test Case Name:	View Current Medication
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system displays active medications, letting user mark active medicines as complete.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens current medication screen.		
		2- 	System queries Hive, lists active medicine names, dosages, and schedules.
3- 	User selects a medicine, toggles status or taps "Mark as Complete".		
		4- 	System flags record as complete, stops alarms, and moves item to history database segment.
Testing Requirement:
Testing Condition:	Medication items must be in database.
Input Data:	Status Toggle Action
Expected Result:	Medication status changed in DB, and list updates dynamically without page reloads.
Actual Result:	Medicine marked completed, removed from active screen, and moved to medication history.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-22 View Past Medication 
Test case ID:	TC-22
Test Case Name:	View Past Medication
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that the system displays previous medications, updating lists automatically when active medicine is set as complete.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User views Medication History/Past Medication tab in Health Records.		
		2- 	System queries Hive, lists completed/ended medicines showing completion dates.
Testing Requirement:
Testing Condition:	Completed medicine logs must exist in local database.
Input Data:	None
Expected Result:	Past records displayed accurately. Newly completed medicines appear at the top of the history list.
Actual Result:	History list populated. Records reflect correct dates/times when marked completed.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-23 Add Restraints 
Test case ID:	TC-23
Test Case Name:	Add Restraints
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can record medication restrictions or dietary restraints in health records database.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens Restraints card in health records editor.		
2- 	User types dietary or drug restrictions (e.g. "No Grapefruit juice with medications") and saves.		
		3- 	System validates entry, writes record locally, and renders item on list.
Testing Requirement:
Testing Condition:	Inputs must be plain text.
Input Data:	Restraint detail text string
Expected Result:	Restraints text successfully stored and visible on dashboard/health records profile.
Actual Result:	Restraints info saved locally in Hive and displayed in Health Records.
Priority:	Low.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-24 Add Chronic Illnesses 
Test case ID:	TC-24
Test Case Name:	Add Chronic Illnesses
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can add, view, and update list of active chronic illnesses (Diabetes, Hypertension).
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User selects Chronic Illnesses card in Health Records interface.		
2- 	User types chronic illness title (e.g. Hypertension) and clicks Add.		
		3- 	System verifies entry, writes records to database, and appends card item to the list.
Testing Requirement:
Testing Condition:	Text input must not be empty.
Input Data:	Illness title text value
Expected Result:	Chronic illness saved, item added to view, and deletable using close icon.
Actual Result:	Illness added and visible in list. Deletion works as expected.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-25 View Current Stock 
Test case ID:	TC-25
Test Case Name:	View Current Stock
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system displays a list of medicines with current stock quantities, highlighting items with stock <= 5 at the top.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens Inventory tab.		
		2- 	System queries Hive database for all recorded medicines and their stock amounts.
		3-	System checks threshold limits. Lists medicines with stock <= 5 at the top of the view in a dedicated red-coded "Low Stock" list, followed by other medicines.
Testing Requirement:
Testing Condition:	Inventory items must be in database.
Input Data:	None
Expected Result:	Stock inventory display renders accurately with low stock items sorted and highlighted at the top.
Actual Result:	Stock counts rendered. Low stock items highlighted in red.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-26 Update Current Stock 
Test case ID:	TC-26
Test Case Name:	Update Current Stock
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can increase or decrease the stock quantity for a selected medicine and save it.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User selects medicine from Inventory list and clicks stock counter buttons (+ / -) or edits stock field.		
2- 	User updates quantity (e.g. increments stock from 3 to 30) and clicks Save.		
		3- 	System checks input validation (must be non-negative integer), updates value in Hive DB, and displays confirmation toast. Updates views immediately.
Testing Requirement:
Testing Condition:	Target medicine must exist. Stock must be positive integer.
Input Data:	Adjusted quantity value
Expected Result:	Stock level updated in Hive and low stock status recalculated immediately.
Actual Result:	Stock updated. Medicine shifted from "Low Stock" to "Good Stock" list when replenished.
Priority:	High.
Frequency:	Average
Test Acceptance:	Passed

TC-27 Generate Stock Alerts  
Test case ID:	TC-27
Test Case Name:	Generate Stock Alerts
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system automatically triggers a warning alert when stock quantity drops to or below 5 during dose logs.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User registers a dose intake ("Take"), reducing remaining stock count.		
		2- 	System calculates new stock level. If stock <= 5, system triggers low-stock push notification alert immediately.
		3- 	Places the medicine inside the dedicated "Low Stock" dashboard widgets for immediate reference.
Testing Requirement:
Testing Condition:	Inventory alerts toggle must be enabled.
Input Data:	Dose log confirmation input ("Take")
Expected Result:	Push notification alert fired when stock drops to 5 or lower. Widget updates instantly.
Actual Result:	Alert notification received in tray when stock reached 5.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-28 Add Appointment 
Test case ID:	TC-28
Test Case Name:	Add Appointment
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can add new appointments detailing doctor name, clinic, category, date, time, and reminder options.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1-	User clicks "Add Appointment" button in Appointments view.		
2- 	User enters Doctor/Clinic name, selects category, configures Date/Time, and sets alert reminder (e.g. 30 mins before). Clicks Save.		
		3- 	System checks input validation. Saves record locally. Programs alarm manager for notification. Shows success message.
Testing Requirement:
Testing Condition:	Inputs must be valid. Date must not be in past for new appointments.
Input Data:	Doctor Name, Date, Time, Category, Reminder interval
Expected Result:	Appointment saved in database. Scheduled alarm is registered. Success confirmation displayed.
Actual Result:	Appointment successfully registered and visible in list.
Priority:	High.
Frequency:	Average
Test Acceptance:	Passed

TC-29 Update Appointment 
Test case ID:	TC-29
Test Case Name:	Update Appointment
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can update date, time, notes, clinic, or reminder alarms of an existing appointment.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User selects appointment from list and clicks edit icon.		
2- 	User updates time, category, or adds notes, then clicks save.		
		3- 	System checks input validation. Updates local Hive database. Cancels old alerts and schedules new alarms. Shows success confirmation.
Testing Requirement:
Testing Condition:	Appointment record must exist.
Input Data:	Modified fields (Date, notes, etc.)
Expected Result:	Appointment modified correctly, old notifications replaced by new ones.
Actual Result:	Appointment details modified and alarms rescheduled successfully.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-30 Manage Appointment categories/Status 
Test case ID:	TC-30
Test Case Name:	Manage Appointment Categories / Status
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that appointments are categorized as "Upcoming" or "Completed" and users can manually mark them completed.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User views Appointments screen dashboard.		
		2- 	System compares appointment date/time with current date. Categorizes events automatically (Upcoming shown first).
3- 	User selects an upcoming appointment, clicks "Mark as Completed".		
		4-	System updates status flag inside Hive DB. Moves record to Completed/History segment instantly.
Testing Requirement:
Testing Condition:	Appointments must exist in lists.
Input Data:	Status toggle confirmation click
Expected Result:	Status flag updated, list filters updated, and appointment moved to completed category.
Actual Result:	Appointment marked completed and shifted to History tab cleanly.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-31 Set Appointment Reminder 
Test case ID:	TC-31
Test Case Name:	Set Appointment Reminder
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system fires push notification reminder at configured interval before the appointment. Supports recurring settings.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1-	User defines notification alert time (e.g. 1 hour before) in Appointment settings.		
		2- 	System configures background notification alarm triggers.
3- 	System clock reaches the reminder threshold (e.g. 1 hour prior to appointment).		
		4- 	System triggers appointment notification alert showing doctor details, clinic location, and visit notes.
Testing Requirement:
Testing Condition:	System permissions for notifications allowed. Device background process active.
Input Data:	Reminder interval value
Expected Result:	Alert sounds and notifies user in system tray exactly at set time.
Actual Result:	Push notification received successfully in device status bar.
Priority:	High.
Frequency:	Average
Test Acceptance:	Passed

TC-32 Add Visit Notes 
Test case ID:	TC-32
Test Case Name:	Add Visit Notes
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can write clinical notes, prescriptions, or preparation instructions inside appointment details.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens Appointment editor view.		
2- 	User enters notes inside the Visit Notes editor box (e.g. "Fast 12 hours before blood sample collection") and clicks save.		
		3- 	System saves notes string mapped with appointment object in Hive. Displays updated notes field on appointment details card.
Testing Requirement:
Testing Condition:	Inputs must be text.
Input Data:	Notes String Value
Expected Result:	Visit notes saved and readable inside appointment details/history card views.
Actual Result:	Visit notes saved successfully and readable on the details card.
Priority:	Low.
Frequency:	Average
Test Acceptance:	Passed

TC-33 View Appointment History 
Test case ID:	TC-33
Test Case Name:	View Appointment History
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system displays history of completed appointments, with search and filter capabilities.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens Completed Appointments view.		
		2- 	System queries Hive, fetches completed appointment cards, and displays them.
3- 	User types a query in the search bar (e.g. Cardiologist) or filters by category.		
		4- 	System filters database records instantly, updating list view. Displays matching results.
Testing Requirement:
Testing Condition:	Completed appointments must exist in database.
Input Data:	Search string / Category filters
Expected Result:	History list populated. Search filters list accurately by doctor name or category.
Actual Result:	History view displayed. Search displays correct matching cards.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-34 Record Mood & Notes Journal 
Test case ID:	TC-34
Test Case Name:	Record Mood & Notes Journal
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can log their daily mood (Happy, Sad, Neutral) with optional text notes, and update entries later.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens wellness journal view.		
2- 	User selects mood emoji (e.g. Happy), types notes (e.g. "Felt good after taking medication on time"), and clicks save.		
		3- 	System validates and saves entry in local storage. Refreshes daily log cards. User can edit notes later to add changes.
Testing Requirement:
Testing Condition:	A mood option must be selected. Only one journal entry is permitted per calendar day.
Input Data:	Mood Option, Journal Text Notes
Expected Result:	Journal entry stored successfully. Displays mood icon on calendar log widget.
Actual Result:	Journal saved. Selected emoji and notes render correctly on history list.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed

TC-35 Attempt User Challenges 
Test case ID:	TC-35
Test Case Name:	Attempt User Challenges
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system generates daily health challenges using Gemini API, or loads offline static fallbacks. Challenges are optional.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens wellness challenges screen.		
		2- 	System checks internet connection. Queries Gemini API passing user mood context. Fetches personalized challenge string.
		3- 	If offline or API fails, system queries locally stored static list of challenges (e.g. "Drink 8 glasses of water"). Displays challenge card. User can select to do or ignore it.
Testing Requirement:
Testing Condition:	Device must handle offline transition seamlessly. Gemini API key loaded from.env.
Input Data:	None
Expected Result:	Personalized challenge rendered on dashboard. App continues to function offline with standard challenges.
Actual Result:	Challenges generated correctly by Gemini when online. Loaded static checklist offline.
Priority:	Low.
Frequency:	Average
Test Acceptance:	Passed

TC-36 Display Visual Streak Tracker 
Test case ID:	TC-36
Test Case Name:	Display Visual Streak Tracker
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that streak tracker counts consecutive 100% adherence days, displays streak value, and resets on missed logs.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User completes all scheduled medicine logs for the day (100% medication adherence).		
		2- 	System increments consecutive streak counter by 1. Displays prominent flame icon on Wellness UI.
3- 	User misses or ignores a scheduled dose, leaving it unlogged for a full calendar day.		
		4- 	System resets streak counter back to 0. Updates view visual metrics instantly.
Testing Requirement:
Testing Condition:	Adherence values calculated at midnight or slot change.
Input Data:	Medicine logs status
Expected Result:	Streak counter increments on consecutive success and resets to zero on missed logs. Renders correctly in UI.
Actual Result:	Flame counter changes and updates correctly based on daily compliance logs.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed

TC-37 Add/Upload Report 
Test case ID:	TC-37
Test Case Name:	Add/Upload Report
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can upload medical reports (PDF/Images) specifying title and date parameters.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens Reports section, clicks Upload/Add Report icon.		
2- 	User enters report title (e.g. "Cholesterol Test"), selects report date, and chooses file (PDF or image) from device folders. Saves item.		
		3- 	System checks format. Saves the PDF/image locally inside application storage paths. Stores metadata in Hive database. Shows success confirmation.
Testing Requirement:
Testing Condition:	File must be supported format. Path must exist.
Input Data:	Report Title, Date, Selected Document File
Expected Result:	Report saved, reference saved in DB, and list view updated with new report entry card.
Actual Result:	File successfully cached, metadata recorded in Hive, list refreshed.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-38 Search Report 
Test case ID:	TC-38
Test Case Name:	Search Report
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can query report list by typing title words, date values, or category tags.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User accesses Reports tab, selects Search field.		
2- 	User enters characters (e.g. "Blood") or selects date parameters.		
		3- 	System searches and filters report records in database, updating screen to display matching reports list.
Testing Requirement:
Testing Condition:	Reports must exist.
Input Data:	Query Text String
Expected Result:	Search filters list instantly, displaying correct matching items. Shows empty list info if no matches are found.
Actual Result:	Search worked dynamically, filtering entries accurately.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-39 View Report
Test case ID:	TC-39
Test Case Name:	View Report
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can select and view medical reports using built-in PDF/Image viewer inside the application.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User selects report item from list and taps it.		
		2- 	System retrieves file path reference. Opens built-in file viewer.
		3- 	System renders report document (using SfPdfViewer for PDF or Image widget for photo formats) on fullscreen layout. Option to close/back exits viewer.
Testing Requirement:
Testing Condition:	Document file must exist in cache path and be readable.
Input Data:	None
Expected Result:	Report renders inside built-in screen layout without crashes or distortions.
Actual Result:	Built-in viewer rendered images and PDFs successfully.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-40 Access Chat Interface 
Test case ID:	TC-40
Test Case Name:	Access Chat Interface
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can open chatbot UI, send messages, and receive helpful, formatted wellness responses from Gemini API.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User selects ChatBot tab.		
		2- 	System displays chat view with previous messages list.
3- 	User enters wellness question (e.g. "What are the common side effects of Metformin?") and clicks Send.		
		4- 	System displays user bubble. Sends text query to Gemini API. Retrieves response. Displays assistant response bubble in real-time.
Testing Requirement:
Testing Condition:	Active internet connection. Gemini API key must be valid.
Input Data:	User message text
Expected Result:	Messages log chronologically, and Gemini response is fetched and displayed. Offline state prompts connection warning.
Actual Result:	Chat loaded. API response returned and formatted within 2 seconds.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-41 Apply Safety Filters & Rules 
Test case ID:	TC-41
Test Case Name:	Apply Safety Filters & Rules
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system applies safety filter rules to block inappropriate, abusive, or dangerous prompts.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User enters unsafe/harmful text question in chat input box (e.g. self-harm queries or abusive language) and clicks send.		
		2- 	System sanitizes string, matches safety filters on client/backend layer. Blocks request from being sent to generative model.
		3-	System displays a default safety warning message in the chat feed (e.g. "I cannot answer this question as it violates safety guidelines."). Safety rules update dynamically from backend.
Testing Requirement:
Testing Condition:	Safety filters active inside chatbot controller.
Input Data:	Harmful text string prompt
Expected Result:	Prompt blocked, model call bypassed, safety feedback displayed.
Actual Result:	Safety filters intercepted unsafe prompt successfully, displaying standard safety warning.
Priority:	High.
Frequency:	Average
Test Acceptance:	Passed


TC-42 View User Guide 
Test case ID:	TC-42
Test Case Name:	View User Guide
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can open user guide inside Help & Support, detailing how to add medicine and configure alerts.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens Help & Support, taps User Guide card.		
		2- 	System loads and displays user guide content layout. Detail blocks describe steps for scheduling, stock updates, and calendar actions.
Testing Requirement:
Testing Condition:	Guide content must be formatted and stored locally.
Input Data:	None
Expected Result:	User guide document loaded, scrolling functional.
Actual Result:	Guide displayed with clear markdown structure.
Priority:	Low.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-43 Submit Contact/Feedback Form 
Test case ID:	TC-43
Test Case Name:	Submit Contact/Feedback Form
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that submitting feedback launches the default email client with support email pre-populated.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User clicks "Send Feedback/Contact Us" in Help view.		
		2- 	System utilizes url launcher package to trigger native system intent protocols. Launches default mail client app.
		3- 	Pre-populates the recipient field with the developer support address (e.g. support@medcare.com) and pre-fills email subject.
Testing Requirement:
Testing Condition:	Device must have email client configured. Launcher schemes must be declared.
Input Data:	None
Expected Result:	Email application opens successfully showing correct support mail parameters.
Actual Result:	Default Gmail client launched displaying correct pre-filled values.
Priority:	Low.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-44 View About Section 
Test case ID:	TC-44
Test Case Name:	View About Section
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can open About section showing application version, credits, and contact info.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User goes to Profile, selects Settings, taps About section.		
		2- 	System pulls app configuration values and renders screen displaying MedCare Version (e.g. 1.0.0+1), developers information, and copyrights.
Testing Requirement:
Testing Condition:	Data values must match the compiled application manifest.
Input Data:	None
Expected Result:	About screen displayed showing correct version and developer credits.
Actual Result:	About screen loaded. Version 1.0.0+1 matches build values.
Priority:	Low.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-45 Change App Theme 
Test case ID:	TC-45
Test Case Name:	Change App Theme
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can toggle between Light and Dark themes, immediately swapping style layouts and saving preference locally.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User goes to Settings, toggles "Dark Theme" switch.		
		2- 	System swaps theme parameters instantly. Saves theme preference index inside local Hive cache box.
		3- 	Reloads interface styles dynamically without rebuilding full routes. Preference is preserved when app restarts.
Testing Requirement:
Testing Condition:	Theme provider registered at root context level.
Input Data:	Theme Switch Toggle (Boolean)
Expected Result:	Color modes toggle, changes are saved locally, and colors are restored correctly upon restart.
Actual Result:	Theme swapped cleanly from light to dark. Preference retained upon app reload.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-46 Configure Notification Settings 
Test case ID:	TC-46
Test Case Name:	Configure Notification Settings
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that user can select custom sound rings for medicine reminders, play previews, and configure notification intervals.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User goes to Settings, opens "Notification Settings" -> "Change Sound".		
2- 	User selects custom sound track from list. Taps sound item.		
		3- 	System plays preview audio file (using audioplayers library). Saves selected sound path inside Hive settings card.
4-	User saves settings.		
		5- 	System schedules future notifications mapped to custom sound channel configurations. Displays success confirmation.
Testing Requirement:
Testing Condition:	Sound tracks files must be present inside app assets. Audioplayers initialized.
Input Data:	Selected Sound Track Asset Name
Expected Result:	Preview plays, path is saved, and new notifications trigger with the chosen sound.
Actual Result:	Sound previews played cleanly. Custom alarms initialized with selected sound track.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-47 Detect & Adjust Time Zone Automatically 
Test case ID:	TC-47
Test Case Name:	Detect & Adjust Time Zone Automatically
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system automatically detects changes in the device's time zone and recalculates reminder alarm schedules accordingly.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User changes device's local system time zone (e.g. from GMT+5 to GMT+1) while traveling. Opens app.		
		2- 	System utilizes flutter_timezone library to detect new time zone automatically.
		3- 	System checks active alarm parameters in Hive, recalculates the trigger times based on the new local time zone parameters.
		4- 	System reschedules local alarms immediately. Displays info card: "Time zone changed, alerts updated."
Testing Requirement:
Testing Condition:	Device location/settings must allow timezone queries. timezone package initialized.
Input Data:	Device System Time Zone Change
Expected Result:	Time zone detected automatically, alarms reprogrammed, and medicine reminder alerts triggered at the correct local hour.
Actual Result:	Time zone change detected, alarms successfully updated to local time.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed

TC-48 View Medicine Consumption Reports 
Test case ID:	TC-48
Test Case Name:	View Medicine Consumption Reports
Test Case created by:	Atif Islam	
	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system displays dose consumption counts for each medicine, allowing daily/weekly/monthly filter selections. Highlights irregular intakes.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User opens Analytics tab.		
		2- 	System queries Hive daily compliance database. Displays medicine intake counts charts.
3- 	User selects filter duration tab (Weekly / Monthly).		
		4- 	System re-queries lists, updates charts view. Highlights medicines with irregular/poor intake (< 70% adherence) in warning color.
Testing Requirement:
Testing Condition:	Intake history logs must exist. UI utilizes fl_chart package.
Input Data:	Filter selection input (Weekly / Monthly)
Expected Result:	Analytics chart displays correct numbers. Irregular compliance medicines highlighted.
Actual Result:	Charts rendered. Week filter correctly displays compliance percentages.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed

TC-49 View Missed Doses Reports 
Test case ID:	TC-49
Test Case Name:	View Missed Doses Reports
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system lists details of missed doses (times and dates) and tracks total count per period.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User clicks on Analytics, and selects "Missed Doses Log".		
		2- 	System queries compliance database, filters records where state was logged as "Missed" or left unlogged.
		3-	Lists missed medicines showing exact scheduled hours. Displays total count value at the top header card.
Testing Requirement:
Testing Condition:	Database must contain historical compliance data.
Input Data:	None
Expected Result:	Lists missed slots. Total counter displays correct value representing the select period.
Actual Result:	Missed doses log rendered. Total count matches computed database values.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

TC-50 Display Monthly Summary 
Test case ID:	TC-50
Test Case Name:	Display Monthly Summary
Test Case created by:	Atif Islam	Use Test created on:	03/06/2026
Test Case Updated by:	M. Awais Ali	Use Test Updated On:	03/06/2026
Test Case Description:	Verify that system compiles intake and missed data logs to render interactive monthly compliance charts.
Primary Actor:	<Patient>
Main success scenario:
User Action		System Response
1- 	User scrolls to "Monthly Report Overview" card inside Analytics.		
		2- 	System aggregates data logs for past 30 days. Compares "Taken" vs "Missed" totals.
		3- 	Draws line graphs or bar charts representing daily intake progress and monthly compliance curves.
Testing Requirement:
Testing Condition:	fl_chart widgets loaded inside context. Data range spans 30 calendar days.
Input Data:	None
Expected Result:	Monthly chart renders accurately showing medication adherence progress curves.
Actual Result:	Compliance charts loaded without issues. Adherence curves reflect logs.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed




















CHAPTER # 6:
 USER MANUAL














Screen Shot
FOR
Personal Medicine Reminder
VERSION 1.0

Prepared by
Atif Islam
Muhammad Awais Ali

4th June,2026



























REVISION HISTORY
Version	Description	Author	Date
1.0	This covers the major screens	Atif Islam 
&
Muhammad Awais Ali	4th  June,2026















6.1 Screen Shots
6.1.1 Splash Screen









6.1.2 SignIn Screen

 






6.1.3 Login Screen

 






6.1.4 Forgot Password Screen

 






6.1.5 Change password Screen

 





6.1.6 Home Dashboard Screen

 






6.1.7 Hub Screen

 






6.1.8 My Medicines (List & Stock) Screen

 






6.1.9 Add Medicine Screen

 






6.1.10 Update Medicine Screen

 






6.1.11 Medication History (Active) Screen:

 






6.1.12 Medication History (History) Screen

 






6.1.13 Appointments List Screen

 






6.1.14 New Appointment Screen

 






6.1.15 Edit Appointment Screen

 






6.1.16 Medical Archive Screen

 






6.1.17 Health Records (Vitals, Illnesses, Allergies) Screen

 






6.1.18 AI Health Assistant Screen

 






6.1.19 Health Analytics Screen

 






6.1.20 Wellness & Mood (Journal) Screen

 






6.1.21 Wellness & Mood (Motivation) Screen

 






6.1.22 Profile Screen

 






6.1.23 Edit Profile Screen

 






6.1.24 Settings Screen

 





6.1.25 Notification Sounds Screen

 






6.1.26 Help & Support Screen

 





6.2 User Manual
6.2.1 User Manual:
 Personal Medicine Reminder (MedCare)
Audience: General Users, Patients & Caregivers 
Platform: Android (Flutter Mobile App) 
Purpose: This manual provides a highly detailed, step-by-step guide for every screen within the Personal Medicine Reminder (MedCare) app, designed to help users efficiently manage their medications, appointments, and overall health records.
👥 User Roles in this App
Role	Description
User (Patient)	Individuals who need to track their medication schedules, manage inventory, view health records, set appointments, and monitor daily wellness.
________________________________________
Splash & Onboarding Screen
 Purpose: The initial screens that welcome the user and introduce the app's core features. 
What Happens: 
•	The MedCare logo and branding appear. 
•	The app automatically checks if you are already logged in.
•	If logged in: You are instantly redirected to your Home Dashboard. 
•	If not logged in: You are routed to the Onboarding tutorial slides, and then the Sign-In screen.
6.2.2 Sign In Screen 
Purpose: For registered users to securely access their accounts.
 Screen Elements:
Element	Description
Email & Password	Input fields for your registered credentials.
Forgot Password	A helpful link if you cannot remember your login details.
Sign In Button	Authenticates and logs you securely into the app.
Google Sign-In	Quick, one-tap login using an existing Google account.
Steps to Use: 
•	Open the app to view the Sign-In screen.
•	Enter your registered Email and Password, or tap the Google icon for social login. 
•	Tap Sign In. If successful, you will be taken to your Dashboard.
6.2.3 Sign Up Screen 
Purpose: Where new users create their MedCare account to sync data securely across devices.
Screen Elements:
Element	Description
Full Name	Input field for your complete name.
Email	Input field for a valid email address.
Password Fields	Create and confirm a strong, secure password (minimum 8 characters, requiring letters and numbers).
CREATE ACCOUNT	Submits your details to create the account.
Google Sign-In	Quick, one-tap registration using an existing Google account.
Steps to Use: 
•	Tap "Sign Up" from the login screen. 
•	Fill in your Full Name, Email, and create a strong Password. 
•	Tap CREATE ACCOUNT. After successful registration, a verification link is sent, and you are routed to the login screen.
6.2.4 Forgot Password Screen
 Purpose: Securely reset a forgotten password. 
Screen Elements:
Element	Description
Email Field	Enter your registered email address.
SEND RESET LINK	Triggers the password recovery email.
Steps to Use:
•	Tap "Forgot Password?" on the Sign-In screen. 
•	Type your registered email address. 
•	Tap SEND RESET LINK.
•	Check your email inbox and follow the secure link to create a new password.
6.2.5 Today Dashboard Screen
 Purpose: The main hub providing a quick, centralized overview of today's schedule and upcoming doses. 
Screen Elements:
Element	Description
Welcome & Calendar	A greeting with a horizontally scrollable weekly calendar to quickly select days.
Daily Schedule	A chronological timeline of medications categorized by time of day (e.g., Afternoon).
Bottom Navigation	Quick access icons to Today, Hub, Medicines, and Profile.
Steps to Use: 
•	Open the app to view your "Today" screen.
•	Review your Daily Schedule to see upcoming doses for the current time block. 
•	Tap on the radio button next to a medication item to mark it as "Taken".
6.2.6  Add / Edit Medicine Screen
Purpose: Enter new medications into your tracking system or update existing details. 
Screen Elements:
Element	Description
Medicine Details	Fields for Name, Category (Tablet, Capsule, Syrup, Injection, Drops, Inhaler, Other), and Dosage.
Reminder Schedule	Set specific days, interval-based frequency, or complex cyclic schedules (X days on, Y days off).
Notification Setup	Define multiple alerts per dose (e.g., 5 mins before, exact time).
Initial Stock	Enter how many pills/doses you currently have.
Steps to Use: 
•	Tap the prominent "+" button from the Dashboard. 
•	Fill in the Medicine Name and select an appropriate Category.
•	Set up the specific times and days you need reminders.
•	Enter your current stock to enable automated low-stock alerts. 
•	Tap Save to securely store the medicine locally.
6.2.7  Calendar Schedule Screen
Purpose: A visual monthly or weekly view to foresee upcoming medications and appointments, up to 15 days in the past or future.
 Screen Elements:
Element	Description
Calendar View	Highlights dates that have scheduled tasks.
Date Details List	Tapping a highlighted date reveals the specific schedule for that exact day.
Steps to Use: 
•	Navigate to the Calendar tab using the bottom menu.
•	Swipe through the months. 
•	Tap any highlighted date to view exactly what medications or appointments are scheduled.
6.2.8 My Medicines (Inventory) Screen
Purpose: Monitor your medication stock levels to ensure you never run out unexpectedly.
Screen Elements:
Element	Description
Stock Level Indicator	A visual progress bar on each medicine card showing your remaining supply.
Running Low Warning	Automatically highlights medicines that need urgent refilling in red text.
All Medicines List	Displays all registered medications with their specific type and current quantity.
Steps to Use: 
•	Tap "Medicines" on the bottom navigation bar.
•	Immediately check for any cards showing the "Running low" warning.
•	Update the stock manually when you purchase a new refill pack.
6.2.9 Hub Screen
Purpose: The central navigation center for accessing all supplementary health features. 
Screen Elements:
Element	Description
AI Health Assistant	A top banner to directly ask anything about your health.
Quick Access Grid	Colorful cards to navigate to Appointments, Analytics, My Vitals, Medical Docs, Wellness, and AI Assistant.
Steps to Use: 
•	Tap "Hub" on the bottom navigation bar.
•	Tap any grid card to jump directly to that specific health module.
6.2.10 Health Records Screen 
Purpose: A comprehensive medical profile storing vitals, allergies, physical restraints, and chronic illnesses. 
Screen Elements:
Element	Description
Vitals Overview	Displays current BMI, Blood Type, Height, and Weight.
Chronic Illnesses	Add or view long-term medical conditions.
Allergies	Add, view, or remove known allergies.
Restraints & Restrictions	Section to log dietary or physical restrictions.
Steps to Use: 
•	Access "My Vitals" from the Hub.
•	Tap the "+" icon on any relevant category (e.g., Allergies) to input new personal data.
6.2.11 Appointment Management Screen
Purpose: Schedule, categorize, and track your doctor or clinic visits with built-in reminders. 
Screen Elements:
Element	Description
Status Tabs	Sort your appointments by "Upcoming" or "Completed".
Appointment Form	Fields for Date, Time, Doctor/Clinic Name, Category, and Reminder settings.
Visit Notes	A text area to write down doctor's instructions or post-visit feedback.
Steps to Use: 
•	Tap Add Appointment.
•	Enter the doctor's name, choose a category, and select the date and time.
•	Configure a reminder so you don't miss the visit.
•	After the consultation, update the Appointment with your Visit Notes and manually mark it as Completed.
6.2.12 Wellness & Mood Screen
Purpose: Track your mental well-being, physical streaks, and daily challenges. 
Screen Elements:
Element	Description
Journal Tab	Contains mood selectors (Happy, Neutral, Sad, Stressed) to log how you feel daily with optional notes.
Motivation Tab	Displays your Current Streak (consecutive days of adherence) and the Daily Challenge.
New Challenge Button	Generates a fresh AI health challenge if you want a different task.
Steps to Use: 
•	Open the Wellness section from the Hub.
•	Go to the Motivation tab to view your adherence streak and read today's challenge. 
•	Switch to the Journal tab to select the mood that best represents your day and save it.
6.2.13 Medical Archive Screen 
Purpose: A secure digital folder to store and easily search your medical lab reports or prescriptions.
Screen Elements:
Element	Description
Your Records	Categorized lists separating Prescriptions and Lab Results.
Search & Filters	Locate specific records instantly by name, type, or date.
Document Cards	Quick summary of the document with a tap-to-open icon.
Steps to Use: 
•	Navigate to the Medical Docs / Archive section from the Hub.
•	Tap the upload icon to add a new photo or file of your medical document. 
•	Use the Search Bar or Filters to pull up older lab results when consulting with a doctor.
6.2.14 AI ChatBot Assistant Screen 
Purpose: An intelligent assistant (powered by Gemini) to help answer general health queries or explain app features. 
Screen Elements:
Element	Description
Chat Interface	A standard messaging view distinguishing user queries from chatbot replies.
Input Field	Text box to type your questions.
Steps to Use: 
•	Access the ChatBot from the app's interface. 
•	Type your question (e.g., "What does this symptom mean?" or "How do I add a medicine?") and send.
•	The assistant applies safety filters and provides an informative, real-time response.
6.2.15 Profile Management Screen 
Purpose: View and update your personal details and track physical health metrics. 
Screen Elements:
Element	Description
Profile Avatar	Tap to securely upload or replace your picture. Displays your Name and Email.
BMI Score Card	An auto-calculated BMI rating based on your recorded physical metrics.
Health Metrics	Specific fields displaying your Height (cm), Weight (kg), and Blood Group.
Personal Info	Editable sections for Full Name, Date of Birth, and Gender.
Steps to Use:
•	Go to the Profile tab.
•	Tap the Settings gear icon or Edit Profile to update your weight, height, or personal info. The app instantly recalculates your BMI score based on the new data.
•	Tap the Save button to safely sync your changes.
6.2.16  Analytics & Visualization Screen
Purpose: Detailed visual charts to help you comprehend your medication adherence and identify missing patterns. 
Screen Elements:
Element	Description
Consumption Charts	Graphical summaries displaying doses taken versus missed over daily, weekly, or monthly periods.
Missed Doses Report	A detailed list identifying exactly which medicines were missed and on what dates.
Steps to Use: 
•	Navigate to the Analytics/Reports section. • Select your desired time period.
•	Review the charts to see if there are specific times of day or specific medicines you frequently forget, allowing you to adjust your habits.
6.2.17 Settings & Preferences Screen 
Purpose: Customize the app's appearance and fine-tune your notification behaviors. 
Screen Elements:
Element	Description
Theme Toggle	Switch the entire app interface between Light and Dark mode.
Notification Sounds	Assign distinct, custom audio alerts for short/long notifications.
Time Zone Sync	Automatically detects and adjusts your reminders based on your current geographical location.
Steps to Use: 
•	Open Settings from the Profile menu. 
•	Toggle Dark Mode depending on your visual preference.
•	Select specific notification sounds so you instantly recognize when MedCare requires your attention.
6.2.18 Help & Support Screen
Purpose: Get assistance, provide feedback, or learn more about the application. 
Screen Elements:
Element	Description
User Guide	Access this manual directly within the app for quick reference.
Contact / Feedback	A button that launches your default email client to send a direct message to support.
About Section	Displays the app version, developers' information, and contact info.
Steps to Use:
•	Navigate to Help & Support. 
•	Tap User Guide if you need help navigating a feature.
•	Tap Feedback to report a bug or request a feature directly to the development team.


