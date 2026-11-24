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

private enum OutputStream: TextOutputStream {
    case stderr, stdout

    func write(_ string: String) {
        #if canImport(Darwin.C)
        let file = self == .stderr ? Darwin.stderr : Darwin.stdout
        #elseif canImport(Android)
        let file = self == .stderr ? Android.stderr : Android.stdout
        #elseif canImport(WASILibc)
        let file = self == .stderr ? WASILibc.stderr! : WASILibc.stdout!
        #elseif canImport(Glibc)
        let file = self == .stderr ? Glibc.stderr! : Glibc.stdout!
        #elseif canImport(Musl)
        let file = self == .stderr ? Musl.stderr! : Musl.stdout!
        #elseif canImport(ucrt)
        let file = self == .stderr ? ucrt.stderr! : ucrt.stdout!
        #endif

        string.withCString { ptr in
            flockfile(file)
            defer { funlockfile(file) }
            _ = fputs(ptr, file)
        }
    }
}
