// swift-tools-version:4.1
/**
* Copyright IBM Corporation 2016, 2017
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
**/

// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HackernewsNLU",
    products: [
      .executable(
        name: "HackernewsNLU",
        targets:  ["HackernewsNLU"]
      )
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.4.1")),
        .package(url: "https://github.com/IBM-Swift/Kitura-net.git", .upToNextMinor(from: "2.1.1")),
        .package(url: "https://github.com/IBM-Swift/LoggerAPI.git", .upToNextMinor(from: "1.7.0")),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMinor(from: "1.7.0")),
        .package(url: "https://github.com/IBM-Swift/CloudConfiguration.git", .upToNextMinor(from: "2.0.0")),
        .package(url: "https://github.com/IBM-Swift/Configuration.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", .upToNextMinor(from: "17.0.0")),
        .package(url: "https://github.com/watson-developer-cloud/swift-sdk", from: "0.31.0")
    ],
    targets: [
      .target(name: "HackernewsNLU", dependencies: ["Kitura", "KituraNet", "LoggerAPI", "HeliumLogger", "CloudConfiguration", "Configuration", "SwiftyJSON", "NaturalLanguageUnderstandingV1"]),
    ]
)

