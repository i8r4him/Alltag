//
//  RealtimeSocket.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The live voice's connection, so tests can script it.
protocol RealtimeSocket: AnyObject {
    func send(_ data: Data) async throws
    func receive() async throws -> Data
    func close()
}

/// A WebSocket over `URLSession`, for the live voice.
final class URLSessionRealtimeSocket: RealtimeSocket {
    private let task: URLSessionWebSocketTask

    init(request: URLRequest) {
        task = URLSession.shared.webSocketTask(with: request)
        task.resume()
    }

    func send(_ data: Data) async throws {
        guard let text = String(data: data, encoding: .utf8) else { throw RealtimeServiceError.unexpectedResponse }
        try await task.send(.string(text))
    }

    func receive() async throws -> Data {
        switch try await task.receive() {
        case .string(let text): Data(text.utf8)
        case .data(let data): data
        @unknown default: throw RealtimeServiceError.unexpectedResponse
        }
    }

    func close() {
        task.cancel(with: .normalClosure, reason: nil)
    }
}
