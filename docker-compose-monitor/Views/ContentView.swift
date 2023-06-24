//
//  ContentView.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContentView: View {
    @State var configs = MockedData.fetchConfigs()
    @State var selectedConfig: Config?
    
    @State private var firstColumnWidth: CGFloat = 0.2
    @State private var dragOffset: CGFloat = 0.0
            
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                VStack { // config list
                    ForEach(Array(configs.enumerated()), id: \.element.id) { (index, config) in
                        ConfigCard(config: $configs[index])
                            .gesture(TapGesture(count: 2).onEnded { gesture in
                                toggleConnection(for: config)
                            })
                            .gesture(TapGesture(count: 1).onEnded {
                                toggleSelection(for: config)
                            })
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
                                let minColumnWidth: CGFloat = 0.1
                                let maxColumnWidth: CGFloat = 0.8
                                firstColumnWidth = max(min(newFirstColumnWidth, maxColumnWidth), minColumnWidth)
                            }
                    )
                VStack {
                    if selectedConfig != nil {
                        if selectedConfig!.isConnected {
                            ForEach(selectedConfig!.containers) {container in
                                ContainerCard(container: container)
                            }
                        } else {
                            Text("Not connected")
                        }
                    } else {
                        Text("Not connected")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
    
    private func toggleSelection(for config: Config) -> Void {
        for i in 0..<configs.count {
            if config.id == configs[i].id {
                configs[i].isSelected.toggle()
                self.selectedConfig = configs[i]
            } else {
                configs[i].isSelected = false
            }
        }
    }
    
    private func toggleConnection(for config: Config) -> Void {
        if let index = configs.firstIndex(where: { $0.id == config.id }) {
            configs[index].isConnected.toggle()
            self.toggleSelection(for: configs[index])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
