//
//  MainViewController.swift
//  testNews
//
//  Created by Kanat Kuanyshbek on 9/13/19.
//  Copyright © 2019 Kanat Kuanyshbek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let apiKey = "d6c32acef52b43f39bd80646f46cfb75"
    
    var listOfNews = [ArticlesDetail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
//    MARK: RefreshControl
    var refreshControl: UIRefreshControl = { return UIRefreshControl() }()
    
    var newsList: ArticlesDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        // Load news
        loadNews()
        
        // Setup Pull to Refresh
        setupPullToRefresh()
    }
    
    // MARK: LoadNews
    
    func loadNews() {
        let newsRequest = NewsRequest(apiKey: self.apiKey)
        newsRequest.getNews { [weak self] result in
            switch result {
            case .failure(let error): print(error)
            case .success(let news): self?.listOfNews = news
            }
        }
    }
    
    // MARK: Refresh
    
    func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: UIColor.lightGray])
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .lightGray
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: AnyObject) {
        // Clear news
        listOfNews = []
        // Pull to Refresh
        loadNews()
        // Wait 2 seconds then refresh screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.refreshControl.endRefreshing()
                self.view.setNeedsDisplay()
            }
    }
}

extension MainViewController: UITableViewDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        title = "News"
        guard segue.identifier == "showNews", let newsVC = segue.destination as? NewsViewController else { return }
        
        if let indexPath = (sender as? IndexPath) {
            newsList = listOfNews[indexPath.row]
        }
        
        newsVC.load(news: newsList)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showNews", sender: indexPath)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let news = listOfNews[indexPath.row]
        
        cell.nameLabel.text = news.source.name
        cell.newsTextLabel.text = news.title
        
        cell.imageURL = URL(string: news.urlToImage)
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            guard let url = cell.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                cell.imageTo = UIImage(data: imageData)
            }
        }
        return cell
    }
}
