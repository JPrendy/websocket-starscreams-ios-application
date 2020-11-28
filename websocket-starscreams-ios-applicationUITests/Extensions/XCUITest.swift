//
//  XCUITest.swift
//  websocket-starscreams-ios-applicationUITests
//
//  Created by James Prendergast  on 28/11/2020.
//

import XCTest

extension XCUIElement {

    func dragAndDrop(dropElement: XCUIElement, duration: Double = 2) {
        self.press(forDuration: duration, thenDragTo: dropElement)
    }

    func safeTap() {
        if !self.isHittable {
            let coordinate: XCUICoordinate =
                self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        } else { self.tap() }
    }

    @discardableResult
    func waitForLoss(timeout: Double) -> Bool {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var elementPresent = exists
        while elementPresent && endTime > Date().timeIntervalSince1970 * 1000 {
            elementPresent = exists
        }
        return !elementPresent
    }

    func waitForText(_ expectedText: String, timeout: Double) -> Bool {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var elementPresent = exists
        var textPresent = false
        while !textPresent && elementPresent && endTime > Date().timeIntervalSince1970 * 1000 {
            elementPresent = exists
            textPresent = (self.text == expectedText)
        }
        return textPresent
    }

    func clear() {
        guard let stringValue = value as? String else {
            return
        }

        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        tap()
        typeText(deleteString)
    }

    var text: String {
        var labelText = label as String
        labelText = label.contains("AX error") ? "" : labelText
        let valueText = value as? String
        let text = labelText.isEmpty ? valueText : labelText
        return text ?? ""
    }

    var centralCoordinates: CGPoint {
        CGPoint(x: self.frame.midX, y: self.frame.midY)
    }

    var height: Double {
        Double(self.frame.size.height)
    }

    var width: Double {
        Double(self.frame.size.width)
    }
}

extension XCUIElementQuery {

    @discardableResult
    func waitCount(_ expectedCount: Int, timeout: Double) -> Int {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var actualCount = count
        while actualCount < expectedCount && endTime > Date().timeIntervalSince1970 * 1000 {
            actualCount = count
        }
        return actualCount
    }

    var lastMatch: XCUIElement? {
        allElementsBoundByIndex.last
    }
}

extension XCUIApplication {

    func saveToBuffer(text: String) {
        UIPasteboard.general.string = text
    }

    func tap(x: CGFloat, y: CGFloat) {
        let normalized = self.coordinate(
            withNormalizedOffset: CGVector(dx: 0, dy: 0)
        )
        let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
        coordinate.tap()
    }

    func doubleTap(x: CGFloat, y: CGFloat) {
        let normalized = self.coordinate(
            withNormalizedOffset: CGVector(dx: 0, dy: 0)
        )
        let coordinate = normalized.withOffset(CGVector(dx: x, dy: y))
        coordinate.doubleTap()
    }

    func waitForChangingState(from previousState: State, timeout: Double) -> Bool {
        let endTime = Date().timeIntervalSince1970 * 1000 + timeout * 1000
        var isChanged = (previousState != self.state)
        while !isChanged && endTime > Date().timeIntervalSince1970 * 1000 {
            isChanged = (previousState != self.state)
        }
        return isChanged
    }

    func waitForLosingFocus(timeout: Double) -> Bool {
        sleep(UInt32(timeout))
        return !self.debugDescription.contains("subtree")
    }

    func landscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
    }

    func portrait() {
        XCUIDevice.shared.orientation = .portrait
    }

    func openNotificationCenter() {
        let up = self.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.001))
        let down = self.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.8))
        up.press(forDuration: 0.1, thenDragTo: down)
    }

    func openControlCenter() {
        let down = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.999))
        let up = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        down.press(forDuration: 0.1, thenDragTo: up)
    }

    func back() {
        self.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func rollUp() {
        XCUIDevice.shared.press(XCUIDevice.Button.home)
    }

    func rollUp(sec: Int, withDelay: Bool = false) {
        if withDelay { sleep(1) }
        rollUp()
        sleep(UInt32(sec))
        launch()
        if withDelay { sleep(1) }
    }

    func launch() {
        self.activate()
    }

    func close() {
        self.terminate()
    }

    func restart() {
        close()
        launch()
    }

    func bundleId() -> String {
        Bundle.main.bundleIdentifier ?? ""
    }
}
