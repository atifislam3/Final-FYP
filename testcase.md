Personal Medicine Reminder (MedCare) - Test Cases Document
This document contains a comprehensive set of test cases for the Personal Medicine Reminder (MedCare) application modules and submodules. All test cases are formatted as grid tables matching the visual structure of your Home Services Application test cases.

2.2.1 Authentication & Security
TC-AUTH-01: Process SignUp / Registration
Test case ID:	TC-AUTH-01
Test Case Name:	Process SignUp / Registration
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that a new user can register a secure, unique account by providing name, email, password, and confirm password.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks register or sign up button.	
2- User enters name, email, password, and confirm password.	
	3- System validates all mandatory fields. Checks password strength (min 8 chars, 1 uppercase, 1 number) and uniqueness of email.
4- User submits registration.	
	5- System creates the account in Firebase Auth, sends verification email, and redirects to Login screen.
Testing Requirement:
Testing Condition:	System must be in running state and connected to internet. Email must not be already registered.
Input Data:	Full Name, Email Address, Password, Confirm Password
Expected Result:	Account created in Firebase, email verification sent, and user redirected to Login screen.
Actual Result:	Account successfully created and verification email received.
Priority:	High.
Frequency:	Less frequent
Test Acceptance:	Passed
TC-AUTH-02: Process Login / SignIn
Test case ID:	TC-AUTH-02
Test Case Name:	Process Login / SignIn
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that a registered user can log in by providing valid email and password. Blocks login if email is not verified.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User inputs registered email and password. Taps "Login".	
	2- System validates credentials against Firebase Auth. Checks email verification status.
	3- If email is verified, user session is started and redirected to Home/Dashboard. If not verified, login is blocked and resend link is offered.
Testing Requirement:
Testing Condition:	User must have a registered account. System must have internet connection.
Input Data:	Email, Password
Expected Result:	Successful login redirects user to home screen dashboard. Invalid inputs show precise validation/credential error toast.
Actual Result:	User authenticated successfully and navigated to home dashboard.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed
TC-AUTH-03: Process Logout
Test case ID:	TC-AUTH-03
Test Case Name:	Process Logout
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that an authenticated user can securely terminate their session via the profile settings.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User navigates to profile, scrolls to bottom, and taps "Logout".	
	2- System signs out from Firebase, clears local authentication tokens/caches.
	3- System redirects user back to the Login screen, disabling back navigation to authenticated pages.
Testing Requirement:
Testing Condition:	User must be logged in.
Input Data:	None
Expected Result:	User session ended, tokens cleared, navigated to login.
Actual Result:	User session cleared and redirected to login screen immediately.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed
TC-AUTH-04: Forget Password
Test case ID:	TC-AUTH-04
Test Case Name:	Forget Password
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that a user can request a password reset email link for their registered account.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks "Forgot Password" link on the login screen.	
2- User enters registered email address and taps "Send Link".	
	3- System checks if email exists in Firebase database. Sends reset email. Shows confirmation message.
Testing Requirement:
Testing Condition:	Active internet connection. Email must be correct format.
Input Data:	Registered Email
Expected Result:	Reset link sent, user receives email, and user can complete reset via link.
Actual Result:	Password reset email sent and received. User redirected to login.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-AUTH-05: Change Password
Test case ID:	TC-AUTH-05
Test Case Name:	Change Password
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that a logged-in user can change their password through profile settings. Restricts Google-authenticated users.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User goes to profile settings, clicks Change Password.	
2- User inputs current password, new password, and confirms it. Saves change.	
	3- System checks if current password is correct. Validates new password criteria (8 chars, 1 uppercase, 1 number). Updates database and displays success message.
Testing Requirement:
Testing Condition:	User must be logged in. Not applicable for Google sign-in accounts (option must be disabled/hidden).
Input Data:	Current Password, New Password, Confirm Password
Expected Result:	Password updated and success message displayed. Incorrect old password or mismatch triggers error message.
Actual Result:	Password updated successfully. Option disabled on profile for Google accounts.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-AUTH-06: Process SocialLogin
Test case ID:	TC-AUTH-06
Test Case Name:	Process SocialLogin (Google)
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that a user can sign in using their Google account. Auto-registers new users and logs in existing users.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks "Sign in with Google" button.	
2- User selects their Google account and authorizes access.	
	3- System retrieves Google profile information (Name, Email). Checks database for matches.
	4- Logs user in directly if registered, otherwise registers details and redirects to Home dashboard. Flags user as SocialLogin (disabling local password edits).
Testing Requirement:
Testing Condition:	Device must have internet connection and Google services enabled.
Input Data:	Google Authentication credentials
Expected Result:	Successful login or automatic registration, and redirection to Home dashboard.
Actual Result:	User logged in/registered with Google, redirected to Home.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed
________________________________________
2.2.2 Profile Management
TC-PROF-01: View Profile
Test case ID:	TC-PROF-01
Test Case Name:	View Profile
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that the profile tab displays full name, email, blood group, height, weight, BMI, gender, DOB, and profile photo.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks on Profile tab from the bottom navigation menu.	
	2- System retrieves user information and basic health info from Firebase and local database cache.
	3- System calculates BMI automatically based on height and weight.
	4- System renders profile screen with name, email, health metrics, and profile avatar. Shows placeholders for empty items.
