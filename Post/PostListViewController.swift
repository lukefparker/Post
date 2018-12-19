//
//  PostListViewController.swift
//  Post
//
//  Created by luke parker on 12/17/18.
//  Copyright © 2018 luke parker. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postController.fetchPosts {
            self.reloadTableView()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 45
        tableView.refreshControl = refreshControl
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
    var postController = PostController()
    var refreshControl: UIRefreshControl?
    @objc func refreshControlPulled() {
        refreshControl?.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.username
        cell.detailTextLabel?.text = post.date
        return cell
        
    }
    
    func presentNewPostAlert() {
        
        
        let alertController = UIAlertController(title: "Add Your Message", message: "", preferredStyle: .alert)
        
        var usernameTextField = UITextField()
        alertController.addTextField { (usernameTF) in
            usernameTF.placeholder = "Enter username..."
            usernameTextField = usernameTF
            
        }
        
        var messageTextField = UITextField()
        alertController.addTextField { (messageTF)   in
            messageTF.placeholder = "Enter message..."
            messageTextField = messageTF
        }
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (postAction) in
            guard let username = usernameTextField.text, !username.isEmpty,
                let text = messageTextField.text, !text.isEmpty else {
                    return
            }
            
            self.postController.addNewPostWith(username: username, text: text, completion: {
                self.reloadTableView()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(postAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            
        }
    }
}
extension PostListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= postController.posts.count - 1 {
            postController.fetchPosts (reset: false) {
                self.reloadTableView()
            }
        }
    }
}




/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


