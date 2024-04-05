#if canImport(Dispatch)
import Dispatch
#endif
#if canImport(Foundation)
import Foundation
#endif
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@main
struct Hello {

    static func main() async throws {
        print("Hello, world! 👋")
        try await testConcurrency()
        #if canImport(Dispatch)
        print("Dispatch installed")
        testDispatch()
        #endif
        #if canImport(Foundation)
        print("Foundation installed")
        testFoundation()
        #endif
        #if canImport(FoundationNetworking) || canImport(Darwin)
        print("FoundationNetworking installed")
        try await testFoundationNetworking()
        #endif
    }
}

struct TestError: Error {

    let reason: String
}

func testConcurrency() async throws {
    let task = Task {
        var didCatchError = false
        do { try await asyncErrorTest() }
        catch CocoaError.userCancelled { didCatchError = true }
        catch { fatalError("Unexpected error catching") }
        precondition(didCatchError)
    }
    await task.value
    for _ in 0 ..< 5 {
        try await Task.sleep(nanoseconds: 100_000)
        try await Task.sleep(for: .microseconds(10))
    }
    print("Concurrency test passed")
}

func asyncErrorTest(error: Error = CocoaError(.userCancelled)) async throws {
    throw error
}

#if canImport(Foundation)
func testFoundation() {
    print("UUID:", UUID())
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .full
    print("Date:", formatter.string(from: Date()))
}
#endif

#if canImport(Dispatch)
func testDispatch() {
    DispatchQueue.global().sync {
        print("Dispatch thread: \(Thread.current.name ?? "\(Thread.current)")")
    }
}
#endif

#if canImport(FoundationNetworking) || canImport(Darwin)
func testFoundationNetworking() async throws {
    let url = URL(string: "https://httpbin.org/anything")!
    let body = Data("test-\(UUID())".utf8)
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = body
    let (data, urlResponse) = try await URLSession.shared.data(for: request)
    guard let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw TestError(reason: "Invalid response")
    }
    guard let json = String(data: data, encoding: .utf8) else {
        throw TestError(reason: "Invalid response")
    }
    print(json)
    print("URLSession test passed")
}

#if os(Linux)
extension URLSession {

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (data ?? .init(), response!))
                }
            }
            task.resume()
        }
    }
}
#endif
#endif