Testing Requirement:
Testing Condition:	User must be logged in.
Input Data:	None
Expected Result:	User health stats, calculated BMI, and photo are fetched and displayed accurately.
Actual Result:	Profile loaded. Weight/height rendered, and BMI matches calculations.
Priority:	High.
Frequency:	High frequent
Test Acceptance:	Passed
TC-PROF-02: Update Profile
Test case ID:	TC-PROF-02
Test Case Name:	Update Profile
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that a user can update their personal information and successfully save the changes to Firebase.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks Edit Profile on Profile screen.	
2- User updates name, gender, blood group, height, weight, and DOB, then clicks Save.	
	3- System recalculates BMI. Validates input values. Saves changes to Firebase Realtime DB and local cache.
	4- System displays success confirmation toast, and redirects user back to the View Profile screen.
Testing Requirement:
Testing Condition:	User must be logged in. Fields must not contain empty or invalid values.
Input Data:	Updated Name, DOB, Gender, Weight, Height, Blood Group
Expected Result:	Profile data successfully updated in database and changes immediately visible on profile view.
Actual Result:	Profile updated successfully and reflected in View Profile view.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-PROF-03: Manage Basic Health Information
Test case ID:	TC-PROF-03
Test Case Name:	Manage Basic Health Information
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that the system calculates BMI correctly when height (cm) and weight (kg) are entered, and saves values to database.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User enters weight in kilograms (e.g. 70) and height in centimeters (e.g. 175) on Edit Profile screen.	
	2- System automatically calculates BMI in real-time ($BMI = weight / (height/100)^2 = 22.86$) and displays it.
3- User selects blood group from predefined list and clicks Save.	
	4- System validates entries. Saves health information securely in Firebase. Displays confirmation message.
Testing Requirement:
Testing Condition:	Inputs must be positive numbers. Selectable blood group from dropdown list.
Input Data:	Height (cm), Weight (kg), Blood Group (Dropdown)
Expected Result:	BMI calculated and health parameters saved successfully. Zero/negative inputs trigger validation errors.
Actual Result:	Metrics saved. Invalid values caught by client validation filters.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-PROF-04: Upload Profile Photo
Test case ID:	TC-PROF-04
Test Case Name:	Upload Profile Photo
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can pick an image from their device gallery, crop/resize it, upload it, and update profile visual.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks on profile image in Edit Profile and selects "Choose from Gallery".	
2- User selects a valid image file (JPG/PNG).	
	3- System checks image file type, resizes/compresses the image to optimize storage, and saves photo reference URL locally/Firebase.
	4- System updates the profile views to show the newly selected picture immediately. Option to remove photo exists.
Testing Requirement:
Testing Condition:	Supported format (JPG, PNG). File must be readable.
Input Data:	Selected Image File
Expected Result:	Image uploaded, and profile picture updated on the view. Unsupported file formats show validation warning.
Actual Result:	Image compressed, stored, and displayed immediately on profile.
Priority:	Low.
Frequency:	Less frequent
Test Acceptance:	Passed
________________________________________
2.2.3 Medicine Management
TC-MED-01: Add Medicine
Test case ID:	TC-MED-01
Test Case Name:	Add Medicine
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that a user can add a new medicine by specifying name, dosage, category, complex schedules, and initial stock.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User navigates to Add Medicine screen.	
2- User inputs Medicine Name, Dosage (e.g. 500mg), Category, complex schedule options (e.g. Specific Days or Intervals), multiple reminders, and stock. Saves medicine.	
	3- System validates required inputs. Saves medicine object locally in Hive database.
	4- System triggers local notification manager to register reminder alarms. Displays confirmation dialog/toast.
Testing Requirement:
Testing Condition:	Database must have write access. Mandatory fields (Name, dosage, schedule) must not be empty.
Input Data:	Medicine Name, Dosage, Category, Schedule settings, Reminder Times, Initial Stock count
Expected Result:	Medicine added successfully, notifications scheduled, and confirmation shown. Empty fields trigger input warnings.
Actual Result:	Medicine recorded in Hive database, schedule set, and success dialog triggered.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed
TC-MED-02: Update Medicine Details
Test case ID:	TC-MED-02
Test Case Name:	Update Medicine Details
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that a user can update dosage, name, category, or reminder intervals of an existing medicine.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User selects medicine from list and clicks edit/update details.	
2- User updates name, category, dosage or updates reminder schedule, then clicks save.	
	3- System checks input validation. Rewrites record in local Hive storage.
	4- System cancels old active notification alarms, registers new notifications, and displays success toast.
