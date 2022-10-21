//
//  Home.swift
//  SwiftUIKavsoft
//
//  Created by Brian Michael on 21/10/2022.
//

import SwiftUI

struct Home: View {
    
    @State private var offset: CGFloat = 0.0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true, content: {
            
            VStack(spacing: 15) {
                // MARK: - HEADER VIEW
                GeometryReader { proxy -> AnyView in
                    // STICKY HEADER
                    let minY = setupStickyHeader(proxy: proxy)
                    return AnyView (
                        BannerView(minY: minY)
                    )
                }
                .frame(height: 180)
                .zIndex(1)
                
                // MARK: - PROFILE IMAGE
                ProfileImageView(offset: offset)
            }
            
        })
        .ignoresSafeArea(.all, edges: .top)
    }
    
    @discardableResult
    private func setupStickyHeader(proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .global).minY
        DispatchQueue.main.async {
            self.offset = minY
        }
        return minY
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// MARK: - BANNER VIEW
struct BannerView: View {
    
    var minY: CGFloat
    
    var body: some View {
        ZStack {
             // BANNER
            Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: getRect().width,
                       height: minY > 0 ? 180 + minY : 180,
                       alignment: .center)
                .cornerRadius(0)
            BlurView()
                .opacity(blurViewOpacity())
            
        }
        // MARK: - Stretchy Header
        .frame(height: minY > 0 ? 180 + minY : nil,
               alignment: .center)
        .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)
    }
    
    //BLUR VIEW
    func blurViewOpacity() -> CGFloat {
        let progress = -(minY + 80) / 150
        return Double(-minY > 80 ? progress : 0)
    }
    
}


// MARK: - PROFILE IMAGE VIEW
struct ProfileImageView: View {
    
    var offset: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                Image("person")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .padding(8)
                    .background(.white)
                    .clipShape(Circle())
                    .offset(y: offset < 0 ? getOffSet() - 20 : -20)
                    .scaleEffect(getScale())
                
                Spacer()
                
                Button {
                    // action
                } label: {
                    Text("Edit Profile")
                        .foregroundColor(.blue)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(
                            Capsule()
                                .stroke(Color.blue, lineWidth: 1.5)
                        )
                }
            }
            .padding(.top, -25)
            .padding(.bottom, -10)
            
            VStack {
                Text("Hi i'm Brian, and my life? My life is kind a crazy.... xD")
                    .font(.body)
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal)
        // move the view back if it goes > 80
        .zIndex(-offset > 80 ? 0 : 1)
    }
    
    // PROFILE SHRIKING EFFECT...
    func getOffSet() -> CGFloat {
        let progress = (-offset / 80) * 20
        return progress <= 20 ? progress : 20
    }
    
    func getScale() -> CGFloat {
        let progress = -offset / 80
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        return scale < 1 ? scale : 1
    }
}


extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}
