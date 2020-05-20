//
//  MovieTrailerViewController.swift
//  Flix
//
//  Created by Philip Yu on 2/13/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import WebKit

class MovieTrailerViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var movieWebView: WKWebView!
    
    // MARK: - Properties
    private let apiKey = Constant.apiKey!
    private let ytBaseUrl = "https://www.youtube.com/watch?v="
    private let ytAutoplay = "&t=1s&autoplay=1"
    private var url: URL {
        return URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)&language=en-US")!
    }
    private var movies = [[String: Any]]()
    var movieId = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchMovieTrailerData()
        
    }
    
    // MARK: - IBAction Section
    
    @IBAction func dismissModal(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Private Function Section
    
    private func fetchMovieTrailerData() {
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, _, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let results = dataDictionary!["results"] as? [[String: Any]] {
                        self.movies = results
                    }
                } catch {
                    print(error)
                }
                
                let movie = self.movies[0]
                guard let YT_KEY = movie["key"] as? String else {
                    fatalError("Failed to get movie YouTube key")
                }
                let ytTrailerUrl = URL(string: self.ytBaseUrl + YT_KEY + self.ytAutoplay)
                let ytTrailerRequest = URLRequest(url: ytTrailerUrl!)
                self.movieWebView.load(ytTrailerRequest)
            }
        }
        
        task.resume()
        
    }
    
}
