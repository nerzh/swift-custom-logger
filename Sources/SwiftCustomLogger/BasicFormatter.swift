import Foundation
import Logging

public struct BasicFormatter: LogFormatter {
    
    public let timestampFormatter: DateFormatter
    
    public let format: [LogComponent]
    
    public let separator: String?

    public static var timestampFormatter: DateFormatter {
        let result = DateFormatter()
        result.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return result
    }
    
    public init(
        _ format: [LogComponent] = LogComponent.allNonmetaComponents,
        separator: String = " ",
        timestampFormatter: DateFormatter = BasicFormatter.timestampFormatter
    ) {
        self.format = format
        self.separator = separator
        self.timestampFormatter = timestampFormatter
    }
    
    public func processLog(
        level: Logger.Level,
        message: Logger.Message,
        prettyMetadata: String?,
        file: String,
        function: String,
        line: UInt
    ) -> String {
        let now = Date()

        return self.format.map({ (component) -> String in
            return self.processComponent(
                component,
                now: now,
                level: level,
                message: message,
                prettyMetadata: prettyMetadata,
                file: file,
                function: function,
                line: line
            )
        }).filter({ (string) -> Bool in
            return string.count > 0
        }).joined(separator: self.separator ?? "")
    }

    /// [apple/swift-log](https://github.com/apple/swift-log)'s log format
    /// `2024-04-12T10:00:07-0310 error: Test error message`
    public static let appleDefault = BasicFormatter(
        [
            .timestamp,
            .group([
                .level,
                .text({ _ in ":" }),
            ]),
            .message
        ]
    )
}