Testing Requirement:
Testing Condition:	Medicine record must exist. New values must be valid.
Input Data:	Modified fields (Name, Dosage, Schedule, etc.)
Expected Result:	Medicine data updated, previous alarms cancelled, new alerts programmed.
Actual Result:	Medicine updated and new alarms programmed in system notification service.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed
TC-MED-03: Set Medicine Reminder
Test case ID:	TC-MED-03
Test Case Name:	Set Medicine Reminder
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that notifications trigger per schedule (pre, exact, post-dose alerts) and accept user action choices.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- System reaches the scheduled dose reminder time.	
	2- System triggers local notification sound and pops up alert panel with "Take", "Snooze", and "Missed" options.
3- User taps "Take" on notification.	
	4- System registers dose as completed/taken locally. Cancels subsequent post-dose alerts for this specific schedule.
Testing Requirement:
Testing Condition:	Notification permission granted. Background execution enabled.
Input Data:	Dose Action Choice ("Take" / "Snooze" / "Missed")
Expected Result:	Alarms play sound, action buttons record choice, dose state updates inside DB. Tapping "Snooze" reschedules alarm for later.
Actual Result:	Notification triggered. Tapping "Take" marked the dose taken and updated streak logs.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed
TC-MED-04: Disable Medicine Alert
Test case ID:	TC-MED-04
Test Case Name:	Disable Medicine Alert
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can disable alerts for a medicine while retaining the medicine record inside inventory.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User selects medicine details, switches the "Alerts Active" toggle to OFF.	
	2- System cancels all pending scheduled notifications for this specific medicine from background alarm queue.
	3- System updates the flags locally in Hive. Displays confirmation toast. Keeps medicine active in lists.
Testing Requirement:
Testing Condition:	Medicine record must exist with active reminders.
Input Data:	Toggle Alerts Option (Boolean)
Expected Result:	Alarms deactivated. Medicine still viewable in inventory/lists. No alarms fired thereafter.
Actual Result:	Alarms successfully cancelled. Medicine remains listed.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-MED-05: Categorize Medicine
Test case ID:	TC-MED-05
Test Case Name:	Categorize Medicine
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can assign categories (Tablet, Syrup, Injection, Insulin) or input custom categories under "Other".
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Category field dropdown in Add/Edit Medicine view.	
2- User selects predefined category, or selects "Other" and inputs a custom category name (e.g. Inhaler).	
	3- System maps category text to field. Saves selection locally with medicine object. Renders custom icons/details.
Testing Requirement:
Testing Condition:	Selection field active. Custom text fields must not contain symbols.
Input Data:	Dropdown Selection / Custom Category text input
Expected Result:	Category assigned to medicine record, displayed in lists, and saved locally.
Actual Result:	Category assigned correctly and custom categories displayed.
Priority:	Low.
Frequency:	Less frequent
Test Acceptance:	Passed
________________________________________
2.2.4 Schedule Management
TC-SCHED-01: View Calendar
Test case ID:	TC-SCHED-01
Test Case Name:	View Calendar
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can open schedule view and check monthly/weekly calendar containing colored indicator markers for active tasks.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks on Schedule/Calendar tab from navigation.	
	2- System queries Hive database for active medicine alerts and doctor appointments.
	3- System highlights dates on calendar containing events (e.g. medicine doses or clinic schedules) using color dots/icons.
Testing Requirement:
Testing Condition:	User must be logged in. Local database contains records.
Input Data:	None
Expected Result:	Calendar loaded with event indicator highlights corresponding to scheduled items.
Actual Result:	Calendar rendered with indicator dots showing schedules.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed
TC-SCHED-02: View Daily Schedule
Test case ID:	TC-SCHED-02
Test Case Name:	View Daily Schedule
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that daily schedule lists all medicine doses and appointments scheduled for the current system date.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User views Home or Schedule main view.	
	2- System fetches current system date from device settings.
	3- Queries local database. Generates sorted list of all active medicine reminder slots and appointments for the current day. Displays chronological list.
Testing Requirement:
Testing Condition:	System date must be configured.
Input Data:	None
Expected Result:	All active schedules for today are displayed. If no events exist, a clean empty-state greeting card is displayed.
Actual Result:	Cron-list for today rendered cleanly showing medicine categories and times.
Priority:	High.
Frequency:	Most frequent
Test Acceptance:	Passed
TC-SCHED-03: View Date Schedule
Test case ID:	TC-SCHED-03
Test Case Name:	View Date Schedule
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can click a date on the calendar, filtering and displaying events scheduled for that specific day.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User taps on a specific date tile in Calendar view.	
	2- System captures selected date. Queries database records for matching date parameters.
	3- Updates screen with detailed list of medicines, scheduled doses, and doctor visits for selected date.
Testing Requirement:
Testing Condition:	Selected date must fall within calendar bounds.
Input Data:	Selected Calendar Date
Expected Result:	List updates immediately on click with correct records. Empty date displays "No items scheduled for this date."
Actual Result:	Date selected, and items display correctly.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed
TC-SCHED-04: Apply Date Range Limitation
Test case ID:	TC-SCHED-04
Test Case Name:	Apply Date Range Limitation
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that calendar limits views to 15 days of past data and 15 days of future data relative to the current date.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Calendar view and attempts to scroll beyond 15 days in past or 15 days in future.	
	2- System detects current date. Limits the table calendar page navigation range to CurrentDate - 15 to CurrentDate + 15.
	3- Prevents further swipe actions and greys out dates outside range boundaries.
