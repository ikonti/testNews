//
//  News.swift
//  testNews
//
//  Created by Kanat Kuanyshbek on 9/13/19.
//  Copyright © 2019 Kanat Kuanyshbek. All rights reserved.
//

import Foundation

struct Articles: Decodable {
    var articles: [ArticlesDetail]
}

struct ArticlesDetail: Decodable {
    var source: SourceName
    var title: String
    var content: String
    var urlToImage: String
}

struct SourceName: Decodable {
    var name: String
}
