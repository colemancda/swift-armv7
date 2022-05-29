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
        try await Task.sleep(nanoseconds: 1_000_000_000)
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