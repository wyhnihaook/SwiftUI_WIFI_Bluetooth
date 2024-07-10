//
//  MindMapView.swift
//  you
//  思维导图绘制线路【通过Path绘制出对应的展示内容】- 大前提：计算每个固定宽度的文本的高度用来定位
//  根据当前的内容初始化计算所有内容的高度
//  静态数据的构建，处理当前绘制的内容
//  1.首先根据数据源进行分类，长度/2 取整进行进行中心数据位置的确定

//  2.固定宽度之后对每一个文本的高度进行计算，放入一个数组中对应的数据源内容

//  创建数据源结构等待数据源加载同步变更

//  3.Path高度+上下间距+文本高度 得出顶部间距内容绘制的关键字内容

//  4.从中心数据为节点向上和向下绘制视图

//  5.绘制关键字内容部分
//  Created by 翁益亨 on 2024/7/9.
//

import SwiftUI

//文本基础信息，占用的宽度和高度
struct MindMapTextSize{
    //存储的文本，用来匹配对应的内容，主要应对外部遍历不一致的问题
    let text : String
    var occupyWidth : Double
    var occupyHeight : Double
}

struct MindMapPathView : View{
    //每一个横线结束后的间距高度
    let mindMapSpacing = 10.0
    
    //连接线的过渡宽度
    let transitionWidth = 80.0

    //获取屏幕宽度的1/2作为文本显示的最大宽度，通过GeometryReader获取
    
    //mock数据
    let contentList : [String]
    let title : String
    let centerIndex : Int
    
    //当前的关键字的高度
    @State var maxHeight : Double = 0.0
    //关键字文本宽度
    @Binding var keywordsTextSize : MindMapTextSize
    