Testing Requirement:
Testing Condition:	Table Calendar controller must apply range limits in state builder.
Input Data:	Scroll/Swipe gesture action
Expected Result:	User restricted from accessing days outside range. Only 31 days (past 15 + today + future 15) are selectable.
Actual Result:	Calendar range restricted to ±15 days, scrolling blocked past boundary.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
________________________________________
2.2.5 User Health Records
TC-REC-01: Add/Update Allergies List
Test case ID:	TC-REC-01
Test Case Name:	Add/Update Allergies List
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can record, view, and update list of active food/drug allergies in Health Records.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User goes to Health Records tab, selects Allergies.	
2- User types allergy details (e.g. Penicillin) and clicks Add.	
	3- System validates entry text format, adds allergy string, updates local storage, and renders it in the list.
Testing Requirement:
Testing Condition:	Input must contain text. Duplicate entries should be filtered.
Input Data:	Allergy String Value
Expected Result:	Allergy added to local database, view lists item immediately. User can remove item with delete icon.
Actual Result:	Allergy added to database and listed in the UI. Delete deletes item successfully.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-REC-02: View Current Medication
Test case ID:	TC-REC-02
Test Case Name:	View Current Medication
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system displays active medications, letting user mark active medicines as complete.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens current medication screen.	
	2- System queries Hive, lists active medicine names, dosages, and schedules.
3- User selects a medicine, toggles status or taps "Mark as Complete".	
	4- System flags record as complete, stops alarms, and moves item to history database segment.
Testing Requirement:
Testing Condition:	Medication items must be in database.
Input Data:	Status Toggle Action
Expected Result:	Medication status changed in DB, and list updates dynamically without page reloads.
Actual Result:	Medicine marked completed, removed from active screen, and moved to medication history.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-REC-03: View Past Medication
Test case ID:	TC-REC-03
Test Case Name:	View Past Medication
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that the system displays previous medications, updating lists automatically when active medicine is set as complete.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User views Medication History/Past Medication tab in Health Records.	
	2- System queries Hive, lists completed/ended medicines showing completion dates.
Testing Requirement:
Testing Condition:	Completed medicine logs must exist in local database.
Input Data:	None
Expected Result:	Past records displayed accurately. Newly completed medicines appear at the top of the history list.
Actual Result:	History list populated. Records reflect correct dates/times when marked completed.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-REC-04: Add Restraints
Test case ID:	TC-REC-04
Test Case Name:	Add Restraints
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can record medication restrictions or dietary restraints in health records database.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Restraints card in health records editor.	
2- User types dietary or drug restrictions (e.g. "No Grapefruit juice with medications") and saves.	
	3- System validates entry, writes record locally, and renders item on list.
Testing Requirement:
Testing Condition:	Inputs must be plain text.
Input Data:	Restraint detail text string
Expected Result:	Restraints text successfully stored and visible on dashboard/health records profile.
Actual Result:	Restraints info saved locally in Hive and displayed in Health Records.
Priority:	Low.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-REC-05: Add Chronic Illnesses
Test case ID:	TC-REC-05
Test Case Name:	Add Chronic Illnesses
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can add, view, and update list of active chronic illnesses (Diabetes, Hypertension).
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User selects Chronic Illnesses card in Health Records interface.	
2- User types chronic illness title (e.g. Hypertension) and clicks Add.	
	3- System verifies entry, writes records to database, and appends card item to the list.
Testing Requirement:
Testing Condition:	Text input must not be empty.
Input Data:	Illness title text value
Expected Result:	Chronic illness saved, item added to view, and deletable using close icon.
Actual Result:	Illness added and visible in list. Deletion works as expected.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
________________________________________
2.2.6 Inventory Control
TC-INV-01: View Current Stock
Test case ID:	TC-INV-01
Test Case Name:	View Current Stock
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system displays a list of medicines with current stock quantities, highlighting items with stock <= 5 at the top.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Inventory tab.	
	2- System queries Hive database for all recorded medicines and their stock amounts.
	3- System checks threshold limits. Lists medicines with stock <= 5 at the top of the view in a dedicated red-coded "Low Stock" list, followed by other medicines.
Testing Requirement:
Testing Condition:	Inventory items must be in database.
Input Data:	None
Expected Result:	Stock inventory display renders accurately with low stock items sorted and highlighted at the top.
Actual Result:	Stock counts rendered. Low stock items highlighted in red.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-INV-02: Update Current Stock
Test case ID:	TC-INV-02
Test Case Name:	Update Current Stock
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can increase or decrease the stock quantity for a selected medicine and save it.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User selects medicine from Inventory list and clicks stock counter buttons (+ / -) or edits stock field.	
2- User updates quantity (e.g. increments stock from 3 to 30) and clicks Save.	
	3- System checks input validation (must be non-negative integer), updates value in Hive DB, and displays confirmation toast. Updates views immediately.
