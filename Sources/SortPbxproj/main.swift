import Commander

command(
    Argument<String>("filepath", description: "File path to *.xcodeproj or project.pbxproj"),
    Flag("no-warnings")) { (filepath: String, suppress: Bool) in
        print("filepath: \(filepath) / no-warnings: \(suppress)")
    }.run()
