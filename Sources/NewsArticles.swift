//
//  NewsArticles.swift
//  HackerNewsNLU
//
//  Created by Ishan Gulhane on 6/8/17.
//
//
struct NewsArticles{
    fileprivate var title: String
    fileprivate var id: Int
    fileprivate var link: String

    init(newsID id:Int,newsTitle title:String,newsLink link:String) {
        self.id=id
        self.title=title
        self.link=link
    }

    func getID() -> Int {
        return self.id
    }

    func getTitle() -> String {
        return self.title
    }

    func getLink() -> String {
        return self.link
    }

}
