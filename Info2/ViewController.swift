//
//  ViewController.swift
//  Info2
//
//  Created by Finn Gaida on 17.11.17.
//  Copyright © 2017 Finn Gaida. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class Cell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
}

class ViewController: UITableViewController {

    var spinner: UIActivityIndicatorView?

    var pairs: [(title: String, url: URL)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner?.center = self.view.center
        self.view.addSubview(spinner!)
        spinner?.startAnimating()
    }

    override func viewDidAppear(_ animated: Bool) {
        do {
            pairs = try WebHelper.videoTuples()
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
            self.tableView.reloadData()
        } catch let e {
            print(e)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeue = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let cell = dequeue as? Cell else { return dequeue }
        cell.title.text = pairs[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let controller = AVPlayerViewController()
        controller.player = AVPlayer(url: pairs[indexPath.row].url)
        self.present(controller, animated: true) {
            controller.player?.play()
        }
    }

}

