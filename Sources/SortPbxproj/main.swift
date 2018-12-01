import Commander
import SortPbxprojCore

private func main(path: String, suppress: Bool) throws {
    let decorator: PathDecorator = .init(path: path, strict: !suppress)
    let projectFilePath: String = try decorator.decorate()
    let reader: ProjectFileReader = try .init(path: projectFilePath)
    let writer: ProjectFileWriter = .init(path: projectFilePath)
    try writer.createTmpFile()
    reader.sortLines(callback: writer.write)
    try writer.overwritePbxproj()
}

command(
    Argument<String>("filepath", description: "File path to *.xcodeproj or project.pbxproj"),
    Flag("no-warnings"),
    main).run()
