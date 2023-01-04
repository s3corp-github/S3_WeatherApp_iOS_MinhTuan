//
//  ViewController.swift
//
//

import UIKit
class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    static func create() -> ViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.viewModel = HomeViewModel()
        return viewController
    }
    let searchController = UISearchController()
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    var data : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard  let text = searchController.searchBar.text else {
            return
        }
        viewModel.fetchData(query: text, success: { [weak self] dataSearch in
            self?.tableView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
}
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
        cell.textLabel?.text = viewModel.data[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
}


