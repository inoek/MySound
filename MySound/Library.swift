//
//  Library.swift
//  IMusic
//
//  Created by Алексей Пархоменко on 08/09/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?//делегат таб бак контроллера
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in //геометрия кнопок
                    HStack(spacing: 20) {
                        Button(action: {
                            self.track = self.tracks[0]//выбираем первый трек из массива
                            self.tabBarDelegate?.maximizedTrackDetailController(viewModel: self.track)
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9921568627, green: 0.1764705882, blue: 0.3333333333, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track)
                            .gesture(LongPressGesture()
                                .onEnded({ (_) in
                                    print("Long press")
                                    self.track = track//передаём ячейку в глобальную переменную
                                    self.showAlert = true//вызываем алёрт
                                    
                                })
                                .simultaneously(with: TapGesture()
                                    .onEnded({ (_) in
                                        
                                        let keyWindow = UIApplication.shared.connectedScenes.filter( {
                                            $0.activationState == .foregroundActive
                                        }).map({ $0 as? UIWindowScene }).compactMap({
                                            $0
                                            }).first?.windows.filter({ $0.isKeyWindow }).first
                                        //получаем keyWindow
                                        
                                        let tabbarVC = keyWindow?.rootViewController as? MainTabBarController
                                        tabbarVC?.trackDetailView.delegate = self
                                        //при нажатии на кнопку с окна библиотеки меняется делегат
                                        
                                        self.track = track//передаём ячейку в глобальную переменную
                                        self.tabBarDelegate?.maximizedTrackDetailController(viewModel: self.track)
                                    })))
                        
                    }.onDelete(perform: delete)
                }.actionSheet(isPresented: $showAlert, content: {
                    ActionSheet(title: Text("Уверены, что хотите удалить этот трек?"), buttons: [.destructive(Text("Удалить"), action:  {
                        print("Deleted \(self.track.trackName)")
                        self.delete(track: self.track)
                    }), .cancel()
                    ])
                })
                    
                    .navigationBarTitle("Library")
            }
            
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey )
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey )
        }
    }
    
    struct LibraryCell: View {
        
        var cell: SearchViewModel.Cell
        
        var body: some View {
            HStack {
                URLImage(URL(string: cell.iconUrlString ?? "")!) { proxy in
                    proxy.image
                        .resizable()                     // Make image resizable
                        .clipped()                       // Clip overlaping parts
                }
                    .frame(width: 60, height: 60)  // Set frame to 100x100.
                VStack(alignment: .leading) {
                    Text("\(cell.trackName)")
                    Text("\(cell.artistName)")
                }
            }
            
        }
    }
    
    
    
    struct Library_Previews: PreviewProvider {
        static var previews: some View {
            Library()
        }
    }
}


extension Library: TrackMovingDelegate {
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex - 1 < 0 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[myIndex - 1]
        }
        
        self.track = nextTrack
        return nextTrack
        
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        
        self.track = nextTrack
        return nextTrack
        
    }
    
    
}
