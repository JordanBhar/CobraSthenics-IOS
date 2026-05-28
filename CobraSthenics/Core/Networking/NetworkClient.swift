import Foundation

public protocol NetworkClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkClient {}
