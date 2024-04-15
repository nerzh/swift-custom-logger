```swift
public func setupLogger(level: Logger.Level? = nil) -> Logger {
    var level: Logger.Level! = level
    if level.isNil {
        #if DEBUG
        level = .debug
        #else
        level = .warning
        #endif
    }
    
    var icon: String = ""
    switch level {
    case .trace: icon = "💾"
    case .debug: icon = "🐞"
    case .info: icon = "📟"
    case .notice: icon = "❕"
    case .warning: icon = "⚠️"
    case .error: icon = "🛑"
    case .critical: icon = "❌"
    case .none:
        break
    }
    var log = Logger(label: "Yor App Log:") { label in
        return CustomHandler(
            formatter: BasicFormatter([
                .text(icon),
                .text(label),
                .level,
                .file,
                .line,
                .text(":\n"),
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
