Functional Requirements 
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