Testing Requirement:
Testing Condition:	Target medicine must exist. Stock must be positive integer.
Input Data:	Adjusted quantity value
Expected Result:	Stock level updated in Hive and low stock status recalculated immediately.
Actual Result:	Stock updated. Medicine shifted from "Low Stock" to "Good Stock" list when replenished.
Priority:	High.
Frequency:	Average
Test Acceptance:	Passed
TC-INV-03: Generate Stock Alerts
Test case ID:	TC-INV-03
Test Case Name:	Generate Stock Alerts
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system automatically triggers a warning alert when stock quantity drops to or below 5 during dose logs.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User registers a dose intake ("Take"), reducing remaining stock count.	
	2- System calculates new stock level. If stock <= 5, system triggers low-stock push notification alert immediately.
	3- Places the medicine inside the dedicated "Low Stock" dashboard widgets for immediate reference.
Testing Requirement:
Testing Condition:	Inventory alerts toggle must be enabled.
Input Data:	Dose log confirmation input ("Take")
Expected Result:	Push notification alert fired when stock drops to 5 or lower. Widget updates instantly.
Actual Result:	Alert notification received in tray when stock reached 5.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
________________________________________
2.2.7 Appointment Management
TC-APP-01: Add Appointment
Test case ID:	TC-APP-01
Test Case Name:	Add Appointment
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can add new appointments detailing doctor name, clinic, category, date, time, and reminder options.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks "Add Appointment" button in Appointments view.	
2- User enters Doctor/Clinic name, selects category, configures Date/Time, and sets alert reminder (e.g. 30 mins before). Clicks Save.	
	3- System checks input validation. Saves record locally. Programs alarm manager for notification. Shows success message.
Testing Requirement:
Testing Condition:	Inputs must be valid. Date must not be in past for new appointments.
Input Data:	Doctor Name, Date, Time, Category, Reminder interval
Expected Result:	Appointment saved in database. Scheduled alarm is registered. Success confirmation displayed.
Actual Result:	Appointment successfully registered and visible in list.
Priority:	High.
Frequency:	Average
Test Acceptance:	Passed
TC-APP-02: Update Appointment
Test case ID:	TC-APP-02
Test Case Name:	Update Appointment
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can update date, time, notes, clinic, or reminder alarms of an existing appointment.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User selects appointment from list and clicks edit icon.	
2- User updates time, category, or adds notes, then clicks save.	
	3- System checks input validation. Updates local Hive database. Cancels old alerts and schedules new alarms. Shows success confirmation.
Testing Requirement:
Testing Condition:	Appointment record must exist.
Input Data:	Modified fields (Date, notes, etc.)
Expected Result:	Appointment modified correctly, old notifications replaced by new ones.
Actual Result:	Appointment details modified and alarms rescheduled successfully.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-APP-03: Manage Appointment Categories / Status
Test case ID:	TC-APP-03
Test Case Name:	Manage Appointment Categories / Status
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that appointments are categorized as "Upcoming" or "Completed" and users can manually mark them completed.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User views Appointments screen dashboard.	
	2- System compares appointment date/time with current date. Categorizes events automatically (Upcoming shown first).
3- User selects an upcoming appointment, clicks "Mark as Completed".	
	4- System updates status flag inside Hive DB. Moves record to Completed/History segment instantly.
Testing Requirement:
Testing Condition:	Appointments must exist in lists.
Input Data:	Status toggle confirmation click
Expected Result:	Status flag updated, list filters updated, and appointment moved to completed category.
Actual Result:	Appointment marked completed and shifted to History tab cleanly.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-APP-04: Set Appointment Reminder
Test case ID:	TC-APP-04
Test Case Name:	Set Appointment Reminder
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system fires push notification reminder at configured interval before the appointment. Supports recurring settings.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User defines notification alert time (e.g. 1 hour before) in Appointment settings.	
	2- System configures background notification alarm triggers.
3- System clock reaches the reminder threshold (e.g. 1 hour prior to appointment).	
	4- System triggers appointment notification alert showing doctor details, clinic location, and visit notes.
Testing Requirement:
Testing Condition:	System permissions for notifications allowed. Device background process active.
Input Data:	Reminder interval value
Expected Result:	Alert sounds and notifies user in system tray exactly at set time.
Actual Result:	Push notification received successfully in device status bar.
Priority:	High.
Frequency:	Average
Test Acceptance:	Passed
TC-APP-05: Add Visit Notes
Test case ID:	TC-APP-05
Test Case Name:	Add Visit Notes
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can write clinical notes, prescriptions, or preparation instructions inside appointment details.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Appointment editor view.	
2- User enters notes inside the Visit Notes editor box (e.g. "Fast 12 hours before blood sample collection") and clicks save.	
	3- System saves notes string mapped with appointment object in Hive. Displays updated notes field on appointment details card.
