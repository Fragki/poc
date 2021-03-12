//
//  ContentView.swift
//  HTML
//
//  Created by fragi on 11/03/2021.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack(spacing: 0, content: {
            AttributedText(attributedText: getStyledText("<h1>bbbbbbccc</h1>"))
            AttributedText(attributedText: getStyledText("<p>bbbbbb<b>ccc</b></p>"))

            Text("Hello, world!")
                .padding()
                .background(Color.blue)
            Spacer()
        })

    }

    func getStyledText(_ text: String) -> NSAttributedString? {
        let colorHex = "000000"
        let htmlCSSString = "<style>" +
            "html *" +
            "{" +
            "font-size: \(22)pt;" +
            "color: #\(colorHex);" +
            "font-family: -apple-system;" +
            "margin-bottom: 0pt;" +
        "}</style>\(text)"
        return try? NSMutableAttributedString(data: Data(htmlCSSString.utf8),
                                                      options: [.documentType: NSAttributedString.DocumentType.html,
                                                                .characterEncoding: String.Encoding.utf8.rawValue],
                                                      documentAttributes: nil)
    }
}

struct AttributedText: View {
    @State var attributedText: NSAttributedString?
    @State private var desiredHeight: CGFloat = 0

    var body: some View {
        HTMLText(attributedString: $attributedText,
                 desiredHeight: $desiredHeight)
        .frame(height: desiredHeight)
    }

}

fileprivate struct HTMLText: UIViewRepresentable {
    @Binding var attributedString: NSAttributedString?
    @Binding var desiredHeight: CGFloat

    func makeUIView(context: UIViewRepresentableContext<Self>) -> HTMLLabel {
        HTMLLabel()
    }

    func updateUIView(_ uiView: HTMLLabel, context: UIViewRepresentableContext<Self>) {
        guard let attributedString = attributedString else { return }
        uiView.attributedText = NSMutableAttributedString(attributedString: attributedString)
            .trimTrailingWhiteSpace()
        uiView.isEditable = false

        DispatchQueue.main.async {
            uiView.contentOffset = .zero
            let size = uiView.intrinsicContentSize
            guard size.height != self.desiredHeight else { return }
            self.desiredHeight = size.height
        }
        
    }
}
fileprivate final class HTMLLabel: UITextView {

    convenience init() {
        self.init(frame: .zero)
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    override var intrinsicContentSize: CGSize {
        systemLayoutSizeFitting(.init(width: frame.width,
                                      height: UIView.layoutFittingCompressedSize.height),
                                withHorizontalFittingPriority: .required,
                                verticalFittingPriority: .fittingSizeLevel)
    }
}

extension NSAttributedString {
    public func trimTrailingWhiteSpace() -> NSAttributedString {
        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
        let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
        guard let endLocation = endRange?.upperBound else {
            return NSAttributedString(string: string)
        }
        let length = string.utf16.distance(from: string.utf16.startIndex, to: endLocation)
        let range = NSRange(location: 0, length: length)
        return attributedSubstring(from: range)
    }
}
