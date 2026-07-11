//
//  OpenChatDisplayable.swift
//  Nearby
//
//  Created by h2e on 7/11/26.
//

import Combine
import UIKit

protocol OpenChatDisplayable {
    var showOpenChat: PassthroughSubject<URL, Never> { get }
    var showChatLinkPopup: PassthroughSubject<String, Never> { get }
}
