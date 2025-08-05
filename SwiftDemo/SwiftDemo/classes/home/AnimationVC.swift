//
//  AnimationVC.swift
//  SwiftDemo
//
//  Created by app on 2024/12/12.
//

import Foundation
import UIKit
import DGCharts
class AnimationVC: BaseViewController {
    private var candleChartView: CandleStickChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupChartView()
        setData()
    }
    
    func setupChartView(){
        candleChartView = CandleStickChartView(frame: self.view.bounds)
        candleChartView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(candleChartView)
        // 配置图表样式
        candleChartView.chartDescription.enabled = false
        candleChartView.dragEnabled = true
        candleChartView.setScaleEnabled(true)
        candleChartView.pinchZoomEnabled = true
        
        // X轴样式
        let xAxis = candleChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        
        // 左Y轴样式
        let leftAxis = candleChartView.leftAxis
        leftAxis.drawGridLinesEnabled = false
        leftAxis.labelCount = 5
        
        // 右Y轴样式
        candleChartView.rightAxis.enabled = false
    }
    private func setData(){
        // 示例数据
        let entries = [
            CandleChartDataEntry(x: 1, shadowH: 120, shadowL: 100, open: 110, close: 115),
            CandleChartDataEntry(x: 2, shadowH: 125, shadowL: 105, open: 115, close: 120),
            CandleChartDataEntry(x: 3, shadowH: 130, shadowL: 110, open: 120, close: 125),
            CandleChartDataEntry(x: 4, shadowH: 135, shadowL: 115, open: 125, close: 130),
        ]
        
        let set = CandleChartDataSet(entries: entries, label: "K Line Data")
        set.axisDependency = .left
        set.setColor(.black) // 蜡烛线颜色
        set.shadowColor = .gray // 上下影线颜色
        set.shadowWidth = 0.7
        set.decreasingColor = .red // 下跌颜色
        set.decreasingFilled = true
        set.increasingColor = .green // 上涨颜色
        set.increasingFilled = true
        set.neutralColor = .blue // 无涨跌颜色 
        
        let data = CandleChartData(dataSet: set)
        candleChartView.data = data
    }
}
