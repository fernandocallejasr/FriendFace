//
//  ContentView.swift
//  FriendFace
//
//  Created by Fernando Callejas on 15/08/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var path = NavigationPath()
    @Query private var users: [User]
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(.mainBackgroundColor)
                    .ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        ForEach(users, id: \.id) { user in
                            NavigationLink(value: user) {
                                UserBadgeView(user: user)
                            }
                            .tint(.primary)
                        }
                    }
                    
                    Button {
                        Task {
                            do {
                                try await retrieveUsers()
                            } catch {
                                print("Error retrieving users: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        VStack {
                            Text("Retrieve Users")
                        }
                        .tint(.primary)
                        .padding()
                        .background(.mainBackgroundColor)
                        .clipShape(.rect(cornerRadius: 25))
                        .shadow(color: .black.opacity(0.3), radius: 7)
                    }
                    .padding(.bottom)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Delete User", systemImage: "trash") {
                        print("Delete Users")
                        try! modelContext.delete(model: User.self)
                    }
                }
            }
            .navigationDestination(for: User.self) { selectedUser in
                UserDetailView(userId: selectedUser.id)
            }
        }
    }
    
    struct UserBadgeView: View {
        let user: User
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(user.isActive ? "Online" : "Offline")
                    Text("\(user.age) years")
                }
                .font(.caption2)
                
                Spacer()
                
                VStack {
                    HStack {
                        Image(systemName: "case")
                        
                        Text(user.company)
                            .font(.caption2)
                            .fontWeight(.regular)
                    }
                    
                    Spacer()
                }
            }
            .frame(width: 220, height: 60)
            .padding()
            .background(.mainBackgroundColor)
            .clipShape(.rect(cornerRadius: 25))
            .shadow(color: .black.opacity(0.2), radius: 10)
            .frame(maxWidth: .infinity)
        }
    }
    
    func retrieveUsers() async throws {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            fatalError("Error createing URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decodedUsers = try JSONDecoder().decode([User].self, from: data)
        
        for decodedUser in decodedUsers {
            modelContext.insert(decodedUser)
        }
    }
}

#Preview {
    ContentView()
}
