## Description
The app allows you to view information about your **intra 42** profile and search for information about other students.
The student profile shows the student's current location in school, level, tables with completed projects, skill charts, etc.
In order to start searching for students, you need to sign in to your profile (if you are not a student of the school, you will not be able to sign in at all).
The *oauth2* protocol and *ASWebAuthenticationSession* web service are used for authorization.
After two hours, the authorization token expires and a new one is created to continue to use the application.

## Technologies used
- UIKit
- URLSession
- Auto Layout
- ASWebAuthentication
- Cocoapods (Charts)

## Architecture
MVVM + Data-driven UI

## App Overview
#### Screens
<p align="center">
	<img src="./Screens/start_screen.png" width="190" />
	<img src="./Screens/authenticatioin.png" width="190" />
	<img src="./Screens/searchUserScreen.png" width="190" />
	<img src="./Screens/user_not_found.png" width="190" />
</p>

<p align="center">
	<img src="./Screens/error_network.png" width="190" />
	<img src="./Screens/home_page.png" width="190" />
	<img src="./Screens/skills_chart.png" width="190" />
	<img src="./Screens/searched_user_screen.png" width="190" />
</p>


<p align="center">
	<img src="./Screens/overview.gif" alt="animated" width="300" />
</p>
