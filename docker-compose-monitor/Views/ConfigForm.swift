//
//  ConfigForm.swift
//  docker-compose-monitor
//
//  Created by Julien Guillan on 25/06/2023.
//

import SwiftUI

struct ConfigForm: View {
    
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var host: String = ""
    @State private var username: String = ""
    @State private var privateKey: String = ""
    @State private var publicKey: String = ""
    @State private var port: Int = 22
    @State private var canSave = false
    
    var body: some View {
        VStack {
            Text("New configuration")
                .font(.title)
                .padding()
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Host", text: $host)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Text("Private Key")
                
                Spacer()
                
                Button(action: {
                    selectPrivateKey()
                }) {
                    Image(systemName: "folder")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            
            HStack {
                Text("Public Key")
                
                Spacer()
                
                Button(action: {
                    selectPublicKey()
                }) {
                    Image(systemName: "folder")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            
            TextField("Port", value: $port, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save") {
                saveConfiguration()
            }
            .padding()
        }
        .padding()
    }
    
    private func selectPrivateKey() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            guard let url = panel.urls.first else { return }
            privateKey = url.path
        }
    }
    
    private func selectPublicKey() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            guard let url = panel.urls.first else { return }
            publicKey = url.path
        }
    }
    
    private func saveConfiguration() {
        let config = Config(name: name, host: host, username: username, publicKey: publicKey, privateKey: privateKey, containers: [])
        ConfigParserService.addConfig(config: config)
        isPresented = false
    }
}

struct ConfigForm_Previews: PreviewProvider {
    static var previews: some View {
        var _isPresented = false
        var isPresented = Binding { _isPresented } set: { _isPresented = $0 }
        ConfigForm(isPresented: isPresented)
    }
}
