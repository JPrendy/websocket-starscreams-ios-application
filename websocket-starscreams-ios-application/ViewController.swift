//
//  ViewController.swift
//  websocket-starscreams-ios-application
//
//  Created by James Prendergast  on 14/11/2020.
//

import UIKit
import Starscream

class ViewController: UIViewController {
    
    private var socket: WebSocket?
    
    override func viewDidLoad() {
        var request = URLRequest(url: URL(string: "ws://localhost:8082")!)
        if ProcessInfo.processInfo.arguments.contains("TESTING") {
          request = URLRequest(url: URL(string: "http://localhost:8080")!)
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    @IBOutlet weak var websocketData: UILabel!
    
    @IBAction func sendData(_ sender: Any) {
        socket?.write(string: "Hi Server!")
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            // this is the data we receive from other users sending data to specific port we use for websockets
            print("Received text: \(string)")
            websocketData.text = string
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("error")
        case .error(_):
            break
        }
    }
}

extension ViewController : WebSocketDelegate {
    public func websocketDidConnect(_ socket: Starscream.WebSocket) {
        
    }
    
    public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
        
    }
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
        guard let data = text.data(using: .utf16),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let jsonDict = jsonData as? [String: Any],
              let messageType = jsonDict["type"] as? String else {
            return
        }
        
        // 2
        if messageType == "message",
           let messageData = jsonDict["data"] as? [String: Any],
           let messageText = messageData["text"] as? String {
            
            websocketData.text = messageText
        }
    }
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
    }
}
