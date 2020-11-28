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
    let MessagingRobot = MessagesRobot()
    
    override func setUp() {
        continueAfterFailure = false
        try! server.start()
        server["/"] = websocket(text: { session, text in
            if text.contains("Hi Server!") {
                session.writeText("Sent data via mocked Websocket")
            }
            else if text.contains("2nd Send Websocket data") {
                session.writeText("Sent data two via mocked Websocket")
            }
            else {
                session.writeText("Could not find the text we were looking for")
            }
        }, binary: { session, binary in
            session.writeBinary(binary)
        })
        app.launchArguments += ["TESTING"]
    }
    
    override func tearDown() {
        server.stop()
        super.tearDown()
    }
    
    func testSendingMockedWebsocketData() {
        app.restart()
        MessagingRobot
            .tapWebsocketButton()
            .assertSentWebsocketText(text: "Sent data via mocked Websocket")
    }
    
    func testSendingMockedWebsocketDataExampleTwo() {
        app.restart()
        MessagingRobot
            .tapWebsocketButton2()
            .assertSentWebsocketText(text: "Sent data two via mocked Websocket")
    }
}

