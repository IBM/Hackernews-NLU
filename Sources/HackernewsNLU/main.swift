import Foundation
import Kitura
import HeliumLogger
import LoggerAPI

print("starting")

// Initialize HeliumLogger
HeliumLogger.use(LoggerMessageType.info)

let hostname = "hacker-news.firebaseio.com"
var nluCreds: [String: String]
do {
    let controller = try Controller(hostname: hostname)
    Kitura.addHTTPServer(onPort: controller.port, with: controller.router)
    Kitura.run()
} catch {
    Log.error("Oops... something went wrong. Server did not start!")
}
