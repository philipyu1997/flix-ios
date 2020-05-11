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
    
    // Properties
    var movie: [String:Any]!
    
    // Outlets
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af_setImage(withURL: posterUrl!)
        
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        
        backdropView.af_setImage(withURL: backdropUrl!)
        
    } // end viewDidLoad function
    
    @IBAction func onClick(_ sender: Any) {
        
        performSegue(withIdentifier: "firstSegue", sender: nil)
        
    } // end onClick function
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let movieTrailerViewController = segue.destination as! MovieTrailerViewController
        movieTrailerViewController.movieId = movie["id"] as! Int
        
    } // end prepare function
    
} // end MovieDetailsViewController class
