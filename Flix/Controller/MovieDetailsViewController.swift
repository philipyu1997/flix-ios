//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Philip Yu on 2/11/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    // MARK: - Properties
    var movie: [String: Any]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchMovieDetails()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let movieTrailerViewController = segue.destination as? MovieTrailerViewController else {
            fatalError("Failed to set segue destination as MovieTrailerViewController")
        }
        
        if let movieId = movie["id"] as? Int {
            movieTrailerViewController.movieId = movieId
        }
        
    }
    
    // MARK: - Private Function Section
    
    private func fetchMovieDetails() {
        
        guard let posterPath = movie["poster_path"] as? String else {
            fatalError("Failed to get movie poster.")
        }
        guard let backdropPath = movie["backdrop_path"] as? String else {
            fatalError("Failed to get movie backdrop.")
        }
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterUrl = URL(string: baseUrl + posterPath)
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        posterView.af.setImage(withURL: posterUrl!)
        backdropView.af.setImage(withURL: backdropUrl!)
        
    }
    
}
