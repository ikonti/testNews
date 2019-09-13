//
//  NewsViewController.swift
//  testNews
//
//  Created by Kanat Kuanyshbek on 9/13/19.
//  Copyright © 2019 Kanat Kuanyshbek. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsName: UILabel!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentNews: ArticlesDetail!
    
    private var imageURL: URL?
    private var image: UIImage? {
        get {
            return newsImage.image
        }
        set {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            newsImage.image = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        setupEditScreen()
    }
    
    func load(news: ArticlesDetail?) {
        guard let news = news else { return }
        currentNews = news
    }
    
    private func setupEditScreen() {
        if currentNews != nil {
            newsName.text = currentNews.source.name
            newsText.text = currentNews.content
            
            imageURL = URL(string: currentNews.urlToImage)
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            let queue = DispatchQueue.global(qos: .utility)
            queue.async {
                guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}
