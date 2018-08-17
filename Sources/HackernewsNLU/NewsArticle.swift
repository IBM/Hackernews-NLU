//
//  NewsArticles.swift
//  HackerNewsNLU
//
//  Created by Ishan Gulhane on 6/8/17.
//

import Foundation

infix operator =!=
func =!=(left: SynchronizedArray<NewsArticle>, right: Int) -> NewsArticle? {
    for article in left.array {
        if article.id == right {
            return article
        }
    }
    return nil
}

class NewsArticle {
    
    var title: String
    var id: Int
    var link: String

    init(newsID id: Int, newsTitle title: String, newsLink link: String) {
        self.id = id
        self.title = title
        self.link = link
    }

    convenience init(newsID id: Int) {
        self.init(newsID: id, newsTitle: "", newsLink: "")
    }

}
