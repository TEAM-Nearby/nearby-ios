//
//  BaseResponseDTO.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import Foundation

struct BaseResponseDTO<T: Decodable>: Decodable {
    let status: Int
    let code: String
    let message: String
    let data: T?
}
