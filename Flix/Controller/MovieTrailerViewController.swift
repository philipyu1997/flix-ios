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
    
    // Outlets
    @IBOutlet weak var movieWebView: WKWebView!
    
    // Properties
    private let API_KEY = fetchFromPlist(forResource: "ApiKeys", forKey: "API_KEY")
    private let YT_BASE_URL = "https://www.youtube.com/watch?v="
    private let YT_AUTOPLAY = "&t=1s&autoplay=1"
    private var url: URL {
        guard let apiKey = API_KEY else {
            fatalError("Error fetching API Key. Make sure you have the correct key name")
        }
        
        return URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)&language=en-US")!
    }
    private var movies = [[String: Any]]()
    var movieId = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchMovieTrailerData()
        
    }
    
    func fetchMovieTrailerData() {
        
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
                let ytTrailerUrl = URL(string: self.YT_BASE_URL + YT_KEY + self.YT_AUTOPLAY)
                let ytTrailerRequest = URLRequest(url: ytTrailerUrl!)
                self.movieWebView.load(ytTrailerRequest)
            }
        }
        
        task.resume()
        
    }
    
    @IBAction func dismissModal(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
