//
//  ContentView.swift
//  tralo
//
//  Created by Tobias Klingenberg on 15.08.22.
//

import SwiftUI
import AuthenticationServices
import MapKit
import UIKit
import SelectableCalendarView

//Blured Tab Bar (not working yet)
class TabBarController:UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tabBar.addSubview(blurView)

    }

}
//SideMenu Background
struct SideMenu: View{
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View{
        ZStack {
             //Dimmed BG
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.45))
            .opacity(self.menuOpened ? 1 : 0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.toggleMenu()
            }
             //Menu
            HStack{
                MenuContent()
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default )
                Spacer()
            }
        }
    }
}
//SideMenuItemSettings
struct MenuItem: Identifiable{
    var id = UUID()
    let text: String
    let handler: () -> Void = {
        print("success")
    }
}
//SideMenu Content
struct MenuContent: View{
    let items: [MenuItem] = [
        MenuItem(text: "Home"),
        MenuItem(text: "Tags"),
        MenuItem(text: "Categories"),
        MenuItem(text: "Settings"),
        MenuItem(text: "Logout"),
    ]
    var body: some View{
        ZStack {
            Color(UIColor.systemBackground)
            
            VStack(alignment: .leading, spacing: 0){
                HStack {
                    
                    
                }
                ForEach(items) { item in
                    HStack{
                        Text(item.text)
                            .bold()
                            .font(.system(size: 22))
                            .multilineTextAlignment(.leading)
                            .offset(x: 50)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        
                    }
                    .padding()
                    
                }
                
                Spacer()
            }
            .padding(.top, 90)
        }
    }
}
//Home Screen
struct HomeView: View {
    @State var searchQuery = ""
    @State var menuOpened = false
    @State var offset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    @State var titleOffset: CGFloat = 0
    @State var titleOpac: CGFloat = 0
    @State var titleBarHeight: CGFloat = 0
    @Environment(\.colorScheme) var scheme
    
    var body: some View{
        ZStack{
            ZStack(alignment: .top){
                
                VStack{
                    if searchQuery == "" {
                        HStack{
                            Button(action: {
                                self.menuOpened.toggle()
                            }, label: {Image(systemName: "line.3.horizontal")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            })
                            Spacer()
                            Text("TRALO")
                                .font(.custom(FontManager.Demode.regular, size: 40))
                                .opacity(getOpac())
                            Spacer()
                            
                            Button(action: {}, label: {Image(systemName: "person")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                            })
                        }
                        .padding()
                        
                        HStack{
                            Spacer()
                                .frame(width: 20)
                            Text("Coming up")
                                .fontWeight(.medium)
                                .font(.title2)
                                .overlay(
                                    GeometryReader{reader -> Color in
                                        let width = reader.frame(in: .global).maxX
                                        DispatchQueue.main.async {
                                            if titleOffset == 0{
                                                titleOffset = width
                                            }
                                            if titleOpac == 1{
                                                titleOpac = width
                                            }
                                        }
                                        return Color.clear
                                    }
                                        .frame(width: 0, height: 0)
                                )
                                .padding()
                                .scaleEffect(getScale())
                                .offset(getOffset())
                            Spacer()
                        }
                    }
                    //SearchBar
                    VStack{
                        HStack(spacing: 15){
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 23, weight: .light))
                                .foregroundColor(.gray)
                            
                            TextField("Search", text: $searchQuery)
                            Spacer()
                            if searchQuery == ""{}
                            else{Button(action: {
                                searchQuery = ""
                            }, label: {Image(systemName: "xmark.circle")
                                    .font(.system(size: 18, weight: .light))
                                    .foregroundColor(.gray)

                            })}
                            
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color.primary.opacity(0.05))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        if searchQuery == "" {
                            HStack{
                               Rectangle()
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(height: 0.5)
                            }
                            .padding()
                            
                        }
                    }
                    .offset(y: offset > 0 && searchQuery == "" ? (offset <= 85 ? -offset : -85) : 0)
                }
                .zIndex(1)
                .padding(.bottom,searchQuery == "" ? getOffset().height : 0)
                .background(
                    ZStack{
                        let color = scheme == .dark ? Color.black : Color.white
                        LinearGradient(gradient: .init(colors: [color,color,color,color,color.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    }
                        .ignoresSafeArea()
                )
                .overlay(
                    GeometryReader{reader -> Color in

                        let height = reader.frame(in: .global).maxY
                        DispatchQueue.main.async {
                            if titleBarHeight == 0{
                                titleBarHeight = height - (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                            }
                        }
                        return Color.clear
                    }
                
            
            )
                .animation(.easeInOut, value: searchQuery != "")
                
                ScrollView(.vertical, showsIndicators: true, content: {
                    VStack(spacing: 15){
                        //Home Feed
                        ForEach(searchQuery == "" ? termine :  termine.filter{$0.text.lowercased().contains(searchQuery.lowercased())}){termin in
                            //Tabelle
                            TermineRowView(termin: termin)
                        }
                        
                    }
                    .padding(.top,10)
                    .padding(.top,searchQuery == "" ? titleBarHeight : 90)
                    .overlay(
                        GeometryReader{proxy -> Color in
                            
                            let minY = proxy.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                if startOffset == 0{
                                    startOffset = minY
                                    
                                }
                                offset = startOffset - minY
                                print(offset)
                            }
                            
                            print(minY)
                            
                            return Color.clear
                            
                        }
                            .frame(width: 0, height: 0)
                        ,alignment: .top
                    )
                    
                })
                
                }
            SideMenu(width: UIScreen.main.bounds.width/1.8, menuOpened: menuOpened, toggleMenu: toggleMenu)
                .edgesIgnoringSafeArea(.all)
        }
        
    }
    func getOffset()->CGSize{
        var size: CGSize = .zero
        
        let screenWidth = UIScreen.main.bounds.width / 2
        size.width = offset > 0 ? (offset * 1.5 <= (screenWidth - titleOffset) ? offset * 1.5 : (screenWidth - titleOffset)) : 0
        size.height = offset > 0 ? (offset <= 85 ? -offset : -85) : 0
        return size
        
    }
    func getOpac()->CGFloat{
        var opacity: CGFloat = .zero
        opacity =  1-(offset * 0.02)
        return opacity
    }
    func getScale()->CGFloat{
        if offset > 0{
            let screenWidth = UIScreen.main.bounds.width
            
            let progress = 1 - (getOffset().width / screenWidth)
            
            return progress >= 0.9 ? progress : 0.9
        }
        else{
            return 1
        }
    }
    func toggleMenu(){
        menuOpened.toggle()
    }
}
//Map Screen
struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.13743, longitude: 11.57549), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var body: some View{
        
            VStack{
                
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .ignoresSafeArea()
            }
        }
    }
