# NeuraSampleIOS

<img src="https://cloud.githubusercontent.com/assets/4048393/19759725/f48361d4-9c36-11e6-9fdc-126c2de8e181.png" alt="missing_gym" width="210" height="350">
<img src="https://cloud.githubusercontent.com/assets/4048393/19759726/f485b5a6-9c36-11e6-8be3-88ded2f0e1ea.png" alt="neura_login" width="210" height="350">
<img src="https://cloud.githubusercontent.com/assets/4048393/19759724/f48163f2-9c36-11e6-9ae0-3cd7f471968c.jpg" alt="permissions" width="210" height="350">

##Introduction
This is a sample code for integrating <a href="http://www.theneura.com/">Neura</a> with a native IOS application.<br/>
Go to <a href="https://dev.theneura.com/docs/getstarted">getting started with Neura</a> for more details.

##Requirements 
1. Basic IOS knowledge.
2. xCode installed.

##Before you start
1. Go over the <a href="https://dev.theneura.com/docs/guide/ios/sdk">ios sdk guide</a>.
2. Neura sdk has fully methods and classes reference, <a href ="http://docs.theneura.com/ios/">check it out</a>

After that, you can start playing with this sample.

##Integrate your own credentials in the NeuraSample project
If you wish to take this sample application, and integrate your own application, here are some basic steps that will help you during integration : 

1. <a href ="https://dev.theneura.com/console/new">Add an application</a>(If you haven't registers to Neura, you'll have to create a new account).
  - Make sure that under 'Tech Info' (2nd section) you're specifying your own 'App Bundle ID'. 
  - Under 'Permissions' select the permissions and services you want to receive from Neura.
2. Apply your own definitions to the sample application
  - Open ```appDelegate```, and update ```app_uid``` and ```app_secret``` with your own values.
    <br/>Your values can be received from <a href="https://dev.theneura.com/console/">Applications console</a>, just copy your uid and secret : <br/>
    ![uid_secret](https://s21.postimg.org/3qpj2gurr/uid_secret.png)
  - Open ```loginToNeura``` , and copy the permissions you've declared to your application from 'Permissions' section to ```permissions``` variable.<br/>
    <img src="https://s17.postimg.org/uwq3v3te7/Screen_Shot_2016_08_30_at_1_27_59_PM.png" alt="permissions_list" width="600" height="150">
  - In order to receive events from Neura, follow our <a href="https://dev.theneura.com/docs/guide/ios/pushnotification"> push notification guide</a> to integrate <a href="https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html#//apple_ref/doc/uid/TP40012582-CH26-SW7">Apple Push Notification</a>.

##Subscribe to events
If you wish to be notified from Neura when an event occurs, you need to <a href="https://dev.theneura.com/docs/guide/ios/setup/">subscribe to event</a>.<br/>
In this sample application, once the subscriptions is enabled, you'll be notified of the event. For example, in this screenshot, you'll be notified for the event 'UserWokeUp', but not for 'UserStartedWorkOut'.
<br/><img src="https://cloud.githubusercontent.com/assets/4048393/19760715/93b610fe-9c3b-11e6-8469-d961170c92ab.jpg" alt="subscriptions" width="210" height="350">

##Testing while developing
TBD

##Support
1. Go to <a href="https://dev.theneura.com/docs/getstarted">getting started with Neura</a> for more details.
2. You can read classes and api methods at <a href ="http://docs.theneura.com/ios">Neura Sdk Reference</a>.
3. You can ask question and view existing questions with the Neura tag on <a href="https://stackoverflow.com/questions/tagged/neura?sort=newest&pageSize=30">StackOverflow</a>.
