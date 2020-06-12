//
//  EndPoint.swift
//  NetworkLayer
//
//  Created by Irfan Ahmed on 10/06/2020.
//  Copyright © 2020 Irfan Ahmed. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var version: String { get }
}

