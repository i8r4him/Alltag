//
//  KeyboardPictureTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import SwiftUI
import Testing
import UIKit
@testable import Alltag

/// Draws the keyboard into PNG files, to look at it without an iPhone.
///
/// It only draws where the folder `.keyboard-pictures` exists in the checkout on the
/// Mac that runs the simulator (`~/Developer/Alltag`). Everywhere else it does nothing.
@Suite("Keyboard pictures")
@MainActor
struct KeyboardPictureTests {
    /// Apple's widest iPhone, the one the sizes were measured on.
    let size = CGSize(width: 440, height: KeyboardView.height(isCompact: false))

    static var folder: URL? {
        guard let home = ProcessInfo.processInfo.environment["SIMULATOR_HOST_HOME"] else { return nil }
        let url = URL(fileURLWithPath: home).appendingPathComponent("Developer/Alltag/.keyboard-pictures")
        var isFolder: ObjCBool = false
        guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isFolder), isFolder.boolValue else { return nil }
        return url
    }

    var keys: KeyboardGeometry {
        let height = size.height - KeyboardView.toolsHeight(isCompact: false)
        return KeyboardGeometry(rows: KeyboardLayout.allRows(for: .letters, showsGlobe: false),
                                size: CGSize(width: size.width, height: height))
    }

    func makeModel() -> KeyboardModel {
        let model = KeyboardModel()
        model.document = FakeDocument()
        model.suggester = FixedWords(words: ["Ha": ["Hallo", "Haus", "Hand"]])
        model.documentChanged(KeyboardTraits())
        return model
    }

    @Test("The keyboard is drawn into pictures where a folder waits for them",
          arguments: [UIUserInterfaceStyle.light, .dark])
    func pictures(style: UIUserInterfaceStyle) async throws {
        guard let folder = Self.folder else { return }
        let name = style == .dark ? "dark" : "light"
        func file(_ state: String) -> URL { folder.appendingPathComponent("\(state)-\(name).png") }

        let model = makeModel()
        try await draw(KeyboardView(model: model), style: style, to: file("1-capitals"))

        model.activate(.character("h"))
        model.activate(.character("a"))
        model.refreshSuggestions()
        try await draw(KeyboardView(model: model), style: style, to: file("2-words"))

        let point = try #require(keys.frame(of: .character("g"))).frame
        model.touchDown(1, at: CGPoint(x: point.midX, y: point.midY), in: keys)
        try await draw(KeyboardView(model: model), style: style, to: file("3-pressed"))
        model.touchCancelled(1)

        let held = try #require(keys.frame(of: .character("o"))).frame
        model.touchDown(2, at: CGPoint(x: held.midX, y: held.midY), in: keys)
        model.longPress(2, in: keys)
        try await draw(KeyboardView(model: model), style: style, to: file("4-held"))
        model.touchCancelled(2)

        model.activate(.page(.symbols))
        try await draw(KeyboardView(model: model), style: style, to: file("5-symbols"))

        model.activate(.emoji)
        try await draw(KeyboardView(model: model), style: style, to: file("6-emoji"))

        try await draw(FontSheet(), style: style, to: file("7-fonts"))
    }

    /// Puts a view in a window on the keyboard's backdrop and writes what it shows.
    func draw(_ view: some View, style: UIUserInterfaceStyle, to url: URL) async throws {
        let backdrop = style == .dark ? Color(white: 33 / 255) : Color(red: 225 / 255, green: 225 / 255, blue: 229 / 255)
        // A window this low would count as an iPhone on its side.
        let host = UIHostingController(rootView: view.background(backdrop).environment(\.verticalSizeClass, .regular))
        host.overrideUserInterfaceStyle = style
        host.safeAreaRegions = []
        let scene = try #require(UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first)
        let window = UIWindow(windowScene: scene)
        window.frame = CGRect(origin: .zero, size: size)
        window.rootViewController = host
        window.isHidden = false
        window.layoutIfNeeded()
        // SwiftUI puts its layers in place a moment after the layout.
        try await Task.sleep(for: .milliseconds(200))
        let format = UIGraphicsImageRendererFormat()
        format.scale = 3
        let image = UIGraphicsImageRenderer(size: size, format: format).image { context in
            window.layer.render(in: context.cgContext)
        }
        try #require(image.pngData()).write(to: url)
        window.isHidden = true
    }
}

/// The letters of the first row in the fonts a key could use, to compare with Apple's keys.
private struct FontSheet: View {
    private let fonts: [(String, Font)] = [
        ("default", .system(size: 22)),
        ("rounded", .system(size: 22, design: .rounded)),
        ("condensed", .system(size: 22).width(.condensed)),
        ("narrow -0.1", .system(size: 22).width(Font.Width(-0.1))),
        ("medium", .system(size: 22, weight: .medium)),
        ("medium -0.05", .system(size: 22, weight: .medium).width(Font.Width(-0.05))),
        ("compact " + compactName(.regular), compact(.regular)),
        ("compact medium " + compactName(.medium), compact(.medium))
    ]

    /// The system font in its compact design, if this iOS has it.
    private static func compactFont(_ weight: UIFont.Weight) -> UIFont? {
        let design = UIFontDescriptor.SystemDesign(rawValue: "NSCTFontUIFontDesignCompact")
        return UIFont.systemFont(ofSize: 22, weight: weight).fontDescriptor.withDesign(design)
            .map { UIFont(descriptor: $0, size: 22) }
    }

    private static func compact(_ weight: UIFont.Weight) -> Font {
        compactFont(weight).map { Font($0) } ?? .system(size: 8)
    }

    private static func compactName(_ weight: UIFont.Weight) -> String {
        compactFont(weight)?.fontName ?? "none"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(fonts, id: \.0) { name, font in
                HStack(spacing: 10) {
                    Text(verbatim: "QWERTZUIOPÜ qwertzuiopü 123").font(font)
                    Text(verbatim: name).font(.system(size: 11))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(.leading, 8)
    }
}
