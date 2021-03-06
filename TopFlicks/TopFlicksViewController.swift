//
//  TopFlicksViewController.swift
//  TopFlicks
//
//  Created by Abby Juan on 1/10/16.
//  Copyright © 2016 ZhanLiang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class TopFlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    
   
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var filteredData:[NSDictionary]!
    var endpoint: String!
    
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "Movies"
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named: "movie_icon"), forBarMetrics: .Default)
            navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.8)
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            shadow.shadowOffset = CGSizeMake(2, 2);
            shadow.shadowBlurRadius = 4;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(22),
                NSForegroundColorAttributeName : UIColor(red: 0.15, green: 0.15, blue: 0.8, alpha: 0.8),
                NSShadowAttributeName : shadow
            ]
        }
        
        
        
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense.  Should set probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        
        
        
        

        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                
                // Display HUD right before next request is made
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                
                // ...
                
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.filteredData = self.movies
                            self.tableView.reloadData()
       
                            
                            
                            
                            
                            
                            
                    }
                }
        });
        task.resume()
        
        
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
   
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // Make network request to fetch latest data
        
        // Do the following when the network request comes back successfully:
        // Update tableView data source
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    } 
    
   
    
   
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.movie = movie
        
        
        
        
        
        
        print("prepare for segue called")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
   
    
    
    
    
    
    
    
    
    
    }
    
  
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
    
        
        
        if let movies = filteredData {
            return movies.count
        } else {
            return 0
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        
let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath)as! MovieCell

// No color when the user selects cell
cell.selectionStyle = .Gray
// Use a red color when the user selects the cell
let backgroundView = UIView()
backgroundView.backgroundColor = UIColor.redColor()
cell.selectedBackgroundView = backgroundView
        

        
        
let movie = filteredData![indexPath.row]
        
        
        
        
        

let title = movie["title"] as! String
let overview = movie["overview"] as! String
if let posterPath = movie["poster_path"] as? String {
        
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
            let imageUrl = NSURL(string: baseUrl + posterPath)
        
                cell.posterView.setImageWithURL(imageUrl!)
    
    let largeImageUrl = NSURL(string: "https://image.tmdb.org/t/p/original" + posterPath)
    let smallImageUrl = NSURL(string:"https://image.tmdb.org/t/p/w45" + posterPath)
    let smallImageRequest = NSURLRequest(URL:(string: smallImageUrl!))
    let largeImageRequest = NSURLRequest(URL:(string: largeImageUrl!))
    
    cell.posterView.setImageWithURLRequest(
        smallImageRequest,
        placeholderImage: nil,
        success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
            
            // smallImageResponse will be nil if the smallImage is already available
            // in cache (might want to do something smarter in that case).
            cell.posterView.alpha = 0.0
            cell.posterView.image = smallImage;
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                cell.posterView.alpha = 1.0
                
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    cell.posterView.setImageWithURLRequest(
                        largeImageRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            cell.posterView.image = largeImage;
                            
                        },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
            })
        },
        failure: { (request, response, error) -> Void in
            // do something for the failure condition
            // possibly try to get the large image
    })
    
    
}
        

        cell.titleLabel.text = title
        
        cell.overviewLabel.text = overview
       
        print("row \(indexPath.row)")
        
        
    
        
        
        
        return cell
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
                let title = movie["title"]as! String
                
                
                return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            })
            
            tableView.reloadData()
        }
    }
    
    
    
    
    
    
    
    
}


















    // MARK: - Navigation
    // In a storyboard-based application, you will       often want to do a little preparation before navigation





