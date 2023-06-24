//
//  ConfigCard.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ConfigCard: View {
    var config: Config
    
    var body: some View {
        VStack {
            Text(config.name.uppercased())
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 200)
                .foregroundColor(config.connected ? .white : .black)
            
            Spacer()
            
            Image(systemName: "pencil")
                .font(.title)
                .foregroundColor(.gray)
                .padding()
            
            Text(config.host)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom)
        }
        .background(config.connected ? Color.blue : Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
        .frame(minWidth: 100, maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
}

struct ConfigCard_Previews: PreviewProvider {
    static var previews: some View {
        let config: Config = MockedData.fetchConfigs()[0]
        ConfigCard(config: config).previewLayout(.sizeThatFits)
    }
}
