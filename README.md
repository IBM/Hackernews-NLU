[![Build Status](https://travis-ci.org/IBM/Hackernews-NLU.svg?branch=master)](https://travis-ci.org/IBM/Hackernews-NLU)
![IBM Code Deployments](https://metrics-tracker.mybluemix.net/stats/47c4243d2ddb563afd98dcc8f44d689d/badge.svg)

# Hackernews-NLU

Hackernews-NLU is a sample application that uses Watson Natural Language Understanding service to analyze the contents of trending news articles on Hackernews to give information about the concepts, entities, categories, keywords, sentiment, emotion etc. about the news article.

## Application Workflow Diagram
![Application Workflow](images/archi.png)

* The user deploys the application to IBM Code.
* Application loads the data from the Hackernews API.
* The user interacts with the application UI using their browser.
* When the user performs any action, UI calls the server application API which uses the Watson NLU service to analyze the respective news article.

## Included Components
- IBM Code Watson Natural Language Understanding service
- Hackernews API

## Deploying the Application to IBM Code

You can deploy the application using any one of the following ways:
- Deploy to IBM Code button
- IBM Code command line

### a) Using the Deploy to IBM Code button
Clicking on the button below creates a IBM Code DevOps Toolchain and deploys this application to IBM Code. The `manifest.yml` file [included in the repo] is parsed to obtain the name of the application, configuration details, and the list of services that should be provisioned. For further details on the structure of the `manifest.yml` file, see the [Cloud Foundry documentation](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html#minimal-manifest).

[![Deploy to IBM Code](https://metrics-tracker.mybluemix.net/stats/47c4243d2ddb563afd98dcc8f44d689d/button.svg)](https://bluemix.net/deploy?repository=https://github.com/IBM/Hackernews-NLU.git)

Once deployment to IBM Code is completed, you can view the deployed application and services from your IBM Code account.

### b) Using the IBM Code command line
You can also manually deploy the Hackernews-NLU app to IBM Code. Though not as magical as using the IBM Code button above, manually deploying the app gives you some insights about what is happening behind the scenes. Remember that you'd need the IBM Code [command line](http://clis.ng.bluemix.net/ui/home.html) installed on your system to deploy the app to IBM Code.

Execute the following command to clone the Git repository:

```bash
git clone https://github.com/IBM/Hackernews-NLU.git
```

Go to the project's root folder on your system and execute the `Cloud-Scripts/services/services.sh` script to create the service Hackernews-NLU depends on. Please note that you should have logged on to IBM Code before attempting to execute this script. For information on how to log in, see the IBM Code [documentation](https://console.ng.bluemix.net/docs/starters/install_cli.html).

Executing the `Cloud-Scripts/services/services.sh` script should result in output similar to this:

```bash
$ Cloud-Scripts/services/services.sh
Creating service...
Invoking 'cf create-service natural-language-understanding free Hackernews-NLU'...

Creating service instance Hackernews-NLU in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com...
OK
Service created.
```

After the service is created, you can issue the `bx app push` command from the project's root folder to deploy the Swift-Enterprise-Demo application to IBM Code.

```bash
$ bx app push
Invoking 'cf push'...

Using manifest file /Users/ishan/Documents/ishan-git-demos/Hackernews-NLU/manifest.yml

Creating app HackernewsNLU in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com...
OK

Creating route hackernewsnlu-seventieth-cockiness.mybluemix.net...
OK

Binding hackernewsnlu-seventieth-cockiness.mybluemix.net to HackernewsNLU...
OK

Uploading HackernewsNLU...
Uploading app files from: /Users/ishan/Documents/ishan-git-demos/Hackernews-NLU
Uploading 237.8K, 35 files
Done uploading               
OK
Binding service Hackernews-NLU to app HackernewsNLU in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com...
OK

Starting app HackernewsNLU in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com...
Downloading swift_buildpack...
Downloaded swift_buildpack
Creating container
Successfully created container
Downloading app package...
Downloaded app package (196.3K)
Staging...
-----> Buildpack version 2.0.6
-----> Default supported Swift version is 3.1.1
-----> Configure for apt-get installs...
-----> Writing profile script...
-----> Copying deb files to installation folder...
-----> No Aptfile found.
-----> Getting swift-3.1.1
       Cached swift-3.1.1
-----> Unpacking swift-3.1.1.tar.gz
-----> Getting clang-4.0.0
       Cached clang-4.0.0
-----> Unpacking clang-4.0.0.tar.xz
-----> .ssh directory and config file not found.
-----> Skipping cache restore (new swift signature)
-----> Fetching Swift packages and parsing Package.swift files...
       Fetching https://github.com/IBM-Swift/Configuration.git
       Fetching https://github.com/IBM-Swift/CloudConfiguration.git
       Fetching https://github.com/IBM-Swift/BlueSSLService.git
       Fetching https://github.com/IBM-Swift/Swift-cfenv.git
       Fetching https://github.com/IBM-Swift/SwiftyJSON.git
       Resolving https://github.com/IBM-Swift/Kitura.git at 1.7.3
       Cloning https://github.com/IBM-Swift/BlueSignals.git
       Resolving https://github.com/IBM-Bluemix/cf-deployment-tracker-client-swift.git at 3.0.2
       Resolving https://github.com/IBM-Swift/Swift-cfenv.git at 4.0.2
       Cloning https://github.com/IBM-Swift/CloudConfiguration.git
       Fetching https://github.com/IBM-Swift/Kitura.git
       Fetching https://github.com/IBM-Swift/HeliumLogger.git
       Fetching https://github.com/IBM-Bluemix/cf-deployment-tracker-client-swift.git
       Fetching https://github.com/IBM-Swift/CCurl.git
       Fetching https://github.com/IBM-Swift/Kitura-TemplateEngine.git
       Fetching https://github.com/IBM-Swift/Kitura-net.git
       Fetching https://github.com/IBM-Swift/LoggerAPI.git
       Fetching https://github.com/IBM-Swift/BlueSocket.git
       Fetching https://github.com/IBM-Swift/CEpoll.git
       Fetching https://github.com/IBM-Swift/BlueSignals.git
       Fetching https://github.com/IBM-Swift/OpenSSL.git
       Cloning https://github.com/IBM-Swift/Kitura-net.git
       Resolving https://github.com/IBM-Swift/Kitura-net.git at 1.7.5
       Resolving https://github.com/IBM-Swift/BlueSignals.git at 0.9.47
       Cloning https://github.com/IBM-Swift/LoggerAPI.git
       Resolving https://github.com/IBM-Swift/LoggerAPI.git at 1.7.0
       Cloning https://github.com/IBM-Swift/BlueSocket.git
       Resolving https://github.com/IBM-Swift/BlueSocket.git at 0.12.47
       Cloning https://github.com/IBM-Swift/HeliumLogger.git
       Resolving https://github.com/IBM-Swift/HeliumLogger.git at 1.7.0
       Cloning https://github.com/IBM-Swift/Swift-cfenv.git
       Cloning https://github.com/IBM-Swift/Configuration.git
       Resolving https://github.com/IBM-Swift/Configuration.git at 1.0.0
       Cloning https://github.com/IBM-Swift/CEpoll.git
       Resolving https://github.com/IBM-Swift/CEpoll.git at 0.1.0
       Resolving https://github.com/IBM-Swift/CloudConfiguration.git at 2.0.1
       Cloning https://github.com/IBM-Swift/Kitura-TemplateEngine.git
       Resolving https://github.com/IBM-Swift/Kitura-TemplateEngine.git at 1.7.0
       Cloning https://github.com/IBM-Swift/CCurl.git
       Resolving https://github.com/IBM-Swift/CCurl.git at 0.2.3
       Cloning https://github.com/IBM-Swift/SwiftyJSON.git
       Resolving https://github.com/IBM-Swift/SwiftyJSON.git at 16.0.0
       Cloning https://github.com/IBM-Swift/OpenSSL.git
       Resolving https://github.com/IBM-Swift/OpenSSL.git at 0.3.5
       Cloning https://github.com/IBM-Swift/BlueSSLService.git
       Resolving https://github.com/IBM-Swift/BlueSSLService.git at 0.12.33
       Cloning https://github.com/IBM-Swift/Kitura.git
       Cloning https://github.com/IBM-Bluemix/cf-deployment-tracker-client-swift.git
-----> Additional packages to download: libcurl4-openssl-dev openssl libssl-dev
-----> libcurl4-openssl-dev is already installed.
-----> openssl is already installed.
-----> libssl-dev is already installed.
-----> No additional packages to download.
-----> Skipping installation of App Management (debug)
-----> Installing system level dependencies...
-----> Building Package...
-----> Build config: release
       Compile Swift Module 'Socket' (3 sources)
       Compile Swift Module 'SwiftyJSON' (2 sources)
       Compile Swift Module 'Signals' (1 sources)
       Compile Swift Module 'KituraTemplateEngine' (1 sources)
       Compile Swift Module 'LoggerAPI' (1 sources)
       Compile Swift Module 'Configuration' (6 sources)
       Compile Swift Module 'HeliumLogger' (2 sources)
       Compile Swift Module 'TestProgram' (1 sources)
       Compile Swift Module 'CloudFoundryEnv' (6 sources)
       Linking ./.build/release/TestProgram
       Compile Swift Module 'SSLService' (1 sources)
       Compile CHTTPParser utils.c
       Compile CHTTPParser http_parser.c
       Compile Swift Module 'CloudFoundryConfig' (2 sources)
       Linking CHTTPParser
       Compile Swift Module 'KituraNet' (34 sources)
       Compile Swift Module 'CloudFoundryDeploymentTracker' (1 sources)
       Compile Swift Module 'Kitura' (43 sources)
       Compile Swift Module 'HackernewsNLU' (3 sources)
       Linking ./.build/release/HackernewsNLU
-----> Copying dynamic libraries
-----> Copying binaries to 'bin'
-----> Clearing previous swift cache
-----> Saving cache (default):
-----> - .build
-----> Optimizing contents of cache folder...
No start command specified by buildpack or via Procfile.
App will not start unless a command is provided at runtime.
Exit status 0
Uploading droplet, build artifacts cache...
Staging complete
Uploading build artifacts cache...
Uploading droplet...
Uploaded build artifacts cache (18.7M)
Uploaded droplet (90.2M)
Uploading complete
Destroying container
Successfully destroyed container

0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
0 of 1 instances running, 1 starting
1 of 1 instances running

App started


OK

App HackernewsNLU was started using this command `HackernewsNLU -bind 0.0.0.0:$PORT`

Showing health and status for app HackernewsNLU in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com...
OK

requested state: started
instances: 1/1
usage: 512M x 1 instances
urls: hackernewsnlu-seventieth-cockiness.mybluemix.net
last uploaded: Wed Jun 21 18:21:15 UTC 2017
stack: unknown
buildpack: swift_buildpack

     state     since                    cpu    memory         disk           details
#0   running   2017-06-21 11:25:53 AM   3.1%   5.6M of 512M   271.6M of 1G
```

Once the application is running on IBM Code, you can access your application assigned URL (i.e. route). To find the route, you can log on to your [IBM Code account](https://console.ng.bluemix.net), or you can inspect the output from the execution of the `bx app push` or `bx app show <application name>` commands. The string value shown next to the `urls` field contains the assigned route.  Use that route as the URL to access the sample server using the browser of your choice.

```bash
$ bx app show HackernewsNLU
Invoking 'cf app HackernewsNLU'...

Showing health and status for app HackernewsNLU in org ishan.gulhane@ibm.com / space dev as ishan.gulhane@ibm.com...
OK

requested state: started
instances: 1/1
usage: 512M x 1 instances
urls: hackernewsnlu-seventieth-cockiness.mybluemix.net
last uploaded: Wed Jun 21 18:21:15 UTC 2017
stack: cflinuxfs2
buildpack: swift_buildpack

     state     since                    cpu    memory         disk           details
#0   running   2017-06-21 11:25:53 AM   0.2%   5.8M of 512M   271.6M of 1G
```

# Learn more

* **Artificial Intelligence Patterns:** Enjoyed this Pattern? Check out our other [AI Patterns](https://developer.ibm.com/code/technologies/artificial-intelligence/).
* **Data Analytics Patterns:** Enjoyed this Pattern? Check out our other [Data Analytics Patterns](https://developer.ibm.com/code/technologies/data-science/)
* **AI and Data Pattern Playlist:** Bookmark our [playlist](https://www.youtube.com/playlist?list=PLzUbsvIyrNfknNewObx5N7uGZ5FKH0Fde) with all of our Pattern videos
* **With Watson:** Want to take your Watson app to the next level? Looking to utilize Watson Brand assets? [Join the With Watson program](https://www.ibm.com/watson/with-watson/) to leverage exclusive brand, marketing, and tech resources to amplify and accelerate your Watson embedded commercial solution.
* **Data Science Experience:** Master the art of data science with IBM's [Data Science Experience](https://datascience.ibm.com/)
* **PowerAI:** Get started or get scaling, faster, with a software distribution for machine learning running on the Enterprise Platform for AI: [IBM Power Systems](https://www.ibm.com/ms-en/marketplace/deep-learning-platform)
* **Spark on IBM Cloud:** Need a Spark cluster? Create up to 30 Spark executors on IBM Cloud with our [Spark service](https://console.bluemix.net/catalog/services/apache-spark)
* **Kubernetes on IBM Cloud:** Deliver your apps with the combined the power of [Kubernetes and Docker on IBM Cloud](https://www.ibm.com/cloud-computing/bluemix/containers)

# License
[Apache 2.0](LICENSE)

## Privacy Notice
The sample application includes code to track deployments to [IBM Cloud](https://www.bluemix.net/) and other Cloud Foundry platforms. The following information is sent to a [Deployment Tracker](https://github.com/IBM/metrics-collector-service) service on each deployment:

* Swift project code version (if provided)
* Swift project repository URL
* Application Name (`application_name`)
* Space ID (`space_id`)
* Application Version (`application_version`)
* Application URIs (`application_uris`)
* Labels and names of bound services
* Number of instances for each bound service and associated plan information

This data is collected from the parameters of the `MetricsTrackerClient`, the `VCAP_APPLICATION` and `VCAP_SERVICES` environment variables in IBM Cloud and other Cloud Foundry platforms. This data is used by IBM to track metrics around deployments of sample applications to IBM Cloud to measure the usefulness of our examples, so that we can continuously improve the content we offer to you. Only deployments of sample applications that include code to ping the Deployment Tracker service will be tracked.

### Disabling Deployment Tracking
Deployment tracking can be disabled by removing the following lines from [Sources/main.swift](Sources/main.swift):

    MetricsTrackerClient(repository: "Hackernews-NLU", organization: "IBM").track()
