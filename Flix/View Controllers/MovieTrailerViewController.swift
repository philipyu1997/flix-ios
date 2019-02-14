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
    
    @IBOutlet weak var movieWebView: WKWebView!
    var movieId = Int()
    var movies = [[String:Any]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let ytBaseUrl = "https://www.youtube.com/watch?v="
        let ytAutoplay = "&t=1s&autoplay=1"
        
        let apiKey = "***REMOVED***"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(apiKey)&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                let movie = self.movies[0]
                let ytKey = movie["key"] as! String
                let ytTrailerUrl = URL(string: ytBaseUrl + ytKey + ytAutoplay)
                let ytTrailerRequest = URLRequest(url: ytTrailerUrl!)
                self.movieWebView.load(ytTrailerRequest)
            }
        }
        
        task.resume()

    } // end viewDidLoad function
    
    @IBAction func dismissModal(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    } // end dismissModal function
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
} // end MovieTrailerViewController class
