//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Philip Yu on 2/11/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movie: [String:Any]!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print(movie["title"])

        // Do any additional setup after loading the view.
        
    } // end viewDidLoad function
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} // end MovieDetailsViewController class
