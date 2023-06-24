//
//  ConfigCard.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ConfigCard: View {
    @Binding var config: Config
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text(config.name.uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 100)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "pencil")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                    .onTapGesture {
                        let alert = NSAlert()
                        alert.informativeText = "Coming soon"
                        alert.addButton(withTitle: "Roger that.")
                        alert.alertStyle = .warning
                        alert.runModal()
                    }
            }
            .frame(width: 200)
            HStack {
                Text(config.host)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .background(config.isSelected ? .blue : config.isConnected ? Color(hex: "#2ecc71") : Color(hex: "#95a5a6"))
        .cornerRadius(10)
        .frame(minWidth: 100, maxWidth: 100)
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
}