Testing Requirement:
Testing Condition:	Inputs must be text.
Input Data:	Notes String Value
Expected Result:	Visit notes saved and readable inside appointment details/history card views.
Actual Result:	Visit notes saved successfully and readable on the details card.
Priority:	Low.
Frequency:	Average
Test Acceptance:	Passed
TC-APP-06: View Appointment History
Test case ID:	TC-APP-06
Test Case Name:	View Appointment History
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system displays history of completed appointments, with search and filter capabilities.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Completed Appointments view.	
	2- System queries Hive, fetches completed appointment cards, and displays them.
3- User types a query in the search bar (e.g. Cardiologist) or filters by category.	
	4- System filters database records instantly, updating list view. Displays matching results.
Testing Requirement:
Testing Condition:	Completed appointments must exist in database.
Input Data:	Search string / Category filters
Expected Result:	History list populated. Search filters list accurately by doctor name or category.
Actual Result:	History view displayed. Search displays correct matching cards.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
________________________________________
2.2.8 Journaling & Motivation
TC-JRN-01: Record Mood & Notes Journal
Test case ID:	TC-JRN-01
Test Case Name:	Record Mood & Notes Journal
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can log their daily mood (Happy, Sad, Neutral) with optional text notes, and update entries later.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens wellness journal view.	
2- User selects mood emoji (e.g. Happy), types notes (e.g. "Felt good after taking medication on time"), and clicks save.	
	3- System validates and saves entry in local storage. Refreshes daily log cards. User can edit notes later to add changes.
Testing Requirement:
Testing Condition:	A mood option must be selected. Only one journal entry is permitted per calendar day.
Input Data:	Mood Option, Journal Text Notes
Expected Result:	Journal entry stored successfully. Displays mood icon on calendar log widget.
Actual Result:	Journal saved. Selected emoji and notes render correctly on history list.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed
TC-JRN-02: Attempt User Challenges
Test case ID:	TC-JRN-02
Test Case Name:	Attempt User Challenges
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system generates daily health challenges using Gemini API, or loads offline static fallbacks. Challenges are optional.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens wellness challenges screen.	
	2- System checks internet connection. Queries Gemini API passing user mood context. Fetches personalized challenge string.
	3- If offline or API fails, system queries locally stored static list of challenges (e.g. "Drink 8 glasses of water"). Displays challenge card. User can select to do or ignore it.
Testing Requirement:
Testing Condition:	Device must handle offline transition seamlessly. Gemini API key loaded from .env.
Input Data:	None
Expected Result:	Personalized challenge rendered on dashboard. App continues to function offline with standard challenges.
Actual Result:	Challenges generated correctly by Gemini when online. Loaded static checklist offline.
Priority:	Low.
Frequency:	Average
Test Acceptance:	Passed
TC-JRN-03: Display Visual Streak Tracker
Test case ID:	TC-JRN-03
Test Case Name:	Display Visual Streak Tracker
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that streak tracker counts consecutive 100% adherence days, displays streak value, and resets on missed logs.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User completes all scheduled medicine logs for the day (100% medication adherence).	
	2- System increments consecutive streak counter by 1. Displays prominent flame icon on Wellness UI.
3- User misses or ignores a scheduled dose, leaving it unlogged for a full calendar day.	
	4- System resets streak counter back to 0. Updates view visual metrics instantly.
Testing Requirement:
Testing Condition:	Adherence values calculated at midnight or slot change.
Input Data:	Medicine logs status
Expected Result:	Streak counter increments on consecutive success and resets to zero on missed logs. Renders correctly in UI.
Actual Result:	Flame counter changes and updates correctly based on daily compliance logs.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed
________________________________________
2.2.9 Report Management
TC-REP-01: Add/Upload Report
Test case ID:	TC-REP-01
Test Case Name:	Add/Upload Report
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can upload medical reports (PDF/Images) specifying title and date parameters.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Reports section, clicks Upload/Add Report icon.	
2- User enters report title (e.g. "Cholesterol Test"), selects report date, and chooses file (PDF or image) from device folders. Saves item.	
	3- System checks format. Saves the PDF/image locally inside application storage paths. Stores metadata in Hive database. Shows success confirmation.
Testing Requirement:
Testing Condition:	File must be supported format. Path must exist.
Input Data:	Report Title, Date, Selected Document File
Expected Result:	Report saved, reference saved in DB, and list view updated with new report entry card.
Actual Result:	File successfully cached, metadata recorded in Hive, list refreshed.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-REP-02: Search Report
Test case ID:	TC-REP-02
Test Case Name:	Search Report
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can query report list by typing title words, date values, or category tags.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User accesses Reports tab, selects Search field.	
2- User enters characters (e.g. "Blood") or selects date parameters.	
	3- System searches and filters report records in database, updating screen to display matching reports list.
