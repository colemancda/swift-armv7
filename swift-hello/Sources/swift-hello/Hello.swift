import Foundation
import Dispatch

@main
struct Hello {
    static func main() async throws {
        print("Hello, world! 👋")
        let task = Task {
            var didCatchError = false
            do { try await errorTest() }
            catch TestError.error { didCatchError = true }
            catch { fatalError() }
            print("Task ran")
        }
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0) {
                continuation.resume()
            }
        }
        print("Bye")
    }
}

func errorTest() async throws {
    print("Will throw")
    throw TestError.error
}

enum TestError: Error {
    case error
}