//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator



//let randomMovie = allMovies[randomNumber]

class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    var allMovies: [Movie] = []
    var randomNumber = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        exerciseOne()
//        exerciseTwo()
//        exerciseThree()
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    guard let jsonURL = Bundle.main.url(forResource: "iTunes-Movies", withExtension: "json") else {
                        print("Could not find iTunes-Movies.json!")
                        return
                    }
                    let jsonData = try! Data(contentsOf: jsonURL)
                    
                    let moviesData = JSON(data: jsonData)
                    
                    let allMoviesData = moviesData["feed"]["entry"].arrayValue
                    
                    //var allMovies: [Movie] = []
                    self.allMovies.removeAll()
                    
                    for movie in allMoviesData {
                        self.allMovies.append(Movie(json: movie))
                    }

                    self.randomNumber = Int(arc4random_uniform(25))
                    
                    //let randomNumber = Int(arc4random_uniform(25))

                    let randomMovie = self.allMovies[self.randomNumber]
                    
                    self.movieTitleLabel.text = randomMovie.name
                    self.rightsOwnerLabel.text = randomMovie.rightsOwner
                    self.releaseDateLabel.text = randomMovie.releaseDate
                    self.priceLabel.text = String(randomMovie.price)
                    self.posterImageView.image = UIImage(self.loadPoster(urlString: randomMovie.poster))
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImage(withURL: URL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(_ sender: AnyObject) {
        
        
        
        UIApplication.shared.openURL(URL(string: allMovies[self.randomNumber].link)!)

    }
    
}

