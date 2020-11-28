//
//  MessagesRobot.swift
//  websocket-starscreams-ios-applicationUITests
//
//  Created by James Prendergast  on 28/11/2020.
//

import Foundation
import XCTest

public final class MessagesRobot {
    
    @discardableResult
    public func tapWebsocketButton() -> Self {
        app.buttons["Send Data"].tap()
        return self
    }
    
    public func tapWebsocketButton2() -> Self {
        app.buttons["Send Data 2"].tap()
        return self
    }
    
    public func findMatch( for identifier: String, in query: XCUIElementQuery, waitTimeout timeout: TimeInterval = 2.0) -> Bool {
        query.matching(identifier: identifier).firstMatch.waitForExistence(timeout: timeout)
    }
    
    @discardableResult
    public func assertSentWebsocketText(text: String) -> Self {
        sleep(5)
        let actualApiText = app.staticTexts.matching(identifier: "webSocketTextLabel").firstMatch.text
        let identifier = "webSocketTextLabel"
        // Will need to change this depending on where the identifier is set `app.staticTexts`, aka to check a button we would have `app.buttons`
        let hasfoundMatch = findMatch(for: identifier, in: app.staticTexts)
        XCTAssertTrue(hasfoundMatch, "No id matching \(identifier)")
        XCTAssertEqual(actualApiText, text)
        return self
    }
}
