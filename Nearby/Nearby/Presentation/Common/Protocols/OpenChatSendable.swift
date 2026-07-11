//
//  OpenChatSendable.swift
//  Nearby
//
//  Created by h2e on 7/11/26.
//

import Combine
import Foundation

protocol OpenChatSendable {
    var openChatURLString: String { get }
    var openChatOutput: OpenChatDisplayable { get }
}

extension OpenChatSendable {
    func sendOpenChatURL() {
        guard let url = URL(string: openChatURLString), url.scheme == "https" || url.scheme == "http" else { return }
        openChatOutput.showOpenChat.send(url)
    }
    
    func sendChatLinkPopup() {
        openChatOutput.showChatLinkPopup.send(openChatURLString)
    }
}
