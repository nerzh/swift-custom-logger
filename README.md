```swift
import SwiftCustomLogger
import Logging

func setupLogger(label: String = "", level: Logger.Level? = nil) -> Logger {
    var level: Logger.Level! = level
    if level == nil {
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
                    case .debug: return "🛠️"
                    case .info: return "📟"
                    case .notice: return "❕"
                    case .warning: return "⚠️"
                    case .error: return "🐞"
                    case .critical: return "❌"
                    }
                }),
                .text({ level in "[\(level)]".uppercased() }),
                .text({ _ in label }),
                .file,
                .line,
                .text({ _ in ":" }),
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
