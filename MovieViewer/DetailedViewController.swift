//
//  DetailedViewController.swift
//  MovieViewer
//
//  Created by Golla, Chaitanya Teja on 4/1/17.
//  Copyright © 2017 Golla, Chaitanya Teja. All rights reserved.
//

import UIKit
import AFNetworking

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var detailedPosterView: UIImageView!
    @IBOutlet weak var detailedOverview: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var detailedScrollView: UIScrollView!
    var movieDetails: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let contentHeight = detailedScrollView.bounds.height * 2
          let contentWidth = detailedOverview.bounds.width
        detailedScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight);
        
        let posterPath = movieDetails?["poster_path"] as! String;
        let baseUrl = "http://image.tmdb.org/t/p/w500";
        let imageUrl = URL(string: baseUrl + posterPath);
        let overview = movieDetails?["overview"] as! String;
        let title = movieDetails?["title"] as! String;
        let release = movieDetails?["release_date"] as! String;
        releaseLabel.text = release
        titleLabel.text = title
        detailedOverview.text = overview
        if imageUrl != nil{
        detailedPosterView.setImageWith(imageUrl!)
        } else {
            print("Doesn’t contain a value.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
