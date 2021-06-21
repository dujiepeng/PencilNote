//
//  ContentView.swift
//  PencilNote
//
//  Created by 杜洁鹏 on 2021/6/21.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    
    var body: some View {
        Home()
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .previewDevice("iPad Air (4th generation)")
//    }
//}


struct Home : View {
    
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var color : Color = .black
    @State var type : PKInkingTool.InkType = .pencil
    @State var colorPicker = false
    
    var body: some View {
        NavigationView{
            DrawingView(canvas: $canvas, isDraw: $isDraw, type: $type, color: $color)
                .navigationTitle("Drawing")
                .navigationBarTitleDisplayMode(.automatic)
                .navigationBarItems(
                    leading:
                        Button(
                            action: {
                                SaveImage()
                            },
                            label: {
                                Image(systemName: "square.and.arrow.down.fill")
                                    .font(.title)
                            }
                        ),
                    trailing:
                        HStack(
                            alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                            spacing: 15,
                            content: {
                                Button(
                                    action: {
                                        isDraw = false
                                    },
                                    label: {
                                        Image(systemName: "pencil.slash")
                                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    }
                                )
                                
                                Menu {
                                    Button(action: {
                                        colorPicker.toggle()
                                    }){
                                        Label{
                                            Text("Color")
                                        } icon: {
                                            Image(systemName: "eyedropper.full")
                                        }
                                    }
                                    Button(action: {
                                        isDraw = true
                                        type = .pencil
                                    }){
                                        Label{ Text("Pencil")} icon: {
                                            Image(systemName: "pencil")
                                        }
                                    }
                                    
                                    Button(action: {
                                        isDraw = true
                                        type = .pen
                                    }){
                                        Label{ Text("Pen")} icon: {
                                            Image(systemName: "pencil.tip")
                                        }
                                    }
                                    
                                    Button(action: {
                                        isDraw = true
                                        type = .marker
                                    }){
                                        Label{ Text("Marker")} icon: {
                                            Image(systemName: "highlighter")
                                        }
                                    }
                                } label: {
                                    Image(systemName: "highlighter").resizable().frame(width: 22, height: 22)
                                }
                            }
                        ).sheet(isPresented: $colorPicker){
                            ColorPicker("Pick Color", selection: $color).padding()
                        }
                )
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func SaveImage(){
        
//        let image = canvas.drawing.image(from: canvas.drawing.bounds, scale: 1)
        let image = canvas.drawing.image(from: canvas.bounds, scale: 1)
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct DrawingView : UIViewRepresentable {
    
    @Binding var canvas : PKCanvasView
    @Binding var isDraw : Bool
    @Binding var type : PKInkingTool.InkType
    @Binding var color : Color
    
    var ink : PKInkingTool{
        PKInkingTool(type, color: UIColor(color))
    }
    let eraser = PKEraserTool(.bitmap)
    
    func makeUIView(context: Context) -> some PKCanvasView {
        
        canvas.drawingPolicy = .anyInput
        
        canvas.tool = isDraw ? ink : eraser
        
        return canvas
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.tool = isDraw ? ink : eraser
    }
}
