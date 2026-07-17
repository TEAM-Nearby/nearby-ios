//
//  ProfileResponseDTO.swift
//  Nearby
//

struct ProfileResponseDTO: Decodable {
    let profileId: Int
    let userId: Int
    let nickname: String
    let gender: String
    let birthYear: Int?
    let profileImageUrl: String?
    let intro: String?
    let mannerScore: Double
    let mannerKeywords: [String]
    let reviewCount: Int
    let status: String
    let phoneVerifiedAt: String?
    let keywords: [String]
}
