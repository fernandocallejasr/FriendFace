//
//  UserProfileFriendBadge.swift
//  FriendFace
//
//  Created by Fernando Callejas on 26/08/24.
//

import SwiftData
import SwiftUI

struct UserProfileFriendBadge: View {
    @Query var users: [User]
    
    init(userId: UUID) {
        _users = Query(filter: #Predicate<User> { user in
            user.id == userId
        })
    }
    
    var body: some View {
        let user = users[0]
        
        VStack(alignment: .leading) {
            Text(user.name)
                .font(.headline)
                .fontWeight(.light)
            
            Text("\(user.age) years")
                .font(.caption)
                .fontWeight(.light)
            
            HStack {
                Image(systemName: "case")
                Text(user.company)
            }
            .font(.caption)
        }
        .frame(width: 200, height: 80)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 25))
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let modelContainer = try ModelContainer(for: User.self, configurations: config)
        
        guard let userId = UUID(uuidString: "eccdf4b8-c9f6-4eeb-8832-28027eb70155") else {
            fatalError("User does not exist")
        }
        
        return UserProfileFriendBadge(userId: userId)
            .modelContainer(modelContainer)
    } catch {
        return Text("Error initializing user: \(error.localizedDescription)")
    }
}
