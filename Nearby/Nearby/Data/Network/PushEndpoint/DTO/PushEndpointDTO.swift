//
//  PushEndpointDTO.swift
//  Nearby
//
//  Created by h2e on 10/12/26.
//

struct RegisterPushEndpointRequestDTO {
    let installationId: String
    let token: String
    let platform: String
}

struct PushEndpointResponseDTO: Decodable {
    let endpointId: Int
    let installationId: String
    let platform: String
    let active: Bool
}
