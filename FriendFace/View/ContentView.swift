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
                    
                    Button {
                        encodeUser()
                    } label: {
                        VStack {
                            Text("Encode User")
                        }
                        .tint(.primary)
                        .padding()
                        .background(.mainBackgroundColor)
                        .clipShape(.rect(cornerRadius: 25))
                        .shadow(color: .black.opacity(0.3), radius: 7)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add User", systemImage: "plus.circle") {
                        let user = User(id: UUID(), isActive: false, name: "John Cena", age: 35, company: "WWE", email: "ucantcme@wwe.com", address: "Mojo Dojo House", about: "Wrestler", tags: ["shred"], friends: [Friend(id: UUID(), name: "The Rock")])
                        
                        modelContext.insert(user)
                    }
                }
            }
        }
    }
    
//    func deleteUser(for indexSet: IndexSet) {
//        for index in indexSet {
//            let user = users[index]
//            modelContext.delete(user)
//        }
//    }
    
    func encodeUser() {
        let jsonString = """
            {
                    "id": "eccdf4b8-c9f6-4eeb-8832-28027eb70155",
                    "isActive": true,
                    "name": "Gale Dyer",
                    "age": 28,
                    "company": "Cemention",
                    "email": "galedyer@cemention.com",
                    "address": "652 Gatling Place, Kieler, Arizona, 1705",
                    "about": "Laboris ut dolore ullamco officia mollit reprehenderit qui eiusmod anim cillum qui ipsum esse reprehenderit. Deserunt quis consequat ut ex officia aliqua nostrud fugiat Lorem voluptate sunt consequat. Sint exercitation Lorem irure aliquip duis eiusmod enim. Excepteur non deserunt id eiusmod quis ipsum et consequat proident nulla cupidatat tempor aute. Aliquip amet in ut ad ullamco. Eiusmod anim anim officia magna qui exercitation incididunt eu eiusmod irure officia aute enim.",
                    "registered": "2014-07-05T04:25:04-01:00",
                    "tags": [
                        "irure",
                        "labore",
                        "et",
                        "sint",
                        "velit",
                        "mollit",
                        "et"
                    ],
                    "friends": [
                        {
                            "id": "1c18ccf0-2647-497b-b7b4-119f982e6292",
                            "name": "Daisy Bond"
                        },
                        {
                            "id": "a1ef63f3-0eab-49a8-a13a-e538f6d1c4f9",
                            "name": "Tanya Roberson"
                        }
                    ]
                }
        """
        
        if let jsonData = jsonString.data(using: .utf8) {
            if let decodedUser = try? JSONDecoder().decode(User.self, from: jsonData) {
                modelContext.insert(decodedUser)
            }
        }
    }
}

#Preview {
    ContentView()
}
