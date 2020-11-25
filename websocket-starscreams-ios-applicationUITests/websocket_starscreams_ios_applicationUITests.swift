//
//  websocket_starscreams_ios_applicationUITests.swift
//  websocket-starscreams-ios-applicationUITests
//
//  Created by James Prendergast  on 14/11/2020.
//

import XCTest
import Swifter

let app = XCUIApplication()

class websocket_starscreams_ios_applicationUITests: XCTestCase {
    

    override func setUpWithError() throws {
        continueAfterFailure = false
        let server = HttpServer()
        server["/"] = websocket(text: { session, text in
            if text.contains("Hi Server!") {
                session.writeText("Sent data via mocked Websocket")
            } else {
                session.writeText("Could not find the text we were looking for")
            }
        }, binary: { session, binary in
          session.writeBinary(binary)
        })
        try server.start()
        app.launchArguments += ["TESTING"]
    }

    override func tearDownWithError() throws {
    }

    func testSendingMockedWebsocketData() throws {
        app.launch()
        XCUIApplication().staticTexts["Send Data"].tap()
        XCUIApplication().staticTexts["Send Data"].tap()
    }
}