    //列表文本高度计算获取
    //文本占用的宽度和高度
    @Binding var textSizeList : [MindMapTextSize]
    @Binding var pathHeightList : [Double]
    
    
    var body: some View{
        //使用GeometryReader获取当前View的可绘制的宽度尺寸
        GeometryReader{ gp in
            let maxContentWidth = gp.size.width/2
            
            ZStack(alignment:.topLeading){
                //背景通过Path绘制对应的线路
                Group{
                    //第一条线
                    Path{path in
                        //移动到容器的左边竖直中心位置
                        path.move(to: CGPoint(x:0,y:gp.size.height/2))
                        //首先绘制横线数据内容
                        path.addLine(to: CGPoint(x:gp.size.width/4,y:gp.size.height/2))
                    }.stroke(.blue, lineWidth: 1)
                    
                    //空心的连接圆形，从上一个Path的截止位置开始进行
                    Path{path in
                        //移动到容器的左边竖直中心位置.这里的width和height是总的尺寸，偏移的为半斤
                        let circleCenter = CGPoint(x:gp.size.width/4 + 4,y:gp.size.height/2)
                        path.addEllipse(in: CGRect(x:circleCenter.x - 4, y:circleCenter.y - 4,width:8,height: 8))
                    }.stroke(.blue, lineWidth: 1)
                    
                    //文本内容所有都通过偏移量来设置
                    //总结内容。限制一行显示完毕.文本显示是坐标y轴下面才开始显示，所以这里要减去显示文本的高度。这里涵盖间距设定 - 12
                    Text(title)
                        .modifier(MindMapTextStyle())
                        .lineLimit(1)
                        .frame(maxWidth:gp.size.width/4,alignment:.topLeading)
                        .padding(.horizontal, 2)
                        .offset(x:0,y:gp.size.height/2 - 12)
                    
                    //这里需要根据当前传递的参数分析，有多少条数据并且每一条计算的高度为多少来预留位置
                    //目前固定写死
                    
                    let startPoint = CGPoint(x:gp.size.width/4,y:gp.size.height/2)

                    
                    //开始绘制中心位置的内容
                    Path{path in
                        path.move(to: startPoint)
                        path.addLine(to: CGPoint(x:startPoint.x + textSizeList[centerIndex].occupyWidth + transitionWidth,y:startPoint.y))
                    }.stroke(.blue, lineWidth: 1)
                    
                    TextSizeView(maxWidth: maxContentWidth, text: contentList[centerIndex])
                        .offset(x:startPoint.x + transitionWidth,
                                y:startPoint.y - textSizeList[centerIndex].occupyHeight - 2)
                    
                    //遍历绘制上方的内容
                    ForEach(0..<centerIndex,id:\.self){ index in
                        let width = transitionWidth
                        //这里的高度要是后面那个角标的高度，因为要根据下一个数据被撑高
                        //这里的height 需要【累加】进行显示。0的位置是最上面的，centerIndex - 1的位置是在中心点的上面，所以这里也要有一个遍历获取累加数据
                        let height = pathHeightList[index]
        
                        //终点
                        let endPoint = CGPoint(x: Int(gp.size.width)/4 + Int(width), y: Int(gp.size.height)/2 - Int(height))
                        
                        Path{path in
                            path.move(to: startPoint)
                            //控制点，基本是中心位置
                            let controlPoint1 = CGPoint(x:Int(startPoint.x) + Int(width)/3, y: Int(startPoint.y))

                            let controlPoint2 = CGPoint(x:Int(startPoint.x) + Int(width)/2, y: Int(startPoint.y) - Int(height))

                            path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)


                        }.stroke(.blue, lineWidth: 1)
                        
                        //连接上述的截止位置到文案显示的宽度，使用直线连接即可
                        Path{path in
                            path.move(to: endPoint)
                            path.addLine(to: CGPoint(x:endPoint.x + textSizeList[index].occupyWidth,y:endPoint.y))
                        }.stroke(.red, lineWidth: 1)
                        
                        TextSizeView(maxWidth: maxContentWidth, text: contentList[index])
                        //偏移量设置，在绘制过渡后进行展示。要对对应的位置上偏移文本的高度
                            .offset(x:startPoint.x + width,
                                    y:endPoint.y - textSizeList[index].occupyHeight)
                    }
                    
                    
                    //遍历绘制下方的内容
                    ForEach((centerIndex + 1)..<contentList.count,id:\.self){ index in
                        let width = transitionWidth
                        let height = pathHeightList[index]
                        //终点
                        let endPoint = CGPoint(x: Int(gp.size.width)/4 + Int(width), y: Int(gp.size.height)/2 + Int(height))
                        
                        Path{path in
                            path.move(to: startPoint)
                            //控制点，基本是中心位置
                            let controlPoint1 = CGPoint(x:Int(startPoint.x) + Int(width)/3, y: Int(startPoint.y))

                            //超下曲线设置使用 + 增加y轴。屏幕左上角为坐标(0,0)向右和向下都是增加 +
                            let controlPoint2 = CGPoint(x:Int(startPoint.x) + Int(width)/2, y: Int(startPoint.y) + Int(height))

                            path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)


                        }.stroke(.blue, lineWidth: 1)
                        
                        //连接上述的截止位置到文案显示的宽度，使用直线连接即可
                        Path{path in
                            path.move(to: endPoint)
                            path.addLine(to: CGPoint(x:endPoint.x + textSizeList[index].occupyWidth,y:endPoint.y))
                        }.stroke(.red, lineWidth: 1)
                        
                        TextSizeView(maxWidth: maxContentWidth, text: contentList[index])
                            .offset(x:startPoint.x + width ,
                                    y:endPoint.y - textSizeList[index].occupyHeight)
                    }
                    
                    //绘制关键字相关信息
                    //绘制关键字节点内容
                    let width = transitionWidth
                    //这里的高度要是后面那个角标的高度，因为要根据下一个数据被撑高
                    let height = maxHeight
                    //终点
                    let endPoint = CGPoint(x: Int(gp.size.width)/4 + Int(width), y: Int(gp.size.height)/2 - Int(height))
                    Path{path in
                        path.move(to: startPoint)
                        //控制点，基本是中心位置
                        let controlPoint1 = CGPoint(x:Int(startPoint.x) + Int(width)/3, y: Int(startPoint.y))

                        let controlPoint2 = CGPoint(x:Int(startPoint.x) + Int(width)/2, y: Int(startPoint.y) - Int(height))

                        path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)


                    }.stroke(.blue, lineWidth: 1)
                    
                    //以下超出了Group组件上限，再包一层即可避免内容过多报错
                    Group{
                        let circleCenter = CGPoint(x:endPoint.x + 4, y: endPoint.y)
                        //圆形结束的位置
                        let circleEndX = circleCenter.x + 4
                        //绘制关键字节点圆圈
                        Path{path in
                            //移动到容器的左边竖直中心位置.这里的width和height是总的尺寸，偏移的为了拼接到曲线上
                            path.addEllipse(in: CGRect(x:circleCenter.x - 4, y:circleCenter.y - 4,width:8,height: 8))
                        }.stroke(.blue, lineWidth: 1)
                        
                        //连接上述的截止位置到文案显示的宽度，使用直线连接即可
                        let keywordsEndPoint = CGPoint(x:circleEndX,y:circleCenter.y)
                        Path{path in
                            //需要移动到圆形的位置上
                            path.move(to: keywordsEndPoint)
                            path.addLine(to: CGPoint(x:keywordsEndPoint.x + keywordsTextSize.occupyWidth,y:keywordsEndPoint.y))
                        }.stroke(.red, lineWidth: 1)
                        
                        TextSizeView(maxWidth: maxContentWidth, text: keywordsTextSize.text)
                            .offset(x:keywordsEndPoint.x,
                                    y:keywordsEndPoint.y - keywordsTextSize.occupyHeight - 2)
                    }
                }
                
            }
        }.onAppear{
            maxHeight = 0.0
            //计算MaxHeight，只需要计算上半部分即可
            for index in 0...centerIndex{
                maxHeight += (textSizeList[index].occupyHeight + mindMapSpacing)
            }
            
            //计算path的累加高度
        }
    }

}
