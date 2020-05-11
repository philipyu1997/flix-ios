//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Philip Yu on 2/11/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Properties
    private let API_KEY = fetchFromPlist(forResource: "ApiKeys", forKey: "API_KEY")
    private var url: URL {
        guard let apiKey = API_KEY else {
            fatalError("Error fetching API Key. Make sure you have the correct key name")
        }
        
        return URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=\(apiKey)&language=en-US&page=1")!
    }
    private var movies = [[String: Any]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set Collection View Data Source and Delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchMovieData()
        
    }
    
    func fetchMovieData() {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = 2
            
            let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3
            layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        }
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
                self.collectionView.reloadData()
            }
        }
        
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let cell = sender as? UICollectionViewCell else {
            fatalError("Failed to set sender as UICollectionViewCell")
        }
        guard let detailsViewController = segue.destination as? MovieDetailsViewController else {
            fatalError("Failed to set segue destination as MovieDetailsViewController")
        }
        
        // Find the selected movie
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.item]
        
        // Pass the selected movie to the details view controller
        detailsViewController.movie = movie
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}

// MARK: Collection Data Source and Delegate Section

extension MovieGridViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as? MovieGridCell else {
            fatalError("Failed to set cell as MovieGridCell")
        }
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        guard let posterPath = movie["poster_path"] as? String else {
            fatalError("Failed to get movie poster.")
        }
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
        
    }
    
}