//Calendar View
struct CalendarView: View {
    @State private var dateSelected: Date = Date()
    var body: some View{
        NavigationView{
            VStack{
                Text("Placeholder")
                    .padding(.top)
                HStack{
                    Menu("View >") {
                        Text("Daily")
                        Text("Weekly")
                        Text("Monthly")
                    }
                    .padding()
                    Spacer()
                }
                SelectableCalendarView(monthToDisplay: Date(), dateSelected: $dateSelected)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}
//Account Screen
struct AccountView: View {
    var body: some View{
        NavigationView{
            VStack{
                
           
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}
//Settings Screen
struct SettingsView: View {
    var body: some View{
        NavigationView{
            ScrollView(.vertical, showsIndicators: true, content: {
                Spacer()
                    .frame(height:50)
                VStack{
                HStack {
                    NavigationLink(destination: GeneralView()){
                        
                             Text("General")
                                .foregroundColor(Color.gray)
                                .padding(.vertical,10)
                               .frame(maxWidth: 300)
                                .padding(.horizontal)
                                .background(Color.primary.opacity(0.05))
                                .cornerRadius(8)
                    }
                }
                .padding(.bottom)
                NavigationLink(destination: AccountView()){
                     Text("Account")
                        .foregroundColor(Color.gray)
                        .padding(.vertical,10)
                        .frame(maxWidth: 300)
                        .padding(.horizontal)
                        .background(Color.primary.opacity(0.05))
                        .cornerRadius(8)
            }
                    Rectangle()
                         .fill(Color.gray.opacity(0.6))
                         .frame(height: 0.5)
                         .padding()

                NavigationLink(destination: AboutView()){
                     Text("About")
                        .foregroundColor(Color.gray)
                        .padding(.vertical,10)
                        .frame(maxWidth: 300)
                        .padding(.horizontal)
                        .background(Color.primary.opacity(0.05))
                        .cornerRadius(8)
                      
            }
                
                
            }
})
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}
struct GeneralView: View {
    var body: some View{
        Text("Placeholder")
        Text("Settings")
    }
    
}
struct AboutView: View {
    var body: some View{
        
        VStack{
            
            Text("About")
                .fontWeight(.bold)
            Spacer()
                .frame(height: 60)
            Text("Copyright 2022 Tobias Klingenberg")
                .padding(.bottom, -5.0)
            Text("[tbkl.me / tbkl.dev](https://tbkl.me)")
                .padding(.bottom, -5.0)
            Text("[GitHub](https://github.com/tobiitum)")
            Spacer()
                .frame(height: 60)
            HStack{
                Text("UI Inspiration from")
                Text("[Kavsoft](https://www.youtube.com/c/Kavsoft)")
            }
            HStack{
                Text("Font")
                Text("[Demode](https://www.creativefabrica.com/designer/vladimirnikolic/)")
            }
            HStack{
                Text("Calendar Design from")
                Text("[mszpro](https://github.com/mszpro)")
            }
            Spacer()
                .frame(height: 200)
        }
        
    }
    
}

//Tab Bar
struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
        
    }
        
    var body: some View {
        TabView(selection: .constant(1)) {
            HomeView()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house")
                }
                .tag(1)
            //MapView()
            CalendarView()
                .tabItem {
                    Text("Calendar")
                    Image(systemName: "calendar")
                }
                .tag(2)
            MapView()
                .tabItem {
                    Text("Map")
                    Image(systemName: "map.fill")
                }
                .tag(3)
            SettingsView()
                .tabItem {
                    Text("Settings")
                    Image(systemName: "gear")
                }
                .tag(4)
        }
                
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
