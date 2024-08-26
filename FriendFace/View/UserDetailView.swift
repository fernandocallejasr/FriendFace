//
//  UserDetailView.swift
//  FriendFace
//
//  Created by Fernando Callejas on 17/08/24.
//

import SwiftData
import SwiftUI

struct UserDetailView: View {
    @Environment(\.modelContext) var modelContext
    
//    @Bindable var user: User
    @Query var users: [User]
    
    init(userId: UUID) {
        print("User id: \(userId.uuidString)")
        
        _users = Query(filter: #Predicate<User> { user in
            user.id == userId
        })
    }
    
    
    var body: some View {
        let user = users[0]
        
            ZStack {
                Color.mainBackgroundColor
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(user.name)
                                    .font(.largeTitle)
                                
                                Spacer()
                                
                                Image(systemName: "case")
                                Text(user.company)
                            }
                            
                            Text("\(user.age) years")
                                .font(.title3)
                                .padding(.top, 1)
                            
                            Text(user.isActive ? "Online" : "Offline")
                            
                            HStack {
                                Image(systemName: "envelope")
                                    .font(.subheadline)
                                Text(user.email)
                            }
                            
                            Image(systemName: "house.circle")
                                .font(.title3)
                                .padding(.top, 10)
                            ForEach(user.address.split(separator: ","), id: \.self) { addressItem in
                                Text(addressItem.replacing(" ", with: ""))
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Joined")
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("\(user.registered.formatted(date: .abbreviated, time: .omitted))")
                                }
                            }
                            .padding(.top, 20)
                        }
                    }
                    
                    Text("About")
                        .padding(.top, 20)
                    Rectangle()
                        .frame(height: 1)
                        .padding(.bottom, 10)
                    
//                  About Information
                    ScrollView(showsIndicators: false) {
                        Text(user.about)
                        
//                      Friends
                        HStack {
                            Text("Friends")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.top, 10)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(user.friends, id: \.id) { friend in
                                    
                                    NavigationLink(value: friend) {
                                        UserProfileFriendBadge(userId: friend.id)
                                    }
                                    .tint(.primary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationDestination(for: Friend.self) { friend in
                UserDetailView(userId: friend.id)
            }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: User.self, configurations: config)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        
        guard let userDate = dateFormatter.date(from: "2015-11-10T01:47:18-00:00") else {
            fatalError("Error formatting date")
        }
        
        let user = User(id: UUID(), isActive: false, name: "John Cena", age: 35, company: "WWE", email: "ucantcme@wwe.com", address: "907 Nelson Street, Cotopaxi, South Dakota, 5913", about: "Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi. Eu ullamco cillum ex nostrud fugiat eu consequat enim cupidatat. Non incididunt fugiat cupidatat reprehenderit nostrud eiusmod eu sit minim do amet qui cupidatat. Elit aliquip nisi ea veniam proident dolore exercitation irure est deserunt.", registered: userDate, tags: ["shred"], friends: [Friend(id: UUID(uuidString: "eccdf4b8-c9f6-4eeb-8832-28027eb70155")!, name: "The Rock")])
        
        return UserDetailView(userId: user.id)
            .modelContainer(modelContainer)
    } catch {
        return Text("Error creating container: \(error.localizedDescription)")
    }
}
