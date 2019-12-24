//
//  ViewController.swift
//  DummyNetworkingProject
//
//  Created by K Y on 12/24/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

private let CELL_REUSE_ID = "REUSE_ID"

extension UIView {
    func fillIn(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        let constraints = [
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

class ViewController: UIViewController {

    lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.register(UITableViewCell.self, forCellReuseIdentifier: CELL_REUSE_ID)
        t.dataSource = self
        t.fill(self.view)
        return t
    }()
    
    let vm = NDummyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.bind { (result) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        vm.getData(from: url)
    }


}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (vm.datum) {
            case .failure:
                return 0
            case .success(let m):
                return m.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: CELL_REUSE_ID, for: indexPath)
        switch (vm.datum) {
            case .failure:
                fatalError("no data found")
            case .success(let m):
                c.textLabel?.text = m[indexPath.row].title
        }
        return c
    }
}
