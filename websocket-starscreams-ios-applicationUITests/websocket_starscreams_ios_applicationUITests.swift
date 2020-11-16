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
          session.writeText("Sent data via mocked Websocket")
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
