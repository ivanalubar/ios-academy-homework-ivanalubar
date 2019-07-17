//
//  PromiseKit+KeyPath.swift
//  TVShows
//
//  Created by Infinum on 17/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation
import Alamofire
import CodableAlamofire
import PromiseKit

extension Alamofire.DataRequest {
    
    public func responseDecodable<T: Decodable>(_ type: T.Type, keypath: String, queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder()) -> Promise<T> {
        return Promise { seal in
            responseDecodableObject(queue: queue, keyPath: keypath, decoder: decoder, completionHandler: { (response: DataResponse<T>) in
                switch response.result {
                case .success(let model):
                    seal.fulfill(model)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
}
