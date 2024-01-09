# User Stories

This user stories will help us with documentation to have a more correctly and well thought out implementation of the different functionalities of our app.

## Actors

Actors are different types of users that frequent our app.

| Identifier | Description |
| ----- | ----------------- |
| Visitor | A visitor is a not authenticaded user in our system, they can only see some static pages and login/register form. |
| Student | A student is an authenticaded user, they can use **SUP?** to its fullest extent. |

## User Stories

User Stories are a brief description of all the potencial interactions that the actors, previously described, have with the system.

### Visitor

| Identifier | Name | Description |
| ------ | ------- | ------------------ |
| US001 | *Sign-up* | As a visiter I want to sign-up/register into the system to be able to sign-in into the app. |
| US002 | *Sign-in* | As a visiter I want to sign-in into the system to use all the app functionalities. |
| US003 | *Check About us* | As a visitor I want to see who developed the app to get a better idea of who's behind *S.U.P.?* |
| US004 | *Check Contacts* | As a visitor I want to see the contact info of the app managers so that I am able to contact them. |
| US005 | *Get Help* | As a visitor I want to see the help page to better understand how to use the app. |
| US006 | *See Main features* | As a visitor I want to see the main features of the app to know what to use the app for. |

### Student

| Identifier | Name | Description |
| ------ | ------- | ------------------ |
| US101 | *Sign-out* | As a student I want to sign-out of my account so that it's not used in my absence. |
| US102 | *Delete my account* | As a student I want to delete my account so that it's no longer used. |
| US103 | *Change password* | As a student I want to be able to change my password to ensure the integrity of my account. |
| US104 | *See course average* | As a student I want to be able to see my course's average. |
| US104 | *See subject average* | As a student I want to be able to see my average at a specific subject so that I can get that information. |
| US104 | *Customize apperance* | As a student I want to be able to customize  my account so that I can see everything the way I like. |
| US104 | *Customize subject's order* | As a student I want to be able to customize  my subjects' order so that I can see them in a way that benefits me. |
| US104 | *Customize  subject's formula* | As a student I want to be able to change my subjects' evaluation formula if they are wrong so that I can compute my final grade. |
| US104 | *Add/Remove courses* | As a student I want to add/remove courses, so I can have the courses that i am enroled in. |
| US104 | *Add/Remove subjects* | As a student I want to add/remove subjects, so I can have all the subjects that i am subscribed and want to calculate the grade. |
| US104 | *Check minimum grade needed* | As a student I want to to check the minum grade needed, so I can see if I already passed the course or need to go to an exam |


## Acceptance tests

Acceptance tests are, as the name it self indicates, tests for each user story, they are desinged to help us, the developers, test the app and confirm that it's satisfying  the requirements addressed by each of the user stories.

| Identifier | US Identifier | Description |
| ---------- | ------------- | ----------- |
| AT001      | US001         | 1. Given there's a visitor trying to sign-up <br>When they click the sign-up button <br>Then an account creation form should be displayed. <br>2. Given the visitor inputs their data <br>When they click the create account button <br>Then the app should save this data and allow the user to login with it. |or request the user to repeat this step. | 
| AT002      | US002         | 1. Given there's a visitor trying to log-in <br>When they click the log-in button <br>Then an log-in form should be displayed. <br>2. Given the visitor inputs correct data into the log-in form <br>When they click the log-in button <br>Then the app should compare this data and login the user or request the user to repeat this step. | 
| AT003      | US003         | 1. Given there's a visitor trying to see who's behind the app <br>When they click the *About Us* button <br>Then a page with information about us should be displayed.
| AT004      | US004         | 1. Given there's a visitor trying to contact who's behind the app <br>When they click the *Contacts* button <br>Then a page with information about our contacts should be displayed.
| AT005      | US005         | 1. Given there's a visitor trying to get assistance to use the app <br>When they click the *Help* button <br>Then a page with information about how to use the app should be displayed.
| AT006      | US006         | 1. Given there's a visitor trying to see what they can use the app for <br>When they click the *Main Features* button <br>Then a page with information about the app's main features should be displayed.
