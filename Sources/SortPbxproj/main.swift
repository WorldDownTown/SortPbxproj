import Commander
import SortPbxprojCore

func main(path: String, suppress: Bool) {
    do {
        let decorator: PathDecorator = .init(path: path, strict: !suppress)
        let projectFilePath: String = try decorator.decorate()
        let reader: FileReader = try .init(path: projectFilePath)
        try reader.sort()
    } catch {
        print(error.localizedDescription)
    }
}

command(
    Argument<String>("filepath", description: "File path to *.xcodeproj or project.pbxproj"),
    Flag("no-warnings")) { (path: String, suppress: Bool) in
        main(path: path, suppress: suppress)
    }.run()
