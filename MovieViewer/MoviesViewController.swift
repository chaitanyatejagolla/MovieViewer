//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Golla, Chaitanya Teja on 4/1/17.
//  Copyright © 2017 Golla, Chaitanya Teja. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var basicView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    var movies: [NSDictionary]?
    var movie: NSDictionary?
    var baseUrl = "http://image.tmdb.org/t/p/w500";
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicView.addSubview(errorLabel)
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight);
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.red
        refreshControl.tintColor = UIColor.yellow
        tableView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.tableView.addSubview(self.refreshControl)
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        self.movies = (responseDictionary["results"] as! [NSDictionary]);
                        self.errorLabel.isEnabled = false
                        self.tableView.isHidden = false
                        self.errorLabel.isHidden = true
                        self.tableView.reloadData();
                        // This is where you will store the returned array of posts in your posts property
                    }
                }
                if let error = error {
                    if(error.localizedDescription .contains("The Internet connection appears to be offline.")){
                        print("Network Error")
                        self.errorLabel.text = "The Internet connection appears to be offline"
                        self.errorLabel.isHidden = false
                        self.searchBar.isHidden = true
                        self.tableView.isHidden = true
                    }
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        movie = movies?[indexPath.row];
        let title = movie?["title"] as! String;
        let overview = movie?["overview"] as! String;
        let posterPath = movie?["poster_path"] as! String;
        let imageUrl = URL(string: baseUrl + posterPath);
        cell.posterView.setImageWith(imageUrl!);
        cell.titleLabel.text = title;
        cell.overviewLabel.text = overview;
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue"
        {
            if let destinationVC = segue.destination as? DetailedViewController {
                let indexPath = tableView.indexPathForSelectedRow;
                movie = movies?[(indexPath?.row)!];
                destinationVC.movieDetails = movie
            }
        }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

