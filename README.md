# Description

This app gets data from the Trello API and breaks it down into useful card statistics.

# Info

- Ruby Version: 2.3.0
- Rails Version: 5.0.0.1
- This repo has been setup such that it will run through Travis CI and auto-deploy to Heroku (for Master) and AWS Elastic Beanstalk (for Production) after a successful build takes place. 

# Set Up

1. Clone this repo.

2. Execute bundle install, set up relevant gems.

3. Define the following environment variables in a .env file (or equivalent):

	- DEVELOPER_PUBLIC_KEY=27dbf126a87c20a0a1a6c9f81fcc2e98

	- TRELLO_MEMBER_TOKEN=(Follow this URL: "https://trello.com/1/authorize?key=27dbf126a87c20a0a1a6c9f81fcc2e98&scope=read%2Cwrite&name=Dius+Trello+Stats+Getter&expiration=never&response_type=token", and put the token provided to you in this location)

	- TRELLO_MEMBER_ID=(Navigate to "Trello", then to your "Profile". Look at the URL; it will be in the format of https://trello.com/sampleid12345. Put your ID in this location. E.g. In this case, "sampleid12345")

	- TRELLO_BOARD_NAME=(The full name of the Trello board that you wish to monitor belongs here, e.g. "TESTING - Sydney Recruitment Board")

	- GOOGLE_CLIENT_ID=(Your Google client ID, from Google's API Console)

	- GOOGLE_CLIENT_SECRET=(Your Google client secret, from Google's API Console)

	- SECRET_KEY_CUSTOM=(Your Devise secret_key goes here)

	- RDS_DB_NAME=(The name of your database)

	- RDS_USERNAME=(The username of your Mysql account)

	- RDS_PASSWORD=(The password of your Mysql account)

	- RDS_HOSTNAME=(E.g. localhost)

	- RDS_PORT=(E.g. 3000)

4. Start your server!
