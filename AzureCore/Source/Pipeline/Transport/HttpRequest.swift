//
//  HttpRequest.swift
//  AzureCore
//
//  Created by Travis Prescott on 8/23/19.
//

import Foundation

public class HttpRequest {

    public var httpMethod: HttpMethod
    public var url: String
    public var headers: HttpHeaders
    public var files: [String]?
    public var data: Data?

    public var query: [URLQueryItem]? {
        let comps = URLComponents(string: self.url)?.queryItems
        return comps
    }

    public var body: Data? {
        get {
            return self.data
        }
        set(newValue) {
            self.data = newValue
        }
    }

    convenience public init(httpMethod: HttpMethod, url: String) {
        self.init(httpMethod: httpMethod, url: url, headers: HttpHeaders())
    }

    public init(httpMethod: HttpMethod, url: String, headers: HttpHeaders? = nil, files: [String]? = nil,
                data: Data? = nil) {
        self.httpMethod = httpMethod
        self.url = url
        self.headers = headers ?? HttpHeaders()
        self.files = files
        self.data = data
    }

    public func format(queryParams: [String: String]?) {
        guard var urlComps = URLComponents(string: self.url) else { return }
        var queryItems = self.url.parseQueryString() ?? [String: String]()

        // add any query params from the queryParams dictionary
        if queryParams != nil {
            for (name, value) in queryParams! {
                queryItems[name] = value
            }
        }
        urlComps.queryItems = queryItems.convertToQueryItems()
        self.url = urlComps.url(relativeTo: nil)?.absoluteString ?? self.url
    }
}
