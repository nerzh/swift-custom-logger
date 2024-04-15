import Foundation
import Logging

public struct CustomHandler: LogHandler {

    public let formatter: LogFormatter
    public let printer: Printer
    public var logLevel: Logger.Level = .info
    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(self.metadata)
        }
    }
    
    public init(
        formatter: LogFormatter = BasicFormatter.appleDefault,
        printer: Printer = LoggerPrinter.standardOutput
    ) {
        self.formatter = formatter
        self.printer = printer
    }
    
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))

        let formattedMessage = self.formatter.processLog(
            level: level,
            message: message,
            prettyMetadata: prettyMetadata,
            file: file,
            function: function,
            line: line
        )
        self.printer.handle(formattedMessage)
    }
    
    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            self.metadata[metadataKey]
        }
        set {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }
}
