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
    
    let server = HttpServer()

    override func setUpWithError() throws {
        continueAfterFailure = false
        server["/"] = websocket(text: { session, text in
            if text.contains("Hi Server!") {
                session.writeText("Sent data via mocked Websocket")
            }
            if text.contains("2nd Send Websocket data") {
                session.writeText("Sent data two via mocked Websocket")
            }
            else {
                session.writeText("Could not find the text we were looking for")
            }
        }, binary: { session, binary in
          session.writeBinary(binary)
        })
        try server.start()
        app.launchArguments += ["TESTING"]
    }

    override func tearDownWithError() throws {
        server.stop()
        super.tearDown()
    }

    func testSendingMockedWebsocketData() throws {
        app.launch()
        XCUIApplication().staticTexts["Send Data"].tap()
        XCUIApplication().staticTexts["Send Data"].tap()
    }
    
    func testSendingMockedWebsocketDataExampleTwo() throws {
        app.launch()
        XCUIApplication().staticTexts["Send Data 2"].tap()
        XCUIApplication().staticTexts["Send Data 2"].tap()
    }
}
