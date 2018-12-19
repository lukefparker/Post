//
//  PostController.swift
//  Post
//
//  Created by luke parker on 12/17/18.
//  Copyright © 2018 luke parker. All rights reserved.
//

import UIKit

class PostController {
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    var posts = [Post]()
    
    func fetchPosts(reset: Bool = true, completion: @escaping () -> Void) {
        
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.queryTimeStamp ?? Date().timeIntervalSince1970
        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        
        guard let unwrappedurl = self.baseURL else { completion (); fatalError("URL optional is nil")}
        
        var urlComponents = URLComponents(url: unwrappedurl, resolvingAgainstBaseURL: true)
        
        guard let url = urlComponents?.url else {completion(); return}
        
        let getterEndpoint = url.appendingPathExtension("json")
        
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print(error)
                completion()
                return
            }
            guard let data = data else { completion(); return}
            let jsondecoder = JSONDecoder()
            
            do {
                let postDictionary = try jsondecoder.decode([String: Post].self, from: data)
                var sortedPost = postDictionary.compactMap({ $0.value })
                sortedPost.sort(by: { $0.timestamp > $1.timestamp})
                if reset {
                    self.posts = sortedPost
                } else {
                    self.posts.append(contentsOf: sortedPost)
                }
                completion()
                
                
                
            } catch {
                print("error retirieving posts from \(getterEndpoint)")
                completion()
                return
                
                
                
            }
        }
        dataTask.resume()
        
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping() -> Void) {
        
        let newPost = Post(username: username, text: text)
        var postData: Data
        do {
            let jsonEncoder = JSONEncoder()
            postData = try jsonEncoder.encode(newPost)
        } catch {
            print("Error adding new post ; (\(error.localizedDescription)")
            completion()
            return
        }
        guard let unwrappedURL = baseURL else { return }
        let postEndpoint = unwrappedURL.appendingPathExtension("json")
        
        var request = URLRequest(url: postEndpoint)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completion()
                return
            }
            guard let data = data else { completion()
                return
            }
            print(String(data: data, encoding: .utf8) ?? "There was an error")
            self.fetchPosts(completion: {
                completion()
            })
        }
        dataTask.resume()
    }
}
