//
//  ResultTableView.swift
//  URLHomeWorkWithAnimation
//
//  Created by Сергей Косилов on 17.08.2019.
//  Copyright © 2019 Сергей Косилов. All rights reserved.
//

import UIKit

class ResultTableView: UITableViewController {

    //MARK: - Outlets
    @IBOutlet weak var searchBarTrack: UISearchBar!
    
   
    //MARK: - Properties
    var searchResults: [Track] = []
   typealias JSONDictionary = [String: Any]
    
    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
    
   
    
    override func viewDidLoad() {
        
    }
    
    //MARK: - TableViews
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellTrack") as! CellTrack
        let track = searchResults[indexPath.row]
        cell.delegate = self
        cell.configureCell(track: track)
       
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let degree : Double = 90
        let rotationAngle = CGFloat(degree * M_PI / 100)
        let transformTranslation = CATransform3DTranslate(CATransform3DIdentity, -500, 400, 0)
        if indexPath.row % 3 == 0 {
            let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
            cell.layer.transform = rotationTransform
            UIView.animate(withDuration: 2, delay: 0.2 * Double(indexPath.row), options: .curveEaseInOut, animations: {
                cell.layer.transform = CATransform3DIdentity
            })        }else{
            if indexPath.row % 3 == 1{
            let rotationTransform = CATransform3DMakeRotation(rotationAngle, 0, 1, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 2, delay: 0.2 * Double(indexPath.row), options: .curveEaseInOut, animations: {
            cell.layer.transform = CATransform3DIdentity
        })} else {
                if indexPath.row % 3 == 2{
                
                    cell.layer.transform = transformTranslation
                    UIView.animate(withDuration: 2, delay: 0.2 * Double(indexPath.row), options: .curveEaseInOut, animations: {
                        cell.layer.transform = CATransform3DIdentity })
                    
                }
            }}}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //When user taps cell, play the local file, if it's downloaded.
        
        let track = searchResults[indexPath.row]
        
        if track.downloaded {
           
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateSearchResults(_ data: Data) {
        searchResults.removeAll()
        var response: JSONDictionary?
       
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            print("response")
        } catch let parseError as NSError {
            print( "JSONSerialization error: \(parseError.localizedDescription)\n")
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
           print("Dictionary does not contain results key\n")
            return
        }
        
        var index = 0
        
        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary,
                let previewURLString = trackDictionary["previewUrl"] as? String,
                let previewURL = URL(string: previewURLString),
                let name = trackDictionary["trackName"] as? String,
                let artist = trackDictionary["artistName"] as? String {
                searchResults.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
                index += 1
                print("array of track \(searchResults.count)")
            } else {
                print( "Problem parsing trackDictionary\n")
            }
        }
    }
}





extension ResultTableView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("touch searchBar")
                guard let searchText = searchBar.text, !searchText.isEmpty else { return }
                if var urlComponents = URLComponents(string: "https://itunes.apple.com/search"){
                    urlComponents.query = "media=music&entity=song&term=\(searchText)"
        
                    guard let url = urlComponents.url else{ return }
                    let session = URLSession.shared
                    
                    let task = session.dataTask(with: url) { data, response, error in
                        if let error = error {
                            print("DataTask error: " + error.localizedDescription + "\n")
                        }else{
                        guard let data = data else {
                            print(#function,#line, error?.localizedDescription ?? "no description")
                            return
                        }
                        if let error = error {
                           print(error.localizedDescription)
                        } else if let response = response as? HTTPURLResponse,
                            response.statusCode == 200 {
                            self.updateSearchResults(data)
                            DispatchQueue.main.async {
                              self.tableView.reloadData()
                            }
                            
                            print(data)
                    }
                        }
                    }
                    task.resume()
        
                
                    
        }
    }
   
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
}
extension ResultTableView: TrackCellDelegate {
    func cancelTapped(_ cell: CellTrack) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
           
            reload(indexPath.row)
        }
    }
    
    func downloadTapped(_ cell: CellTrack) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
          
            reload(indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: CellTrack) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
         
            reload(indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: CellTrack) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
           
            reload(indexPath.row)
        }
    }
}