Testing Requirement:
Testing Condition:	Reports must exist.
Input Data:	Query Text String
Expected Result:	Search filters list instantly, displaying correct matching items. Shows empty list info if no matches are found.
Actual Result:	Search worked dynamically, filtering entries accurately.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-REP-03: View Report
Test case ID:	TC-REP-03
Test Case Name:	View Report
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can select and view medical reports using built-in PDF/Image viewer inside the application.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User selects report item from list and taps it.	
	2- System retrieves file path reference. Opens built-in file viewer.
	3- System renders report document (using SfPdfViewer for PDF or Image widget for photo formats) on fullscreen layout. Option to close/back exits viewer.
Testing Requirement:
Testing Condition:	Document file must exist in cache path and be readable.
Input Data:	None
Expected Result:	Report renders inside built-in screen layout without crashes or distortions.
Actual Result:	Built-in viewer rendered images and PDFs successfully.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
________________________________________
2.2.10 ChatBot Assistant
TC-CHAT-01: Access Chat Interface
Test case ID:	TC-CHAT-01
Test Case Name:	Access Chat Interface
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can open chatbot UI, send messages, and receive helpful, formatted wellness responses from Gemini API.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User selects ChatBot tab.	
	2- System displays chat view with previous messages list.
3- User enters wellness question (e.g. "What are the common side effects of Metformin?") and clicks Send.	
	4- System displays user bubble. Sends text query to Gemini API. Retrieves response. Displays assistant response bubble in real-time.
Testing Requirement:
Testing Condition:	Active internet connection. Gemini API key must be valid.
Input Data:	User message text
Expected Result:	Messages log chronologically, and Gemini response is fetched and displayed. Offline state prompts connection warning.
Actual Result:	Chat loaded. API response returned and formatted within 2 seconds.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-CHAT-02: Apply Safety Filters & Rules
Test case ID:	TC-CHAT-02
Test Case Name:	Apply Safety Filters & Rules
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system applies safety filter rules to block inappropriate, abusive, or dangerous prompts.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User enters unsafe/harmful text question in chat input box (e.g. self-harm queries or abusive language) and clicks send.	
	2- System sanitizes string, matches safety filters on client/backend layer. Blocks request from being sent to generative model.
	3- System displays a default safety warning message in the chat feed (e.g. "I cannot answer this question as it violates safety guidelines."). Safety rules update dynamically from backend.
Testing Requirement:
Testing Condition:	Safety filters active inside chatbot controller.
Input Data:	Harmful text string prompt
Expected Result:	Prompt blocked, model call bypassed, safety feedback displayed.
Actual Result:	Safety filters intercepted unsafe prompt successfully, displaying standard safety warning.
Priority:	High.
Frequency:	Average
Test Acceptance:	Passed
________________________________________
2.2.11 Help & Support
TC-HELP-01: View User Guide
Test case ID:	TC-HELP-01
Test Case Name:	View User Guide
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can open user guide inside Help & Support, detailing how to add medicine and configure alerts.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Help & Support, taps User Guide card.	
	2- System loads and displays user guide content layout. Detail blocks describe steps for scheduling, stock updates, and calendar actions.
Testing Requirement:
Testing Condition:	Guide content must be formatted and stored locally.
Input Data:	None
Expected Result:	User guide document loaded, scrolling functional.
Actual Result:	Guide displayed with clear markdown structure.
Priority:	Low.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-HELP-02: Submit Contact/Feedback Form
Test case ID:	TC-HELP-02
Test Case Name:	Submit Contact/Feedback Form
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that submitting feedback launches the default email client with support email pre-populated.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks "Send Feedback/Contact Us" in Help view.	
	2- System utilizes url_launcher package to trigger native system intent protocols. Launches default mail client app.
	3- Pre-populates the recipient field with the developer support address (e.g. support@medcare.com) and pre-fills email subject.
Testing Requirement:
Testing Condition:	Device must have email client configured. Launcher schemes must be declared.
Input Data:	None
Expected Result:	Email application opens successfully showing correct support mail parameters.
Actual Result:	Default Gmail client launched displaying correct pre-filled values.
Priority:	Low.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-HELP-03: View About Section
Test case ID:	TC-HELP-03
Test Case Name:	View About Section
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can open About section showing application version, credits, and contact info.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User goes to Profile, selects Settings, taps About section.	
	2- System pulls app configuration values and renders screen displaying MedCare Version (e.g. 1.0.0+1), developers information, and copyrights.
Testing Requirement:
Testing Condition:	Data values must match the compiled application manifest.
Input Data:	None
Expected Result:	About screen displayed showing correct version and developer credits.
Actual Result:	About screen loaded. Version 1.0.0+1 matches build values.
Priority:	Low.
Frequency:	Occasionally
Test Acceptance:	Passed
________________________________________
2.2.12 Settings & Preferences
TC-SET-01: Change App Theme
Test case ID:	TC-SET-01
Test Case Name:	Change App Theme
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can toggle between Light and Dark themes, immediately swapping style layouts and saving preference locally.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User goes to Settings, toggles "Dark Theme" switch.	
	2- System swaps theme parameters instantly. Saves theme preference index inside local Hive cache box.
	3- Reloads interface styles dynamically without rebuilding full routes. Preference is preserved when app restarts.
