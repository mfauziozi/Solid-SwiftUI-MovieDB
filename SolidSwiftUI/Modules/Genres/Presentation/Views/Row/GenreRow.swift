//
//  GenreRow.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 22/07/25.
//

import SwiftUI

struct GenreRow: View {
    let genre: Genre

    var body: some View {
        HStack {
            Text(genre.name)
                .font(.system(size: 20))
                .padding(.vertical, 12)
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding(.vertical, 4)
    }
}
