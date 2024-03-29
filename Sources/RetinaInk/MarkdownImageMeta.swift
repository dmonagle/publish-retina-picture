//
//  MarkdownImageMeta.swift
//  
//
//  Created by David Monagle on 16/6/20.
//

import Foundation

/// Destructs a markdown image
public struct MarkdownImageMeta {
    public let url: URL
    public let alt: String?
    
    public init?(markdown: String) {
        guard
            markdown.first == "!",
            let path = markdown.firstSubstring(between: "(", and: ")"),
            let url = URL(string: String(path))
        else {
            return nil
        }
        
        self.url = url
        self.alt = markdown.firstSubstring(between: "[", and: "]").map { String($0) }
    }
    

    public init?(markdown: Substring) {
        self.init(markdown: String(markdown))
    }
    
    public func queryValue(for key: String) -> String? {
        guard let value = self.queryParameters[key] else { return nil }
        return value
    }

    public func queryKeyExists(_ key: String) -> Bool {
        self.queryParameters.keys.contains(key)
    }

    public var queryParameters: [String: String?] {
        guard
            let components = URLComponents(url: self.url, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems
        else {
            return [:]
        }

        return queryItems.reduce(into: [String: String?]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
