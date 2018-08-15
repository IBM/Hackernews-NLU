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
import NaturalLanguageUnderstandingV1

public class Controller {
    let router: Router
    private var configMgr: ConfigurationManager
    private let nluServiceName = "HackernewsNLU"
    var articlesDict = [Int: NewsArticles]()
    var articlesList = [NewsArticles]()
    var hostname: String
    var port: Int {
        get {
            return configMgr.port
        }
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
        router.get("/analyze", handler: self.analyze)
        router.get("/update", handler: self.updateData)
    }

    func initData(requestUrlPath url: String, next: @escaping () -> Void) {
        self.articlesList = [NewsArticles]()
        self.callApi(requestUrlPath: url, success: { (data) in
             let json = try? JSONSerialization.jsonObject(with: data, options: [])
             if let array = json as? [Any] {
                let totalCount = array.count
                var currentCount = 0
                for object in array {
                    if let articleId = Int(String(describing: object)) {
                        if let news = self.articlesDict[articleId]{
                            self.articlesList.append(news)
                            if self.updateCount(totalCount: totalCount, currentCount: &currentCount) {
                                next()
                            }
                        } else {
                            let itemURL = "/v0/item/\(String(describing: object)).json"
                            self.callApi(requestUrlPath: itemURL, success: { (data) in
                                let json = SwiftyJSON.JSON(data: data)
                                // need to handle for story and comment type
                                if let title =  json["title"].string, let link = json["url"].string, let id = json["id"].int {
                                    let news = NewsArticles(newsID: id, newsTitle: title, newsLink: link)
                                    self.articlesList.append(news)
                                    self.articlesDict[id] = news
                                }
                                if self.updateCount(totalCount: totalCount, currentCount: &currentCount) {
                                    next()
                                }
                            }, failure: { (error) in
                                print(error)
                            })
                        }
                    } else {
                        currentCount += 1
                    }
                }
            }
        }) { (error) in
            print(error)
        }
    }

    func updateCount(totalCount: Int, currentCount: inout Int) -> Bool {
        currentCount += 1
        return currentCount == totalCount
    }

    func updateData(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        print("Received request for Data")
        guard let path = request.queryParameters["path"] else {
            do {
                try response.status(.badRequest).send("Invalid value for Path").end()
            } catch {
                Log.error("Error responding with news articles")
            }
            Log.error("Invalid value for Path")
            return
        }
        self.initData(requestUrlPath: path) {
            var newsArticles = [SwiftyJSON.JSON]()
            for val in self.articlesList{
                let articleJSON = SwiftyJSON.JSON(["id":val.getID(), "title":val.getTitle()])
                newsArticles.append(articleJSON)
            }
            do {
                try response.status(.OK).send(SwiftyJSON.JSON(newsArticles).rawString() ?? "").end()
            } catch {
                Log.error("Error responding with news articles")
            }
        }
    }

