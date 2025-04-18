import Foundation
import Logging
#if canImport(Darwin.C)
import Darwin.C

#elseif canImport(Android)
import Android

#elseif canImport(WASILibc)
import WASILibc

#elseif canImport(Glibc)
import Glibc

#elseif canImport(Musl)
import Musl

#elseif canImport(ucrt)
import ucrt

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

    #if canImport(Darwin.C)
    static let stderr = OutputStream(file: Darwin.stderr)
    static let stdout = OutputStream(file: Darwin.stdout)

    #elseif canImport(Android)
    static let stderr = OutputStream(file: Android.stderr!)
    static let stdout = OutputStream(file: Android.stdout!)

    #elseif canImport(WASILibc)
    static let stderr = OutputStream(file: WASILibc.stderr!)
    static let stdout = OutputStream(file: WASILibc.stdout!)

    #elseif canImport(Glibc)
    static let stderr = OutputStream(file: Glibc.stderr!)
    static let stdout = OutputStream(file: Glibc.stdout!)

    #elseif canImport(Musl)
    static let stderr = OutputStream(file: Musl.stderr!)
    static let stdout = OutputStream(file: Musl.stdout!)

    #elseif canImport(ucrt)
    static let stderr = OutputStream(file: ucrt.stderr!)
    static let stdout = OutputStream(file: ucrt.stdout!)

    #endif
}
