# Product Vision

## Vision Stament
To help students cope with their pre-exam stress, *Shall You Pass?*, intends to give users a bug free, easy and fast way to determine their subject's grade and possible minimum exam grade.

No more human errors. No more *Oh I didn't know*'s. No more wasted time manually computing subjects' grades. 

## Main Features

| Feature | Name | Description |
| --- | --- | --- |
| F01 | Subject average | Based on user input for different projects/tests/exams compute the subject's grade. |
| F02 | Course average | Based on user input on different subjects, compute the course average taking into account the weight (ECTS) of each subject. |
| F03 | Minimum exam grade | Based on user input for different projects/tests/exams calculate the minimum grade needed on the next exam that allows the user to still pass the subject. |
| F04 | Costumize grade formula | Allow the user to switch the current grade computation formula to one choosen by the user. |
| F05 | Alter grade components | Allow the user to add/remove projects/tests/exams that are used on the grade formula. |
| F06 | Costumization options | Allow the user to change the overall feel of the app. eg. colors, subject's order. |
| F07 | Recomend components grade's | Based on user input for their choosen grade on any given subject recommend grades to get on different components (recomendation formula to be discussed later). |
| F08 | Notes | Allow the user to take small notes inside the app and attatch them to any subject. |

## Required API's

| API | Description |
| --- | --- |
| User's *SIGARRA* profile | It would speed up the time required to input data if we already had some of that data, that is data that refers to the student's grades and any given subject and data that refers to the current courses that the student has. |
| Subject's *SIGARRA* page | It would help out the devs of the app if in the beginning of each semester the app could retrieve all the subject's grade's formula and automatically add/update it. |
