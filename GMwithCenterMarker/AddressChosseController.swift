//
//  AddressListController.swift
//  Reilu
//
//  Created by Hamza on 21/01/2022.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddressChosseController: BaseController,UISearchBarDelegate {
    
    
    lazy var mapView : GMSMapView = {
        let view = GMSMapView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var saveBtn : CustomButton = {
        let btn = CustomButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save", for: .normal)
  
        btn.addTarget(self, action: #selector(doneBtn), for: .touchUpInside)
        return btn
    }()
    
    lazy var currentLocationBtn : CustomButton = {
        let btn = CustomButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named:"AddAddress"), for: .normal)
        btn.backgroundColor = .clear
        btn.layer.shadowColor = UIColor.clear.cgColor
        btn.tintColor = .white
        btn.isHidden  = true
        btn.addTarget(self, action: #selector(curreLocationBtn_press), for: .touchUpInside)
        return btn
    }()
    
    lazy var markerImg : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "UserLocation")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
//        iv.tintColor = lightText()
//        iv.layer.cornerRadius = 8 * appConstant.heightRatio
        iv.clipsToBounds = false
        return iv
    }()
    
//    et image = resizeImage(image: UIImage(named: "UserLocation")!, targetSize: CGSize(width: 50.0,height: 50.0))
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    var locationManager : CLLocationManager! = CLLocationManager.init()
    var geoCoder : GMSGeocoder!
    var marker : GMSMarker!
    var initialcameraposition : GMSCameraPosition!
         
         // The currently selected place.
    var selectedPlace: CLLocationCoordinate2D?
    var srcLocationLat: Double! = 0.0
    var srcLocationLng: Double! = 0.0
    var srcAddress = ""
    let subView = UIView(frame: CGRect(x: 0, y: 90.0, width: UIScreen.main.bounds.width, height: 45.0))
    override func viewDidLoad() {
        super.viewDidLoad()

        baseHeadingeadingLbl.text = "Select Location"
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        self.geoCoder = GMSGeocoder()
        self.marker = GMSMarker()
        self.initialcameraposition = GMSCameraPosition()
        
        resultsViewController?.tableCellBackgroundColor = primaryColor()
        resultsViewController?.primaryTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        resultsViewController?.secondaryTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        resultsViewController?.primaryTextHighlightColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.view.backgroundColor = UIColor.clear
        searchController?.searchBar.delegate = self
        
        
        if #available(iOS 13.0, *) {
            searchController?.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
            // Fallback on earlier versions
        }
        searchController?.searchBar.layer.borderColor = UIColor.clear.cgColor
        searchController?.searchBar.barTintColor =  primaryColor()
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
         mapView.isMyLocationEnabled = false
         mapView.isBuildingsEnabled = true
        
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
         if locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))
         {
             self.locationManager.requestAlwaysAuthorization()
         }
         self.locationManager.startUpdatingLocation()
         
 //         self.marker.title = "Current Location"
 //         self.marker.map = self.mapView
 //         self.marker.icon = #imageLiteral(resourceName: "pin")
 //
         // mapView settings
         // point button code
         mapView.settings.myLocationButton = true
         mapView.settings.zoomGestures = true
         mapView.isMyLocationEnabled = true
         self.mapView.delegate = self
         setup()
    }
    
    func setup(){
        let margin = view.layoutMarginsGuide
        headerView.addSubview(currentLocationBtn)
        childview.addSubview(mapView)
        childview.addSubview(saveBtn)
        childview.addSubview(markerImg)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: childview.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: childview.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: childview.bottomAnchor),
            
            saveBtn.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -8 * appConstant.heightRatio),
            saveBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70 * appConstant.widthRatio),
            saveBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70 * appConstant.widthRatio),
            saveBtn.heightAnchor.constraint(equalToConstant: 40 * appConstant.heightRatio),
            
            currentLocationBtn.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            currentLocationBtn.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -8 * appConstant.widthRatio),
            currentLocationBtn.heightAnchor.constraint(equalToConstant: 24 * appConstant.heightRatio),
            currentLocationBtn.widthAnchor.constraint(equalToConstant: 24 * appConstant.heightRatio),
            
            
            markerImg.centerYAnchor.constraint(equalTo: childview.centerYAnchor,constant: -12 * appConstant.widthRatio),
            markerImg.centerXAnchor.constraint(equalTo: childview.centerXAnchor,constant: 0 * appConstant.widthRatio),
            markerImg.heightAnchor.constraint(equalToConstant: 24 * appConstant.heightRatio),
            markerImg.widthAnchor.constraint(equalToConstant: 24 * appConstant.heightRatio),
        ])
    }
    
    override func baseBackBtn_press() {
        self.srcAddress
        self.srcLocationLat ?? 0.0
        self.srcLocationLng ?? 0.0
        subView.removeFromSuperview()
        subView.isHidden  = true
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneBtn(){
        print(self.srcAddress)
        print(self.srcLocationLat ?? 0.0)
        print(self.srcLocationLng ?? 0.0)
    }
    
    @objc func curreLocationBtn_press(){
    
//        subView.removeFromSuperview()
//        subView.isHidden  = true
//        self.navigationController?.popViewController(animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
      {
          var userLoc = CLLocation()
          userLoc = locations[0]
          let coordinate:CLLocationCoordinate2D! = CLLocationCoordinate2DMake(userLoc.coordinate.latitude, userLoc.coordinate.longitude)
          let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16.0)
          self.locationManager.stopUpdatingLocation()
          self.mapView.camera = camera
          self.initialcameraposition = camera
//            self.marker.position = coordinate
//            self.marker.icon = #imageLiteral(resourceName: "pin")

          // set the lat long in double varibales
//            LocationVC.latitude = String(userLoc.coordinate.latitude)
//            LocationVC.longitude = String(userLoc.coordinate.longitude)
          srcLocationLat = userLoc.coordinate.latitude
          srcLocationLng = userLoc.coordinate.longitude
          
          
          
          // to print the src loc lat/long
          print("/n")
          print("Lat/Long coordinates currLocation given below:")
          print("SrcLocationLatitude:  \(String(describing: srcLocationLat!))")
          print("SrcLocationLongitude:  \(String(describing: srcLocationLng!))")
          print("/n")
          
          GMSGeocoder().reverseGeocodeCoordinate(userLoc.coordinate) { (resp
              ,err) in
              DispatchQueue.main.async {
                  
                  if let err = err {
                      print(err.localizedDescription)
                      return
                  }
                  
                  if let res = resp?.results()
                  {
                      if res.count > 0
                      {
                          var thoroughfare : String?
                          var subLocality : String?
                          var city : String?
                          var state : String?
                          var country : String?
                          
                          for addr in res {
                              if(thoroughfare == nil )
                              {
                                  thoroughfare = addr.thoroughfare
                              }
                              if(subLocality == nil )
                              {
                                  subLocality = addr.subLocality
                              }
                              if(city == nil )
                              {
                                  city = addr.locality
                              }
                              if(state == nil )
                              {
                                  state = addr.administrativeArea
                              }
                              if(country == nil )
                              {
                                  country = addr.country
                              }
                          }
                          
                          var addres = ""
                          if let thoroughfare = thoroughfare
                          {
                              addres += thoroughfare + ", "
                          }
                          if let subLocality = subLocality
                          {
                              addres += subLocality + ", "
                          }
                          if let city = city
                          {
                              addres += city + ", "
                          }
//                          if let state = state
//                          {
//                              addres += state + ", "
//                          }
//                          if let country = country
//                          {
//                              addres += country
//                          }
                          self.searchController?.searchBar.text = addres
                          self.srcAddress = addres
                         
//                          let dec = ["address":addres,"lat":self.srcLocationLat!,"long":self.srcLocationLng!] as [String : Any]
//                          LocationVC.addressDec = dec
                          
                      }
                      else
                      {
                          //self.currentLocation.text = "Unable to retrieve Location"
                      }
                  }
                  else
                  {
                      //self.currentLocation.text = "Unable to retrieve Location"
                  }
              }
          }
      }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error::\(error.localizedDescription )")
    }

   
}

