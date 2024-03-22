//
//  ExpandingTextFieldPreview.swift
//
//
//  Created by Brenden French on 3/21/24.
//

import SwiftUI

fileprivate struct ExpandingTextFieldPreview: View {
	
	@State private var text = """
This is a wrapper around a normal SwiftUI TextField. It expands to fit multiple lines of text because the axis is set to vertical.

Here is the code for it:
👉 TextField("", text: $text, axis: .vertical)

Normally this only works on iOS 16 or newer, but this wrapper also uses the single line TextField as a fallback to retain compatibility with older versions of iOS.

Here is the code for this SwiftfulUI wrapper:
👉 ExpandingTextField("", text: $text)
"""
	
	var body: some View {
		ExpandingTextField("", text: $text)
	}
}

public struct ExpandingTextField: View {
	
	var placeholder: String
	@Binding private var text: String
	
	init(_ placeholder: String, text: Binding<String>) {
		self.placeholder = placeholder
		self._text = text
	}
	
	public var body: some View {
		if #available(iOS 16.0, *) {
			TextField(placeholder, text: $text, axis: .vertical)
		} else {
			TextField(placeholder, text: $text)
		}
	}
}

#Preview{
	ExpandingTextFieldPreview()
}
