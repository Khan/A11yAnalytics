//
//  GenericAnalyticsService.swift
//  iOS Example
//
//  Created by Bryan Clark on 8/15/17.
//  Copyright © 2017 Khan Academy. All rights reserved.
//

import Foundation

public class GenericAnalyticsService {
    static let shared = GenericAnalyticsService()

    func reportEvent(named name: String, info: [String: String]) {
        print("--------\nLogging analytics event named: \(name) with info:\n\(info)\n\n")
    }
}