extension AddressChosseController: GMSMapViewDelegate,CLLocationManagerDelegate
{

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("tapped on marker")
        self.marker.icon = UIImage(named: "UserLocation")
        if marker.title == "myMarker"{
            print("handle specific marker")
        }
        return true
    }
    //
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("didchange")
         returnPostionOfMapView(mapView: mapView)
      }

      /**
       * Called when the map becomes idle, after any outstanding gestures or animations have completed (or
       * after the camera has been explicitly set).
       */
      func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
          print("idleAt")

          //called when the map is idle
          returnPostionOfMapView(mapView: mapView)

      }

      //Convert the location position to address
      func returnPostionOfMapView(mapView:GMSMapView){
          let geocoder = GMSGeocoder()
          let latitute = mapView.camera.target.latitude
          let longitude = mapView.camera.target.longitude
          let position = CLLocationCoordinate2DMake(latitute, longitude)
          geocoder.reverseGeocodeCoordinate(position) { response , error in
              if error != nil {
                  print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
              }else {
                    let result = response?.results()?.first
                    self.srcLocationLat = result?.coordinate.latitude
                    self.srcLocationLng = result?.coordinate.longitude
                    
                    let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                  self.srcAddress = address ?? ""
                    guard  let addres = address,let lat = self.srcLocationLat,let long = self.srcLocationLng else {
                    return
                    }
                 
                    
//                    let dec = ["address":addres,"lat":lat,"long":long] as [String : Any]
//                    LocationVC.addressDec = dec
                    
                    
//                  self.searchController?.searchBar.resignFirstResponder()
                    self.searchController?.searchBar.text = addres
//                  self.searchController?.searchBar.resignFirstResponder()
                    
              }
          }
      }
}

extension AddressChosseController:GMSAutocompleteResultsViewControllerDelegate{
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
            let coordinate:CLLocationCoordinate2D! = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 16.0)
        
            self.mapView.camera = camera
        
        let dec = ["address":place.formattedAddress ?? "","lat":place.coordinate.latitude,"long":place.coordinate.longitude] as [String : Any]
        self.srcAddress = place.formattedAddress ?? ""
        self.srcLocationLng = place.coordinate.longitude
        self.srcLocationLat = place.coordinate.latitude
        self.searchController?.searchBar.text  = place.formattedAddress
        self.searchController?.searchBar.resignFirstResponder()
    
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.searchController?.isActive = false
        }
    }
}





