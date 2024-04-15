import Foundation
import Logging

public enum LogComponent {
    case text(String)
    case group([LogComponent])
    case timestamp
    case level
    case message
    case metadata
    case file
    case function
    case line

    public static var allNonmetaComponents: [LogComponent] {
        return [
            .timestamp,
            .level,
            .message,
            .metadata,
            .file,
            .function,
            .line
        ]
    }
}

public protocol LogFormatter {
    var timestampFormatter: DateFormatter { get }

    func processLog(
        level: Logger.Level,
        message: Logger.Message,
        prettyMetadata: String?,
        file: String, 
        function: String,
        line: UInt
    ) -> String
}

extension LogFormatter {
    public func processComponent(
        _ component: LogComponent,
        now: Date,
        level: Logger.Level,
        message: Logger.Message,
        prettyMetadata: String?,
        file: String,
        function: String,
        line: UInt
    ) -> String {
        switch component {
        case .text(let string):
            return string
        case .group(let logComponents):
            return logComponents.map({ component in
                self.processComponent(component, now: now, level: level, message: message, prettyMetadata: prettyMetadata, file: file, function: function, line: line)
            }).joined()
        case .timestamp:
            return self.timestampFormatter.string(from: now)
        case .level:
            return "\(level)"
        case .message:
            return "\(message)"
        case .metadata:
            return "\(prettyMetadata.map { "\($0)" } ?? "")"
        case .file:
            return "\(file)"
        case .function:
            return "\(function)"
        case .line:
            return "\(line)"
        }
    }
}
