```swift
import SwiftCustomLogger

public func setupLogger(label: String = "", level: Logger.Level? = nil) -> Logger {
    var level: Logger.Level! = level
    if level.isNil {
        #if DEBUG
        level = .debug
        #else
        level = .warning
        #endif
    }
    
    var log = Logger(label: label) { label in
        return CustomHandler(
            formatter: BasicFormatter([
                .text({ level in
                    switch level {
                    case .trace: return "💾"
                    case .debug: return "🐞"
                    case .info: return "📟"
                    case .notice: return "❕"
                    case .warning: return "⚠️"
                    case .error: return "🛑"
                    case .critical: return "❌"
                    }
                }),
                .text({ _ in label }),
                .level,
                .file,
                .line,
                .text({ _ in ":\n" }),
                .message
            ],
            separator: " "),
            printer: LoggerPrinter.standardOutput
        )
    }
    log.logLevel = level
    
    return log
}

```
