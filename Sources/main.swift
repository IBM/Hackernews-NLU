import Foundation
import Kitura
import HeliumLogger
// Initialize HeliumLogger
import LoggerAPI
HeliumLogger.use(LoggerMessageType.info)

let hostname = "hacker-news.firebaseio.com"
var nluCreds: [String:String]
do {
    let controller = try Controller(hostname:hostname)
    controller.initData(requestUrlPath: "/v0/topstories.json") {
        print("Successfully loaded data !!")
    }
    Kitura.addHTTPServer(onPort: controller.port, with: controller.router)
    Kitura.run()
} catch {
    Log.error("Oops... something went wrong. Server did not start!")
}
