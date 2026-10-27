//
//  String+DisplayName.swift
//  Nearby
//
//  Created by h2e on 10/27/26.
//

extension String {
    private static let withdrawnUserName = "탈퇴한 사용자"

    var displayNickname: String {
        hasPrefix(Self.withdrawnUserName) ? Self.withdrawnUserName : self
    }
}