    func callApi(requestUrlPath url: String, success: @escaping (Data) -> Void, failure: @escaping (String) -> Void) {
        var requestOptions = [ClientRequest.Options]()
        var headers = [String: String]()
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

    func analyze(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let articleid = Int(request.queryParameters["articleid"]), let article = self.articlesDict[articleid] else {
            do {
                try response.status(.badRequest).send("Invalid value for articleid").end()
            } catch {
                Log.error("Error responding with news articles")
            }
            Log.error("Invalid value for articleid")
            return
        }
        print("Received request for article: " + request.queryParameters["articleid"]!)
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
    func callNLUApi(newsArticle article: NewsArticles, completion: @escaping (SwiftyJSON.JSON) -> Void, failure: @escaping (String) -> Void) {
        var service: NaturalLanguageUnderstanding? = nil
        func checkValidity(username: String?, password: String?) -> Bool {
            return (!(username == nil) && !(username == (username == nil ? nil : ""))) && (!(password == nil) && !(password == (password == nil ? nil : "")))
        }
        func checkValidity(apikey: String?) -> Bool {
            return !(apikey == nil) && !(apikey == (apikey == nil ? nil : ""))
        }
        let apikeyValid = checkValidity(apikey: nluCreds["apikey"])
        let userpassValid = checkValidity(username: nluCreds["username"], password: nluCreds["password"])
        if apikeyValid && userpassValid {
            failure("You provided both a username and password, as well as an API key. Please provide only one.")
            return
        } else if !apikeyValid && !userpassValid {
            failure("You didn't provide a valid apikey OR username/password pair.")
            return
        } else if apikeyValid {
            service = NaturalLanguageUnderstanding(version: "2017-02-27", apiKey: nluCreds["apikey"]!)
        } else if userpassValid {
            service = NaturalLanguageUnderstanding(username: nluCreds["username"]!, password: nluCreds["password"]!, version: "2017-02-27")
        }
        if let service = service {
            let concepts = ConceptsOptions(limit: 10)
            let entities = EntitiesOptions(limit: 10)
            let keywords = KeywordsOptions(limit: 10)
            let features = Features(concepts: concepts, emotion: EmotionOptions(), entities: entities, keywords: keywords, sentiment: SentimentOptions(), categories: CategoriesOptions())
            let params = Parameters(features: features, url: article.getLink())
            var jsonConcepts = [[String: AnyObject]]()
            var jsonCategories = [[String: AnyObject]]()
            var jsonEmotion = [String: AnyObject]()
            var jsonSentiment = [String: AnyObject]()
            var jsonEntities = [[String: AnyObject]]()
            var jsonKeywords = [[String: AnyObject]]()
            service.analyze(parameters: params) { resp in
                for concept in resp.concepts! {
                    jsonConcepts.append(["text": concept.text! as AnyObject, "relevance": concept.relevance! as AnyObject])
                }
                for category in resp.categories! {
                    jsonCategories.append(["label": category.label! as AnyObject, "score": category.score! as AnyObject])
                }
                jsonEmotion = ["anger": resp.emotion?.document?.emotion?.anger! as AnyObject, "joy": resp.emotion?.document?.emotion?.joy! as AnyObject, "disgust": resp.emotion?.document?.emotion?.disgust! as AnyObject, "fear": resp.emotion?.document?.emotion?.fear! as AnyObject, "sadness": resp.emotion?.document?.emotion?.sadness! as AnyObject]
                jsonSentiment = ["label": resp.sentiment?.document?.label! as AnyObject, "score": resp.sentiment?.document?.score! as AnyObject]
                for entity in resp.entities! {
                    jsonEntities.append(["text": entity.text! as AnyObject, "type": entity.type! as AnyObject, "relevance": entity.relevance! as AnyObject])
                }
                for keyword in resp.keywords! {
                    jsonKeywords.append(["text": keyword.text! as AnyObject, "relevance": keyword.relevance! as AnyObject])
                }
            }
            var total_json = [String: AnyObject]()
            total_json["concepts"] = jsonConcepts as AnyObject
            total_json["categories"] = jsonCategories as AnyObject
            total_json["emotion"] = jsonEmotion as AnyObject
            total_json["sentiment"] = jsonSentiment as AnyObject
            total_json["entities"] = jsonEntities as AnyObject
            total_json["keywords"] = jsonKeywords as AnyObject
            do {
                try completion(JSON(data: JSONSerialization.data(withJSONObject: total_json, options: [])))
            } catch {
                failure("Something went wrong while parsing JSON!")
                return
            }
        } else {
            failure("Service wasn't created.")
            return
        }
        }

    /// Load the service credentials
    ///
    /// - parameter serviceName: name of the service
    func initService(serviceName: String) -> [String: String] {
        let serv = configMgr.getService(spec: serviceName)
        var creds = [String: String]()
        if let credentials = serv?.credentials {
            creds["username"] = credentials["username"] as? String
            creds["password"] = credentials["password"] as? String
            creds["apikey"] = credentials["apikey"] as? String
            creds["version"] = "2017-03-01"
        } else {
            Log.error("no credentials available for " + serviceName)
        }
        return creds
    }

}
