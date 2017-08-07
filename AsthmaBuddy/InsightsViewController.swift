//
//  ReportViewController.swift
//  AsthmaBuddy
//
//  Created by Igor Kantor on 7/18/17.
//  Copyright © 2017 Igorware. All rights reserved.
//

import UIKit
//import ShinobiCharts
import MapKit
import HealthKit
import ResearchKit
import CoreLocation

// MARK: HealthKit Constants
let chartStartDateString = "07/30/2017"
let chartEndDateString = "08/09/2017"


// MARK: Chart  Constants
let inputFormat = "MM/dd/yyyy"
let chartFormat = "M/d"

// MARK: Map  Constants
let initialRegionRadius: CLLocationDistance = 75_000
let initialLocation = CLLocation(latitude: 39.570154341901485, longitude: -105.30286789781341)


// [X] setup start/end dates
// [X] format axis labels with short dates
// [X] replace navigation with segamented controls


// [X] insert sample  data  (with custom locations)into HKStore
// [X] utility to group samples by date
// [X] query to retreive 7 days of data and group by day bucket
// [ ] integrate map with location metadata
// [ ] add tint and selected styling to inhalerUsed button


class InsightsViewController: UIViewController, BaseHealthKitViewControllerProtocol {
    // MARK: Properties
    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var lineGraphChart: ORKLineGraphChartView!
    @IBOutlet weak var mapView: MKMapView!
    
    let sampleDates = NSMutableOrderedSet()
    var samplesWithLocation = [HKQuantitySample]()
    
    var countByDate:[Date: Double] = [:]
    let formatter = DateFormatter()
    var startDate : Date = Date()
    var endDate : Date = Date()
    
    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChart()
        
        setupChartData()
        
        setupMap()
        
        setupMapData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    // MARK: HealthKit
    
    func healthKitReady() {
        loadData()
    }
    
    func loadData(){
        HealthKitAdapter.sharedInstance.getInhalerUsage(completion: { (data) in
            if let data = data {
                self.loadChartData(data: data)
                self.loadMapData(data: data)
            }
        })
    }
    
    // MARK: Chart
    
    func setupChart(){
        formatter.dateFormat = inputFormat
        self.startDate = formatter.date(from: chartStartDateString)!
        self.endDate = formatter.date(from: chartEndDateString)!
        
        self.lineGraphChart.dataSource = self
        
        // todo: scroll chart down to 0
    }
    
    func setupChartData(){
        formatter.dateFormat = inputFormat
        
        var increment = DateComponents()
        increment.day = 1
        
        var currentDate = startDate
        while currentDate <= endDate {
            sampleDates.add(currentDate)
            currentDate = NSCalendar.current.date(byAdding: increment, to: currentDate)!
        }
        
        print(self.sampleDates)
        loadData()
    }
    
    func loadChartData(data:[HKQuantitySample]){
        self.countByDate = data.sampleValueCountByDate(start:startDate, end:endDate)
        
        DispatchQueue.main.async {
            self.lineGraphChart.reloadData()
        }
    }
    
    // MARK: Map
    
    func setupMap(){
        // set initial location in Denver
        centerMapOnLocation(initialLocation)
        
        mapView.delegate = self
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  initialRegionRadius * 2.0, initialRegionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setupMapData(){
//        let samples : [HKQuantitySample] = [HKQuantitySample.init(type: inhalerUsageQuantitityType , quantity: quantityOne, start: Date(), end: Date())]
        
    }
    
    func loadMapData(data:[HKQuantitySample]){
        self.samplesWithLocation = data.sampleLocations(start:startDate, end:endDate)
        
        DispatchQueue.main.async {
            // clear current
            self.mapView.removeAnnotations(self.mapView.annotations)
            // add annotations
            self.mapView.addAnnotations(self.samplesWithLocation)
        }
    }
}


// MARK: InsightsViewController implements ORKValueRangeGraphChartViewDataSource
extension InsightsViewController : ORKValueRangeGraphChartViewDataSource {
    public func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        let date = sampleDates[pointIndex] as! Date
        
        return ORKValueRange(value: Double(self.countByDate[date]!))
    }
    
    public func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
            return countByDate.keys.count
    }
    
    public func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    public func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        formatter.dateFormat = chartFormat
        if let date : Date = sampleDates.object(at: pointIndex) as? Date {
            return formatter.string(from: date)
        } else {
            return "N/A"
        }
    }
}


// MARK: InsightsViewController implements MKMapViewDelegate
extension InsightsViewController : MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        print("New Center: \(mapView.centerCoordinate)")
    }
    
    // 1
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? HKQuantitySample {
            let identifier = "inhalerUsagePin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            
            view.pinTintColor = annotation.pinTintColor()
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! HKQuantitySample
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

