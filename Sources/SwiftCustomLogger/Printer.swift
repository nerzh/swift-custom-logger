import Foundation
import Logging
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
import Darwin
#else
import Glibc
#endif

public protocol Printer {
    func handle(_ formattedLogLine: String)
}

public struct LoggerPrinter: Printer {
    
    private let stream: TextOutputStream
    
    public static var standardOutput: LoggerPrinter {
        LoggerPrinter(OutputStream.stdout)
    }

    public static var standardError: LoggerPrinter {
        LoggerPrinter(OutputStream.stderr)
    }
    
    public init(_ stream: TextOutputStream) {
        self.stream = stream
    }
    
    public func handle(_ formattedLogLine: String) {
        var stream = self.stream
        stream.write("\(formattedLogLine)\n")
    }
}

private struct OutputStream: TextOutputStream {
    
    public let file: UnsafeMutablePointer<FILE>

    public func write(_ string: String) {
        string.withCString { ptr in
            flockfile(file)
            defer { funlockfile(file) }
            _ = fputs(ptr, file)
        }
    }
    
    #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
    static let stderr = OutputStream(file: Darwin.stderr)
    static let stdout = OutputStream(file: Darwin.stdout)
    #else
    static let stderr = OutputStream(file: Glibc.stderr!)
    static let stdout = OutputStream(file: Glibc.stdout!)
    #endif
}
