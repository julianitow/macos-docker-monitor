//
//  ContentView.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 24/06/2023.
//

import SwiftUI

struct ContentView: View {
    @State var configs = ConfigParserService.fetchConfigs()
    @State var selectedConfig: Config?
    
    @State private var firstColumnWidth: CGFloat = 0.2
    @State private var dragOffset: CGFloat = 0.0
    
    @State private var isCardOpened = false
    @State private var openedCardIndex = 0
            
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 0) {
                VStack { // config list
                    Button(action: addConfig) {
                            Label("Add config", systemImage: "folder.badge.plus")
                    }
                    .padding()
                    Divider()
                    ScrollView(.vertical) {
                        VStack (spacing: 5) {
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
                        .frame(width: geometry.size.width)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
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
                GeometryReader { rightGeometry in
                    let spacing: CGFloat = 1 // Espacement entre les éléments
                    ScrollView([.horizontal, .vertical]) {
                        if selectedConfig != nil {
                            if selectedConfig!.isConnected {
                                let rows = 5
                                @State var columns = ((selectedConfig?.containers.count)! + rows - 1) / rows
                                VStack {
                                    ForEach(0..<rows) { row in
                                        HStack(spacing: spacing) {
                                            ForEach(0..<columns) { column in
                                                let index = row * columns + column
                                                if index < (selectedConfig?.containers.count)! {
                                                    ContainerCard(config: selectedConfig!, container: (selectedConfig?.containers[index])!)
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                Text("Not connected")
                            }
                        } else {
                            Text("Not connected")
                        }
                    }
                }
            }
        }
    }
    
    private func getContainerCardIndex(row: Int, column: Int, rows: Int) -> Int? {
        if selectedConfig == nil {
            return nil
        }
        let index = column * rows + row
        return index
    }
    
    private func addConfig() -> Void {
        // TODO: display a window to add a ne config
        print("WIP")
    }
    
    private func toggleCardOpened(for index: Int) {
        if !isCardOpened {
            openedCardIndex = index
        }
        isCardOpened.toggle()
    }
    
    private func toggleSelection(for config: Config) -> Void {
        self.selectedConfig?.containers = []
        for i in 0..<configs.count {
            if config.id == configs[i].id {
                configs[i].isSelected.toggle()
                self.selectedConfig = configs[i]
                print(self.selectedConfig?.containers.count)
            } else {
                configs[i].isSelected = false
            }
        }
    }
    
    private func toggleConnection(for config: Config) -> Void {
        if let index = configs.firstIndex(where: { $0.id == config.id }) {
            if connect(to: config) {
                let containers = SSHService.fetchContainers(of: config)
                configs[index].containers = containers!
                configs[index].isConnected.toggle()
                self.toggleSelection(for: configs[index])
            }
        }
    }
    
    private func connect(to config: Config) -> Bool {
        return SSHService.connect(to: config)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
