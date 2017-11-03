import Foundation
import Kitura
import HeliumLogger
import MetricsTrackerClient
// Initialize HeliumLogger
import LoggerAPI
HeliumLogger.use(LoggerMessageType.info)

let hostname = "hacker-news.firebaseio.com"
var nluCreds: [String:String]
do {
	MetricsTrackerClient(repository: "Hackernews-NLU", organization: "IBM").track()
    let controller = try Controller(hostname:hostname)
    controller.initData(requestUrlPath: "/v0/topstories.json") {
        print("Successfully loaded data !!")
    }
    Kitura.addHTTPServer(onPort: controller.port, with: controller.router)
    Kitura.run()
} catch {
    Log.error("Oops... something went wrong. Server did not start!")
}
