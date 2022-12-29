//
//  ViewController.swift
//  WeatherApp(Resit)
//
//  Created by tuan.nguyen on 4/5/22.
//

import UIKit



class ViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    
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
        //Cái này là hàm call api nè muốn gắn chỗ nào thì để vô
        viewModel.fetchData(query: text, success: { [weak self] dataSearch in
            //Cái đata call api trả về nè. cần làm gì với nó thì làm trong này.
            guard let self = self else { return }
            self.data.removeAll()
            for result in dataSearch.data.result {
                var string = ""
                if let areaName = result.areaName.first?.value, !areaName.isEmpty {
                    string += areaName
                }
                if let country = result.country.first?.value, !country.isEmpty {
                    string += ", "  + country
                }
                if let region = result.region.first?.value, !region.isEmpty {
                    string += ", "  + region
                }
                if !string.isEmpty {
                    self.data.append(string)
                }
            }
            self.tableView.reloadData()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    
}
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count

    }
}


