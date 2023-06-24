//
//  ContainerCard.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContainerCard: View {
    
    @State var container: Container
    
    var body: some View {
        VStack {
            Text(container.name.uppercased())
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 200)
                .foregroundColor(.white)
            
            Spacer()
                    
            Text(container.status.rawValue)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.bottom)
        }
        .background(container.status == .RUNNING ? Color(hex: "#2ecc71") : container.status == .EXITED ? Color(hex: "#c0392b") : container.status == .STOPPED ? Color(hex: "#95a5a6") : .white)
        .cornerRadius(10)
        .frame(minWidth: 100, maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .padding()
    }
}

struct ContainerCard_Previews: PreviewProvider {
    static var previews: some View {
        let container = MockedData.fetchContainersProd()[0]
        ContainerCard(container: container)
    }
}
