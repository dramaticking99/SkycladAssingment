//
//  PriceChartView.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI
import Charts

struct PriceChartView: View {
    let points: [PricePoint]
    @Binding var selected: PricePoint?

    // MARK: - Formatters (build once)
    private static let df: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMMM"
        return f
    }()
    private static let nf: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_IN")
        f.numberStyle = .currency
        f.currencyCode = "INR"
        return f
    }()

    // MARK: - Backdrop bars
    private var bars: [BackdropBar] {
        BackdropBar.make(from: points, buckets: max(8, points.count / 6))
    }

    // MARK: - Plot geometry
    @State private var plotRect: CGRect = .zero
    private let barGap: CGFloat = 4
    private var barWidth: CGFloat {
        let n = max(1, bars.count)
        let available = max(0, plotRect.width - CGFloat(n - 1) * barGap)
        return max(1, available / CGFloat(n))
    }

    // Callout
    @State private var calloutSize: CGSize = .zero

    var body: some View {
        Chart {
            BarsLayer(bars: bars, barWidth: barWidth)

            // Price line
            ForEach(points, id: \.date) { p in
                LineMark(
                    x: .value("Date", p.date),
                    y: .value("Value", p.value - 40000)
                )
                .interpolationMethod(.monotone)
                .lineStyle(.init(lineWidth: 1, lineCap: .round, lineJoin: .round))
                .foregroundStyle(.green)
                .zIndex(2)
            }

            // Selection
            if let s = selected, let bar = nearestBar(to: s.date) {
                SelectionLayer(xDate: bar.center, yValue: bar.value)
            }
        }
        .chartOverlay { proxy in overlay(for: proxy) }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
        .chartXScale(range: .plotDimension(padding: 0))
        .chartPlotStyle { $0.background(.clear) }
        .sensoryFeedback(.selection, trigger: selected?.date)
        .padding(12)
    }

    // MARK: - Overlay

    @ViewBuilder
    private func overlay(for proxy: ChartProxy) -> some View {
        GeometryReader { geo in
            let rect = geo[proxy.plotAreaFrame]

            Rectangle()
                .fill(.clear)
                .contentShape(Rectangle())
                .onAppear { plotRect = rect }
                .onChange(of: geo.size) { _ in plotRect = geo[proxy.plotAreaFrame] }
                .onChange(of: bars.count) { _ in plotRect = geo[proxy.plotAreaFrame] }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard rect.contains(value.location),
                                  let date: Date = proxy.xDate(at: value.location, in: geo),
                                  let bar = nearestBar(to: date),
                                  let p = nearestPoint(to: bar.center)
                            else { return }
                            selected = p
                        }
                )

            // Callout
            if let s = selected,
               let bar = nearestBar(to: s.date),
               let px = proxy.position(forX: bar.center),
               let py = proxy.position(forY: bar.value) {

                let anchor = CGPoint(x: px + rect.minX, y: py + rect.minY)
                let origin = calloutOrigin(anchor: anchor, plot: rect,
                                           callout: calloutSize, margin: 8, gap: 10)

                ChartCalloutView(
                    date: s.date,
                    value: s.value,
                    dateFormatter: Self.df,
                    numberFormatter: Self.nf,
                    onSizeChange: { calloutSize = $0 }
                )
                .position(x: origin.x + calloutSize.width  / 2,
                          y: origin.y + calloutSize.height / 2)
            }
        }
    }

    // MARK: - Nearest helpers

    private func nearestBar(to date: Date) -> BackdropBar? {
        bars.min { abs($0.center.timeIntervalSince(date)) < abs($1.center.timeIntervalSince(date)) }
    }
    private func nearestPoint(to date: Date) -> PricePoint? {
        points.min { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) }
    }

    // MARK: - Callout placement

    private func calloutOrigin(anchor: CGPoint,
                               plot: CGRect,
                               callout: CGSize,
                               margin: CGFloat,
                               gap: CGFloat) -> CGPoint {
        var left = anchor.x + gap
        var top  = anchor.y - gap - callout.height

        if left + callout.width + margin > plot.maxX { left = anchor.x - gap - callout.width }
        left = min(max(left, plot.minX + margin), plot.maxX - margin - callout.width)

        if top < plot.minY + margin { top = anchor.y + gap }
        top = min(max(top, plot.minY + margin), plot.maxY - margin - callout.height)

        return CGPoint(x: left, y: top)
    }
}

// MARK: - Layers

private struct BarsLayer: ChartContent {
    let bars: [BackdropBar]
    let barWidth: CGFloat

    var body: some ChartContent {
        ForEach(bars) { b in
            BarMark(
                x: .value("Date", b.center),
                y: .value("Value", b.value),
                width: .fixed(barWidth)
            )
            .cornerRadius(8)
            .foregroundStyle(
                LinearGradient(
                    stops: [
                        .init(color: .panel.opacity(1.00), location: 0.00),
                        .init(color: .panel.opacity(0.50), location: 0.35),
                        .init(color: .panel.opacity(0.20), location: 0.80),
                        .init(color: .panel.opacity(0.10), location: 1.00),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .opacity(0.85)
            .zIndex(0)
        }
    }
}

private struct SelectionLayer: ChartContent {
    let xDate: Date
    let yValue: Double

    var body: some ChartContent {
        RuleMark(
            x: .value("Selected", xDate),
            yStart: .value("Bottom", 0),
            yEnd: .value("Top", yValue - 15)
        )
        .lineStyle(.init(lineWidth: 1))
        .foregroundStyle(.white)
        .zIndex(6)
        
        PointMark(x: .value("Date", xDate), y: .value("Value", yValue))
            .symbol {
                ZStack {
                    Circle().stroke(.white, lineWidth: 1.5)
                    Circle().fill(.black).padding(1.5)
                    Circle().fill(.white).padding(3)
                }
                .frame(width: 15, height: 15)
            }
            .zIndex(7)
    }
}

// MARK: - Utilities

private extension ChartProxy {
    /// Convert a view-space point to the X Date inside the plot area.
    func xDate(at location: CGPoint, in geo: GeometryProxy) -> Date? {
        let plot = geo[self.plotAreaFrame]
        return value(atX: location.x - plot.minX)
    }
}

// MARK: - Preview

struct PriceChart_PreviewHarness: View {
    @StateObject var vm = AnalyticsViewModel()
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(TimeRange.allCases) { r in
                            Button { vm.timeRange = r } label: {
                                Text(r.display)
                                    .font(.footnote.weight(.semibold))
                                    .padding(.horizontal, 12).padding(.vertical, 6)
                                    .background(vm.timeRange == r ? .white.opacity(0.18) : .white.opacity(0.08))
                                    .clipShape(Capsule())
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                PriceChartView(points: vm.series, selected: $vm.selectedPoint)
                    .id(vm.timeRange)
                    .frame(height: 220)
                    .padding(.horizontal, 16)

                Text(vm.formattedPortfolioValue(showINR: vm.showINR))
                    .font(.title3.bold())
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview("PriceChart + AnalyticsViewModel") {
    PriceChart_PreviewHarness()
}
