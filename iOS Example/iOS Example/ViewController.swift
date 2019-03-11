//
//  ViewController.swift
//  iOS Example
//
//  Created by Bryan Clark on 8/15/17.
//  Copyright © 2017 Khan Academy. All rights reserved.
//

import UIKit
import A11yAnalytics

class ViewController: UITableViewController {
    private var analyticsInfo: [String: String] = [:] {
        didSet {
            self.tableData = analyticsInfo
                .map { return ($0, $1) }
                .sorted { return $0.0 < $1.0 }
        }
    }

    private var tableData: [(String, String)] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "A11y Analytics"
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "GitHub", style: .plain, target: self, action: #selector(openGithub))

        self.tableView.register(ExampleCell.self, forCellReuseIdentifier: ExampleCell.identifier)
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        self.refreshData()
    }

	@objc fileprivate func openGithub() {
		let url = URL(string: "https://www.github.com/khan/a11yAnalytics")!
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}

	@objc fileprivate func refreshData() {
        // Ta-da! A single-line-of-code to report what a11y settings a user has enabled.
        self.analyticsInfo = AccessibilityAnalytics.currentSettings()
        GenericAnalyticsService.shared.reportEvent(named: "accessibility_settings", info: self.analyticsInfo)

        // If you want to only report a subset of the analytics, then you can pass 'em in like so:
        let fontSize = AccessibilityAnalytics.currentSettings(for: [.preferredContentSize])
        GenericAnalyticsService.shared.reportEvent(named: "accessibility_settings_font", info: fontSize)

        self.tableView.refreshControl?.endRefreshing()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExampleCell.identifier, for: indexPath)
        let cellInfo = tableData[indexPath.row]
        cell.textLabel?.text = cellInfo.0
        cell.detailTextLabel?.text = cellInfo.1
        return cell
    }

	override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return false
	}
}

fileprivate class ExampleCell: UITableViewCell {
    static let identifier = "A11yCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

