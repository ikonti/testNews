//
//  NewsRequest.swift
//  testNews
//
//  Created by Kanat Kuanyshbek on 9/13/19.
//  Copyright © 2019 Kanat Kuanyshbek. All rights reserved.
//

import Foundation

enum NewsError: Error {
    case noDataAvaiable
    case canNotProccesData
}

struct NewsRequest {
    let resourceURL: URL
    
    init(apiKey: String) {
        
        let resourceString = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=\(apiKey)"
        
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        
        self.resourceURL = resourceURL
    }
    
    func getNews (completion: @escaping(Result<[ArticlesDetail], NewsError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, _, _) in
            guard let jsonData = data else {
                completion(.failure(.noDataAvaiable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let newsArticles = try decoder.decode(Articles.self, from: jsonData)
                let articlesDetails = newsArticles.articles
                completion(.success(articlesDetails))
                print("success") // check
            } catch {
                print("error") // check
                completion(.failure(.canNotProccesData))
            }
        }
        dataTask.resume()
    }
}
