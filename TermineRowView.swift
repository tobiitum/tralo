//
//  TermineRowView.swift
//  tralo
//
//  Created by Tobias Klingenberg on 17.08.22.
//

import SwiftUI

struct TermineRowView: View {
    var termin: Termin
    var body: some View {
        HStack(spacing: 15){
            Spacer()
            Image(systemName: "arrowtriangle.up")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 15, height: 15)
            Spacer()
            VStack(alignment: .leading, spacing: 8, content: {
                Text(termin.text)
                    
                Text(termin.date)
                    .foregroundColor(.gray)
                
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
            },
                   label: {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
                    .padding()
            })
            .padding(.trailing)
            Button(action: {
            },
                   label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
                    .padding()
                    //.background(Color(.gray).opacity(0.2))
                    //.clipShape(Circle())
            })
            
            .padding(.trailing)
            
            .frame(width: 20, height: 20)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct TermineRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
