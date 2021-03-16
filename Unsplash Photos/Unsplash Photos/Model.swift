//
//  Model.swift
//  Unsplash Photos
//
//  Created by Macbook Pro on 15.03.2021.
//

import Foundation

struct Photo: Identifiable, Decodable {
    let id: String
    let alt_description: String?
    let urls: [String: String]
}

struct SearchPhoto: Decodable {
    var results: [Photo]
}



class UnsplashData: ObservableObject {
    @Published var photoArray: [Photo] = []

    init() {
        loadData()
    }
    
    func loadData() {
        let key = "4c9fbfbbd92c17a2e95081cec370b4511659666240eb4db9416c40c641ee843b"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
            guard let data = data else {
                print("URLSession data task error: ", error ?? "nil")
                return
            }
            do {
                let json = try JSONDecoder().decode([Photo].self, from: data)
                
                for photo in json {
                    DispatchQueue.main.async {
                        self.photoArray.append(photo)
                    }
                }
            } catch{
                print("Error::", error.localizedDescription)
            }
        }.resume()

    }
    
    func searchData(url: String) {
//        let key = "cYCglVmJb7SypYTm2p8kk9e8BUnXmVcG1rHbodCBDIs"
//        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
//
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, error) in
            guard let data = data else {
                print("URLSession data task error: ", error ?? "nil")
                return
            }
            do {
                let json = try JSONDecoder().decode(SearchPhoto.self, from: data)
                
                for photo in json.results {
                    DispatchQueue.main.async {
                        self.photoArray.append(photo)
                    }
                }
            } catch{
                print("Error::", error.localizedDescription)
            }
        }.resume()

    }
}
