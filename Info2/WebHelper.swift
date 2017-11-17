//
//  WebHelper.swift
//  Info2
//
//  Created by Finn Gaida on 17.11.17.
//  Copyright © 2017 Finn Gaida. All rights reserved.
//

import Foundation

struct WebHelper {
    static let baseURL = "http://ttt.in.tum.de/"
    static let beginTag = "recordings/Info2"

    static func videoTuples() throws -> [(String, URL)] {
        let names = try videoNames()
        return (try videoURLs()).enumerated().map({ (offset: Int, element: URL) in
            return (names[offset], element)
        })
    }

    static func videoURLs() throws -> [URL] {
        let scans = try scrape()
        return scans.map({ URL(string: baseURL.appending($0)) }).flatMap({ $0 })
    }

    static func videoNames() throws -> [String] {
        let scans = try scrape()
        return scans.map({
            (($0 as NSString).substring(from: 11) as NSString).substring(to: 16)
        })
    }

    private static func scrape() throws -> [String] {
        guard let url = URL(string: baseURL.appending("lectures/index_ws1617.php#INF2")) else { return [] }

        let scrape = try String(contentsOf: url)
        let scanner = Scanner(string: scrape)
        let endTag = "\">mp4</a>"

        var scans = [String]()
        while scanner.scanUpTo(beginTag, into: nil) {
            scanner.scanUpTo(endTag, into: nil)
            scanner.scanLocation -= 48
            var scan: NSString?
            scanner.scanUpTo(endTag, into: &scan)
            if let s = scan { scans.append(s as String) }
        }

        return scans
    }
}
