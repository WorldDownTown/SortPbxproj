import Commander
import SortPbxprojCore

private func main(path: String, suppress: Bool) {
    do {
        let decorator: PathDecorator = .init(path: path, strict: !suppress)
        let projectFilePath: String = try decorator.decorate()

        let reader: ProjectFileReader = try .init(path: projectFilePath)
        reader.sortLines { string in
            print(string)
        }
    } catch {
        print(error.localizedDescription)
    }
}

command(
    Argument<String>("filepath", description: "File path to *.xcodeproj or project.pbxproj"),
    Flag("no-warnings"),
    main).run()
