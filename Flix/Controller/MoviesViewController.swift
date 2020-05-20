//
//  MoviesViewController.swift
//  Flix
//
//  Created by Philip Yu on 2/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let apiKey = Constant.apiKey!
    private var url: URL {
        return URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
    }
    var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set table view data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchMovieData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let cell = sender as? UITableViewCell else {
            fatalError("Failed to set sender as UITableViewCell")
        }
        guard let detailsViewController = segue.destination as? MovieDetailsViewController else {
            fatalError("Failed to set segue destination as MovieDetailsViewController")
        }
        
        // Find the selected movie
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        detailsViewController.movie = movie
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Private Function Section
    
    private func fetchMovieData() {
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, _, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    // Get the array of movies
                    // Store the movies in a property to use elsewhere
                    if let results = dataDictionary!["results"] as? [[String: Any]] {
                        self.movies = results
                    }
                } catch {
                    print(error)
                }
                
                // Reload your table view data
                self.tableView.reloadData()
            }
        }
        
        task.resume()
        
    }
    
}

// MARK: TableView Data Source and Delegate Section

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell else {
            fatalError("Failed to set cell as MovieCell")
        }
        let movie = movies[indexPath.row]
        
        if let title = movie["title"] as? String,
            let synopsis = movie["overview"] as? String,
            let posterPath = movie["poster_path"] as? String {
            
            let baseUrl = "https://image.tmdb.org/t/p/w185"
            let posterUrl = URL(string: baseUrl + posterPath)
            
            cell.titleLabel.text = title
            cell.synopsisLabel.text = synopsis
            cell.posterView.af.setImage(withURL: posterUrl!)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 167
        
    }
    
}
