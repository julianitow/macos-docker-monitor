//
//  ConfigCard.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ConfigCard: View {
    @Binding var config: Config
    var geometryProxy: GeometryProxy
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: config.connectionStatus != .CONNECTED ?
                      "point.3.filled.connected.trianglepath.dotted": "point.3.connected.trianglepath.dotted")
                Text(config.name.uppercased())
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: geometryProxy.size.width - 100)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "pencil")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                    .onTapGesture {
                        Utils.alert(message: "Edition not implemented yet", type: .warning, informativeText: config.toJsonStr())
                    }
            }
            HStack {
                Text(config.host)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Text(config.connectionStatus.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .background(config.isSelected ? .blue : config.connectionStatus == .CONNECTED ? Color(hex: "#2ecc71") : config.connectionStatus == .ERROR ? Color(hex: "#c0392b") : Color(hex: "#95a5a6"))
        .cornerRadius(10)
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: geometryProxy.size.width - 30)
        .padding()
    }
}
