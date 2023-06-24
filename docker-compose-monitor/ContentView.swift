//
//  ContentView.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContentView: View {
    @State var configs = MockedData.fetchConfigs()
    @State private var firstColumnWidth: CGFloat = 0.2
    @State private var dragOffset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack { // config list
                    ForEach(configs, id: \.id) { config in
                        ConfigCard(config: config)
                            .onTapGesture {
                                toggleConnection(for: config)
                                print(config.connected)
                            }
                    }
                }
                .frame(width: geometry.size.width * firstColumnWidth)
                Divider()
                    .onHover { inside in
                        if (inside) {
                            NSCursor.resizeLeftRight.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let dragAmount = value.translation.width
                                let totalWidth = geometry.size.width
                                let newFirstColumnWidth = firstColumnWidth + dragAmount / totalWidth
                                let minColumnWidth: CGFloat = 0.1 // Largeur minimale de la première colonne
                                let maxColumnWidth: CGFloat = 0.8 // Largeur maximale de la première colonne
                                firstColumnWidth = max(min(newFirstColumnWidth, maxColumnWidth), minColumnWidth)
                            }
                    )
                VStack {
                    Text("Liste des conteneurs avec leurs status et les actions possibles\n sous forme de cards")
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
    
    private func toggleConnection(for config: Config) -> Void{
        if let index = configs.firstIndex(where: { $0.id == config.id }) {
            configs[index].connected.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
