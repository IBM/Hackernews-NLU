//
//  Controller.swift
//  HackerNewsNLU
//
//  Created by Ishan Gulhane on 6/8/17.
//
//

import Foundation
import Kitura
import SwiftyJSON
import KituraNet
import HeliumLogger
import LoggerAPI
import Configuration
import CloudFoundryConfig

public class Controller {
    let router: Router
    private var configMgr: ConfigurationManager
    private let nluServiceName = "Hackernews-NLU"
    var articlesDict = [Int:NewsArticles]()
    var articlesList = [NewsArticles]()
    var hostname : String
    var port: Int {
        get { return configMgr.port }
    }

    init(hostname: String) throws {
        self.hostname = hostname
        router = Router()
        // Get environment variables from config.json or environment variables
        let configFile = URL(fileURLWithPath: #file).appendingPathComponent("../cloud_config.json").standardized
        configMgr = ConfigurationManager()
        configMgr.load(url: configFile).load(.environmentVariables)
        nluCreds = [String:String]()
        nluCreds = initService(serviceName: nluServiceName)
        router.all("/", middleware: BodyParser())
        router.all("/", middleware: StaticFileServer())
        router.get("/analyse", handler: self.analyse)
        router.get("/update", handler: self.updateData)
    }

    func initData(requestUrlPath url: String,next: @escaping() -> Void) -> Void {
        self.articlesList = [NewsArticles]()
        self.callApi(requestUrlPath: url, success: { (data) in
             let json = try? JSONSerialization.jsonObject(with: data, options: [])
             if let array = json as? [Any] {
                let totalCount = array.count
                var currentCount = 0
                for object in array {
                    if object is Int{
                        let articleId = Int(String(describing: object))
                        if let news = self.articlesDict[articleId!]{
                            self.articlesList.append(news)
                            if(self.updateCount(totalCount: totalCount, currentCount: &currentCount)){
                                next()
                            }
                        } else
                        {
                            let itemURL = "/v0/item/"+String(describing: object)+".json"
                            self.callApi(requestUrlPath: itemURL, success: { (data) in
                                let json = JSON(data: data)
                                // need to handle for story and comment type
                                if let title =  json["title"].string, let link = json["url"].string, let id = json["id"].int{
                                    let news = NewsArticles(newsID :id,newsTitle:title,newsLink:link)
                                    self.articlesList.append(news)
                                    self.articlesDict[id]=news
                                }
                                if(self.updateCount(totalCount: totalCount, currentCount: &currentCount)){
                                    next()
                                }
                            }, failure: { (error) in
                                print(error)
                            })
                        }
                    }else{
                        currentCount+=1
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }

    func updateCount(totalCount:Int, currentCount: inout Int) -> Bool{
        currentCount+=1
        return currentCount==totalCount
    }

    func updateData(request: RouterRequest, response: RouterResponse, next: @escaping() -> Void) throws  {
        print("Received request for Data")
        guard let path = request.queryParameters["path"] else{
            do {
                try response.status(.badRequest).send("Invalid value for Path").end()
            } catch {
                Log.error("Error responding with news articles")
            }
            Log.error("Invalid value for Path")
            return
        }
        self.initData(requestUrlPath: path) {
            var newsArticles=[JSON]()
            for val in self.articlesList{
                let articleJSON = JSON(["id":val.getID(),"title":val.getTitle()])
                newsArticles.append(articleJSON)
            }
            do {
                try response.status(.OK).send(JSON(newsArticles).rawString() ?? "").end()
            } catch {
                Log.error("Error responding with news articles")
            }
        }
    }

    func callApi(requestUrlPath url: String,success: @escaping (Data)->(), failure: @escaping (String) -> Void) -> Void {
        /*let apiUrl = URL(string: self.hostname+url)
        let task = URLSession.shared.dataTask(with: apiUrl!) { data, response, error in
            guard error == nil else {
                return failure(error!.localizedDescription)
            }
            guard let data = data else {
                return failure("Data is empty")
            }
            return success(data)
        }
        task.resume()*/
       // let path = "/natural-language-understanding/api/v1/analyze?version=2017-02-27"
        var requestOptions: [ClientRequest.Options] = []
        var headers = [String:String]()
        headers["Content-Type"] = "application/json"
        requestOptions.append(.method("GET"))
        requestOptions.append(.schema("https://"))
        requestOptions.append(.hostname(self.hostname))
        requestOptions.append(.path(url))
        requestOptions.append(.headers(headers))
        let req = HTTP.request(requestOptions) { resp in
            if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
                do {
                    var body = Data()
                    try resp.readAllData(into: &body)
                    success(body)
                } catch {
                    //bad JSON data
                    failure("failed to parse review JSON correctly")
                }
            } else {
                if let resp = resp {
                    //request failed
                    failure("Request failed with status code: \(resp.statusCode)")

                }
            }
        }
        req.end()

    }

    func analyse(request: RouterRequest, response: RouterResponse, next: @escaping() -> Void) throws  {
        guard let articleid = Int(request.queryParameters["articleid"]!),let article = self.articlesDict[articleid] else {
            do {
                try response.status(.badRequest).send("Invalid value for Articleid").end()
            } catch {
                Log.error("Error responding with news articles")
            }
            Log.error("Invalid value for Articleid")
            return
        }
        print("Received request for article :"+request.queryParameters["articleid"]!)
        response.headers["Content-type"] = "application/json"
        callNLUApi(newsArticle: article, completion: { (data) in
            do {
                try response.status(.OK).send(data.rawString() ?? "").end()
            } catch {
                Log.error("Error responding with news articles")
            }
        }) { (error) in
            do {
                print(error)
                try response.status(.badRequest).send("").end()
            } catch {
                Log.error("Error responding with news articles")
            }
        }
    }

    /// Call Watson NLU API for analysing the Article URL
    ///
    /// - parameter completion: Completion closure invoked on success
    /// - parameter failure:    Failure closure invoked on error
    func callNLUApi(newsArticle article: NewsArticles,completion: @escaping (JSON)->(), failure: @escaping (String) -> Void) -> Void {
        let path = "/natural-language-understanding/api/v1/analyze?version=2017-02-27"
        guard let username = nluCreds["username"] else {
            failure("No username for NLU service")
            return
        }
        guard let password = nluCreds["password"] else {
            failure("No password for NLU service")
            return
        }
        var requestOptions: [ClientRequest.Options] = []
        var headers = [String:String]()
        let theBody: JSON = [
            "url": article.getLink(),
            "features":[
                "concepts":   [ "limit":10],
                "categories":  [ "limit":10],
                "emotion":  [ "limit":10],
                "entities":  [ "limit":10],
                "sentiment":  [ "limit":10],
                "keywords":  [ "limit":10]
            ]
        ]
        var theData = Data()
        do {
            try theData = theBody.rawData(options: JSONSerialization.WritingOptions())
        }
        catch {
            print("error")
        }
        headers["Content-Type"] = "application/json"
        requestOptions.append(.method("POST"))
        requestOptions.append(.schema("https://"))
        requestOptions.append(.hostname("gateway.watsonplatform.net"))
        requestOptions.append(.path(path))
        requestOptions.append(.username(username))
        requestOptions.append(.password(password))
        requestOptions.append(.headers(headers))
        let req = HTTP.request(requestOptions) { resp in
            if let resp = resp, resp.statusCode == HTTPStatusCode.OK {
                do {
                    var body = Data()
                    try resp.readAllData(into: &body)
                    let response = JSON(data: body)
                    completion(response)
                } catch {
                    //bad JSON data
                    failure("failed to parse review JSON correctly")
                }
            } else {
                if let resp = resp {
                    //request failed
                    failure("Request failed with status code: \(resp.statusCode)")

                }
            }
        }
        req.write(from: theData)
        req.end()

    }

    /// Load the service credentials
    ///
    /// - parameter serviceName: name of the service
    func initService(serviceName:String) -> [String:String] {
        //print(serviceName)
        let serv = configMgr.getService(spec: serviceName)
        var creds: [String:String] = [:]
        if let credentials = serv?.credentials {
            creds["username"] = credentials["username"] as? String
            creds["password"] = credentials["password"] as? String
            creds["version"] = "2017-03-01"
        } else {
            Log.error("no credentials available for " + serviceName)
        }
        return creds
    }

}
