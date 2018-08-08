[![Build Status](https://travis-ci.org/IBM/Hackernews-NLU.svg?branch=master)](https://travis-ci.org/IBM/Hackernews-NLU)

# Use Swift to interpret unstructured data from Hacker News

This code pattern is a sample application that uses Watson Natural Language Understanding service to analyze the contents of trending news articles on Hackernews to give information about the concepts, entities, categories, keywords, sentiment, emotion etc. about the news article.

## Flow

![](images/arch.png)

1. The user deploys the application to IBM Cloud.
1. Application loads the data from the Hackernews API.
1. The user interacts with the application UI using their browser.
1. When the user performs any action, UI calls the server application API which uses the Watson NLU service to analyze the respective news article.

## Included Components

* [Watson Natural Language Understanding](https://www.ibm.com/watson/developercloud/natural-language-understanding.html): An IBM Cloud service that can analyze text to extract meta-data from content such as concepts, entities, keywords, categories, sentiment, emotion, relations, semantic roles, using natural language understanding.

## Featured Technologies

* [Artificial Intelligence](https://medium.com/ibm-data-science-experience): Artificial intelligence can be applied to disparate solution spaces to deliver disruptive technologies.

## Steps

### Deploying the Application to IBM Cloud

You can deploy the application by using the `Deploy to IBM Cloud` button or via the `IBM Cloud CLI`.

### Using the `Deploy to IBM Cloud` button

Clicking on the button below creates a IBM Cloud DevOps Toolchain and deploys this application to IBM Cloud. The [`manifest.yml`](manifest.yml) file included in the repo is parsed to obtain the name of the application, configuration details, and the list of services that should be provisioned.

[![Deploy to IBM Cloud](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/IBM/Hackernews-NLU)

Once deployment to IBM Cloud is completed, you can view the deployed application and services from your IBM Cloud account.

### Using the CLI

You can also manually deploy the app to IBM Cloud. Though not as magical as using the IBM Cloud button above, manually deploying the app gives you some insights about what is happening behind the scenes. Remember that you'd need the IBM Cloud [command line](http://clis.ng.bluemix.net/ui/home.html) installed on your system to deploy the app to IBM Cloud.

Execute the following command to clone the repository:

```bash
git clone https://github.com/IBM/Hackernews-NLU.git
```

Go to the project's root folder on your system and execute the [`services.sh`](Cloud-Scripts/services/services.sh) script to create the service Hackernews-NLU depends on. Please note that you should have logged on to IBM Cloud before attempting to execute this script. For information on how to log in, see the IBM Cloud [documentation](https://console.ng.bluemix.net/docs/starters/install_cli.html).

Executing the [`services.sh`](Cloud-Scripts/services/services.sh) script will create an NLU service called `HackernewsNLU`

```bash
$ Cloud-Scripts/services/services.sh
Creating service...
Invoking 'cf create-service natural-language-understanding free HackernewsNLU'...

Creating service instance HackernewsNLU in org test@example.com / space dev as test@example.com...
OK
Service created.
```

After the service is created, you can issue the `bx app push` command from the project's root folder to deploy the application to IBM Cloud.

```bash
$ bx app push
Invoking 'cf push'...

Pushing from manifest to org test@example.com / space dev as test@example.com...
Using manifest file /Users/stevemar/workspace/Hackernews-NLU/manifest.yml
Getting app info...
Creating app with these attributes...
+ name:         HackernewsNLU
  path:         /Users/stevemar/workspace/Hackernews-NLU
+ buildpack:    swift_buildpack
+ command:      HackernewsNLU
+ disk quota:   1G
+ instances:    1
+ memory:       256M
  services:
+   HackernewsNLU
  routes:
+   hackernewsnlu-rested-aligator.mybluemix.net

Creating app HackernewsNLU...
Mapping routes...
Binding services...
Comparing local files to remote cache...
Packaging files to upload...
Uploading files...
 150.65 KiB / 150.65 KiB [========================================================================================================] 100.00% 2s

Waiting for API to complete processing files...

Staging app and tracing logs...
   Downloading swift_buildpack...
   Downloaded swift_buildpack
   Creating container
   Successfully created container
   Downloading app package...
   Downloaded app package (224.3K)
   Staging...
   -----> Buildpack version 2.0.13
   -----> Default supported Swift version is 4.1.2
   -----> Configure for apt-get installs...
   -----> Writing profile script...
   -----> Copying deb files to installation folder...
   -----> No Aptfile found.
   -----> Getting swift-4.1
   -----> WARNING: You are requesting a custom version of Swift (defined in your .swift-version)
   -----> WARNING: Default supported Swift version: swift-4.1.2
   -----> WARNING: Requested Swift version for your app: swift-4.1
   -----> WARNING: The buildpack will attempt to download requested version from Swift.org
          Downloaded swift-4.1
   -----> Unpacking swift-4.1.tar.gz
   -----> Getting clang-4.0.0
          Cached clang-4.0.0
   -----> Unpacking clang-4.0.0.tar.xz
   -----> .ssh directory and config file not found.
   -----> Skipping cache restore (new swift signature)
   -----> Fetching Swift packages and parsing Package.swift files...
          Fetching https://github.com/IBM-Swift/TypeDecoder.git
          Fetching https://github.com/IBM-Swift/BlueSSLService.git
          Fetching https://github.com/IBM-Swift/HeliumLogger.git
          Fetching https://github.com/IBM-Swift/LoggerAPI.git
          Fetching https://github.com/IBM-Swift/CCurl.git
          Fetching https://github.com/IBM-Swift/BlueSocket.git
          Fetching https://github.com/IBM-Swift/CloudConfiguration.git
          Fetching https://github.com/IBM-Swift/SwiftyJSON.git
          Fetching https://github.com/IBM-Swift/Kitura-TemplateEngine.git
          Fetching https://github.com/IBM-Swift/Kitura.git
          Fetching https://github.com/IBM-Swift/KituraContracts.git
          Fetching https://github.com/IBM-Swift/Swift-cfenv.git
          Fetching https://github.com/IBM-Swift/Kitura-net.git
          Fetching https://github.com/IBM-Swift/Configuration.git
          Fetching https://github.com/IBM-Swift/CEpoll.git
          Fetching https://github.com/IBM-Swift/BlueSignals.git
          Fetching https://github.com/IBM-Swift/OpenSSL.git
          Cloning https://github.com/IBM-Swift/TypeDecoder.git
          Resolving https://github.com/IBM-Swift/TypeDecoder.git at 1.1.0
          Cloning https://github.com/IBM-Swift/CEpoll.git
          Resolving https://github.com/IBM-Swift/CEpoll.git at 1.0.0
          Cloning https://github.com/IBM-Swift/BlueSSLService.git
          Resolving https://github.com/IBM-Swift/BlueSSLService.git at 1.0.14
          Cloning https://github.com/IBM-Swift/HeliumLogger.git
          Resolving https://github.com/IBM-Swift/HeliumLogger.git at 1.7.2
          Cloning https://github.com/IBM-Swift/LoggerAPI.git
          Resolving https://github.com/IBM-Swift/LoggerAPI.git at 1.7.3
          Cloning https://github.com/IBM-Swift/CCurl.git
          Resolving https://github.com/IBM-Swift/CCurl.git at 1.0.0
          Cloning https://github.com/IBM-Swift/OpenSSL.git
          Resolving https://github.com/IBM-Swift/OpenSSL.git at 1.0.1
          Cloning https://github.com/IBM-Swift/BlueSocket.git
          Resolving https://github.com/IBM-Swift/BlueSocket.git at 1.0.14
          Cloning https://github.com/IBM-Swift/CloudConfiguration.git
          Resolving https://github.com/IBM-Swift/CloudConfiguration.git at 2.0.6
          Cloning https://github.com/IBM-Swift/SwiftyJSON.git
          Resolving https://github.com/IBM-Swift/SwiftyJSON.git at 17.0.2
          Cloning https://github.com/IBM-Swift/Kitura-TemplateEngine.git
          Resolving https://github.com/IBM-Swift/Kitura-TemplateEngine.git at 2.0.0
          Cloning https://github.com/IBM-Swift/Kitura.git
          Resolving https://github.com/IBM-Swift/Kitura.git at 2.4.1
          Cloning https://github.com/IBM-Swift/KituraContracts.git
          Resolving https://github.com/IBM-Swift/KituraContracts.git at 1.0.2
          Cloning https://github.com/IBM-Swift/Swift-cfenv.git
          Resolving https://github.com/IBM-Swift/Swift-cfenv.git at 4.1.0
          Cloning https://github.com/IBM-Swift/Kitura-net.git
          Resolving https://github.com/IBM-Swift/Kitura-net.git at 2.1.1
          Cloning https://github.com/IBM-Swift/BlueSignals.git
          Resolving https://github.com/IBM-Swift/BlueSignals.git at 1.0.6
          Cloning https://github.com/IBM-Swift/Configuration.git
          Resolving https://github.com/IBM-Swift/Configuration.git at 1.0.4
   -----> Additional packages to download: openssl libssl-dev
   -----> openssl is already installed.
   -----> libssl-dev is already installed.
   -----> No additional packages to download.
   -----> Skipping installation of App Management (debug)
   -----> Installing system level dependencies...
   -----> Building Package...
   -----> Build config: release
          Compile CHTTPParser utils.c
          Compile CHTTPParser http_parser.c
          Compile Swift Module 'TypeDecoder' (2 sources)
          Compile Swift Module 'SwiftyJSON' (2 sources)
          Compile Swift Module 'Socket' (3 sources)
          Compile Swift Module 'Signals' (1 sources)
          Compile Swift Module 'LoggerAPI' (1 sources)
          Compile Swift Module 'KituraTemplateEngine' (1 sources)
          Compile Swift Module 'KituraContracts' (7 sources)
          Compile Swift Module 'HeliumLogger' (2 sources)
          Compile Swift Module 'Configuration' (6 sources)
          Compile Swift Module 'SSLService' (1 sources)
          Compile Swift Module 'CloudFoundryEnv' (6 sources)
          Compile Swift Module 'KituraNet' (36 sources)
          /tmp/app/.build/checkouts/Swift-cfenv.git-4127388009702411260/Sources/CloudFoundryEnv/AppEnv.swift:187:103: warning: 'characters' is deprecated: Please use String or Substring directly
                  let numberOfMatches = regex.numberOfMatches(in: name, options: [], range: NSMakeRange(0, name.characters.count))
                                                                                                                ^
          Compile Swift Module 'CloudFoundryConfig' (2 sources)
          /tmp/app/.build/checkouts/CloudConfiguration.git--2322634896900815434/Sources/CloudFoundryConfig/Services.swift:232:51: warning: 'characters' is deprecated: Please use String or Substring directly
                  guard let stringURL = uriValue, stringURL.characters.count > 0,
                                                            ^
          Compile Swift Module 'Kitura' (51 sources)
          Compile Swift Module 'HackernewsNLU' (3 sources)
          Linking ./.build/x86_64-unknown-linux/release/HackernewsNLU
   -----> Bin path: /tmp/app/.build/x86_64-unknown-linux/release
   -----> Copying dynamic libraries
   -----> Copying binaries to 'bin'
   -----> Clearing previous swift cache
   -----> Saving cache (default):
   -----> - .build
   -----> Optimizing contents of cache folder...
   No start command specified by buildpack or via Procfile.
   App will not start unless a command is provided at runtime.
   Exit status 0
   Staging complete
   Uploading droplet, build artifacts cache...
   Uploading build artifacts cache...
   Uploading droplet...
   Uploaded build artifacts cache (42.1M)
   Uploaded droplet (189.1M)
   Uploading complete
   Stopping instance 9a4fd0aa-9dec-40b5-b7c6-1c708c6804a0
   Destroying container
   Successfully destroyed container

Waiting for app to start...

name:              HackernewsNLU
requested state:   started
instances:         1/1
usage:             256M x 1 instances
routes:            hackernewsnlu-rested-aligator.mybluemix.net
last uploaded:     Wed 08 Aug 17:30:12 EDT 2018
stack:             cflinuxfs2
buildpack:         swift_buildpack
start command:     HackernewsNLU

     state     since                  cpu    memory         disk           details
#0   running   2018-08-08T21:37:31Z   7.9%   5.4M of 256M   550.3M of 1G   
```

Once the application is running on IBM Cloud, you can access your application assigned URL (i.e. route). To find the route, you can log on to your [IBM Cloud account](https://console.ng.bluemix.net), or you can inspect the output from the execution of the `bx app push` or `bx app show` commands. The string value shown next to the `urls` field contains the assigned route.  Use that route as the URL to access the sample server using the browser of your choice.

```bash
$ bx app show HackernewsNLU
Invoking 'cf app HackernewsNLU'...

Showing health and status for app HackernewsNLU in org stevemar@ca.ibm.com / space dev as stevemar@ca.ibm.com...

name:              HackernewsNLU
requested state:   started
instances:         1/1
usage:             256M x 1 instances
routes:            hackernewsnlu-rested-aligator.mybluemix.net
last uploaded:     Wed 08 Aug 17:30:12 EDT 2018
stack:             cflinuxfs2
buildpack:         swift_buildpack

     state     since                  cpu    memory       disk           details
#0   running   2018-08-08T21:37:31Z   0.1%   7M of 256M   550.3M of 1G   
```

## Sample Output

By navigating to the running app you should see a web application that retrieves articles from HackerNews. Clicking on a specific article will generate a report that analyzes that article, showing concepts, categories, entities, keywords and other interesting concepts that were extracted from Watson's Natural Language Understanding APIs.

> List of HackerNews articles

![](images/hn-articles.png)

> Individual analysis of a HackerNews artcile by Watson NLU

![](images/nlu-info.png)

## Building the project locally

1. Clone the project

```
git clone https://github.com/IBM/Hackernews-NLU
```

2. Build with the swift command line and launch with XCode

```
swift package generate-xcodeproj
open HackernewsNLU.xcodeproj
```

### Troubleshooting

Can't build the project? Check that your Swift version is up to date:

```
$ swift package tools-version
3.1.0
$ swift package tools-version --set-current
$ swift package tools-version
4.1.0
```

# Learn more

* **Artificial Intelligence Patterns:** Enjoyed this Pattern? Check out our other [AI Patterns](https://developer.ibm.com/code/technologies/artificial-intelligence/).
* **AI and Data Pattern Playlist:** Bookmark our [playlist](https://www.youtube.com/playlist?list=PLzUbsvIyrNfknNewObx5N7uGZ5FKH0Fde) with all of our Pattern videos
* **With Watson:** Want to take your Watson app to the next level? Looking to utilize Watson Brand assets? [Join the With Watson program](https://www.ibm.com/watson/with-watson/) to leverage exclusive brand, marketing, and tech resources to amplify and accelerate your Watson embedded commercial solution.

# License
[Apache 2.0](LICENSE)