Testing Requirement:
Testing Condition:	Theme provider registered at root context level.
Input Data:	Theme Switch Toggle (Boolean)
Expected Result:	Color modes toggle, changes are saved locally, and colors are restored correctly upon restart.
Actual Result:	Theme swapped cleanly from light to dark. Preference retained upon app reload.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
TC-SET-02: Configure Notification Settings
Test case ID:	TC-SET-02
Test Case Name:	Configure Notification Settings
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that user can select custom sound rings for medicine reminders, play previews, and configure notification intervals.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User goes to Settings, opens "Notification Settings" -> "Change Sound".	
2- User selects custom sound track from list. Taps sound item.	
	3- System plays preview audio file (using audioplayers library). Saves selected sound path inside Hive settings card.
4- User saves settings.	
	5- System schedules future notifications mapped to custom sound channel configurations. Displays success confirmation.
Testing Requirement:
Testing Condition:	Sound tracks files must be present inside app assets. Audioplayers initialized.
Input Data:	Selected Sound Track Asset Name
Expected Result:	Preview plays, path is saved, and new notifications trigger with the chosen sound.
Actual Result:	Sound previews played cleanly. Custom alarms initialized with selected sound track.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-SET-03: Detect & Adjust Time Zone Automatically
Test case ID:	TC-SET-03
Test Case Name:	Detect & Adjust Time Zone Automatically
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system automatically detects changes in the device's time zone and recalculates reminder alarm schedules accordingly.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User changes device's local system time zone (e.g. from GMT+5 to GMT+1) while traveling. Opens app.	
	2- System utilizes flutter_timezone library to detect new time zone automatically.
	3- System checks active alarm parameters in Hive, recalculates the trigger times based on the new local time zone parameters.
	4- System reschedules local alarms immediately. Displays info card: "Time zone changed, alerts updated."
Testing Requirement:
Testing Condition:	Device location/settings must allow timezone queries. timezone package initialized.
Input Data:	Device System Time Zone Change
Expected Result:	Time zone detected automatically, alarms reprogrammed, and medicine reminder alerts triggered at the correct local hour.
Actual Result:	Time zone change detected, alarms successfully updated to local time.
Priority:	Medium.
Frequency:	Occasionally
Test Acceptance:	Passed
________________________________________
2.2.13 Analytics & Data Visualization
TC-ANL-01: View Medicine Consumption Reports
Test case ID:	TC-ANL-01
Test Case Name:	View Medicine Consumption Reports
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system displays dose consumption counts for each medicine, allowing daily/weekly/monthly filter selections. Highlights irregular intakes.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User opens Analytics tab.	
	2- System queries Hive daily compliance database. Displays medicine intake counts charts.
3- User selects filter duration tab (Weekly / Monthly).	
	4- System re-queries lists, updates charts view. Highlights medicines with irregular/poor intake (< 70% adherence) in warning color.
Testing Requirement:
Testing Condition:	Intake history logs must exist. UI utilizes fl_chart package.
Input Data:	Filter selection input (Weekly / Monthly)
Expected Result:	Analytics chart displays correct numbers. Irregular compliance medicines highlighted.
Actual Result:	Charts rendered. Week filter correctly displays compliance percentages.
Priority:	Medium.
Frequency:	High frequent
Test Acceptance:	Passed
TC-ANL-02: View Missed Doses Reports
Test case ID:	TC-ANL-02
Test Case Name:	View Missed Doses Reports
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system lists details of missed doses (times and dates) and tracks total count per period.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User clicks on Analytics, and selects "Missed Doses Log".	
	2- System queries compliance database, filters records where state was logged as "Missed" or left unlogged.
	3- Lists missed medicines showing exact scheduled hours. Displays total count value at the top header card.
Testing Requirement:
Testing Condition:	Database must contain historical compliance data.
Input Data:	None
Expected Result:	Lists missed slots. Total counter displays correct value representing the select period.
Actual Result:	Missed doses log rendered. Total count matches computed database values.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed
TC-ANL-03: Display Monthly Summary
Test case ID:	TC-ANL-03
Test Case Name:	Display Monthly Summary
Test Case created by:	Atif Islam	Use Test created on:	06/07/2026
Test Case Updated by:	Awais Ali	Use Test Updated On:	06/07/2026
Test Case Description:	Verify that system compiles intake and missed data logs to render interactive monthly compliance charts.
Primary Actor:	<Patient>
Main success scenario:
User Action	System Response
1- User scrolls to "Monthly Report Overview" card inside Analytics.	
	2- System aggregates data logs for past 30 days. Compares "Taken" vs "Missed" totals.
	3- Draws line graphs or bar charts representing daily intake progress and monthly compliance curves.
Testing Requirement:
Testing Condition:	fl_chart widgets loaded inside context. Data range spans 30 calendar days.
Input Data:	None
Expected Result:	Monthly chart renders accurately showing medication adherence progress curves.
Actual Result:	Compliance charts loaded without issues. Adherence curves reflect logs.
Priority:	Medium.
Frequency:	Average
Test Acceptance:	Passed

