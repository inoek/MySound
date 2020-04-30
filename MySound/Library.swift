//
//  Library.swift
//  MySound
//
//  Created by Игорь Ноек on 29.04.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import SwiftUI

struct Library: View {
    var body: some View {
        NavigationView {
            VStack {
                //устанавливаем геометрию кнопок
                GeometryReader { geometry in
                    
                    
                    HStack(spacing: 20) {
                        
                        Button(action: {
                            print("Button tapped...")
                            
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9187020659, green: 0.9132409096, blue: 0.9229000211, alpha: 1)))
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            print("Second button tapped...")
                            
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.9098039216, green: 0.2705882353, blue: 0.3529411765, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.9187020659, green: 0.9132409096, blue: 0.9229000211, alpha: 1)))
                                .cornerRadius(10)
                        })
                    }
                    
                }.padding().frame(height: 50)//отступы от краёв, высота 50 поинтов
                Divider().padding(.leading).padding(.trailing)//сепаратор с отступами слева и справа
                
                List {
                    LibraryCell()
                    Text("First")
                    Text("Second")
                }
            }
            .navigationBarTitle("Библиотека")
        }
    }
}



struct LibraryCell: View {
    var body: some View {

        HStack {
            Image("Image").resizable().frame(width: 60, height: 60)
            
            VStack {
                Text("Название трека")
                Text("Имя автора")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
