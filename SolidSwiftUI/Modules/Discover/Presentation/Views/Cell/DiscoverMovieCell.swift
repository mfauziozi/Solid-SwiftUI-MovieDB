//
//  DiscoverMovieCell.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import SwiftUI
import Kingfisher

struct MovieCellView: View {
    let title: String
    let imageURL: String
    let itemWidth = (UIScreen.main.bounds.width - 48) / 2

    var body: some View {
        VStack {
            KFImage(URL(string: imageURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: itemWidth * 1.5)
                .clipped()
                .cornerRadius(15)
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 40)
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}
