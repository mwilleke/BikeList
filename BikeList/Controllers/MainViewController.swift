//
//  MainViewController.swift
//  BikeList
//
//  Created by Matthew Willeke on 1/25/19.
//  Copyright © 2019 Matthew Willeke. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var networkList = [Network]()
    var appDelegate: AppDelegate!
    var backgroundContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerTableViewCell()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.backgroundContext = self.appDelegate.persistentContainer.newBackgroundContext()
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(true)
        
        loadData()
    }
    
    func loadData() {
        NetworkApi.getNetworkContentFromApi(completion: { networks in
            if networks == nil {
                self.getStoredData(completion: { () in
                    self.loadMapPoints()
                    self.tableView.reloadData()
                })
                return
            }
            self.networkList = networks!
            self.createDataForStorage()
            self.loadMapPoints()
            self.tableView.reloadData()
        })
    }
    
    func getStoredData(completion: @escaping () -> Void) {
        self.backgroundContext.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Networks")
            request.returnsObjectsAsFaults = false
            do {
                let result = try self.backgroundContext.fetch(request)
                for data in result as! [NSManagedObject] {
                    let n = Network(id: data.value(forKey: "id") as! String, companyName: data.value(forKey: "companyName") as! String, city: data.value(forKey: "city") as! String, country: data.value(forKey: "country") as! String, latitude: data.value(forKey: "latitude") as! Double, longitude: data.value(forKey: "longitude") as! Double)
                    self.networkList.append(n)
                }
            } catch {
                print("Failed")
            }
            DispatchQueue.main.async() {
                completion()
            }
        }
    }
    
    func createDataForStorage() {
        self.backgroundContext.perform {
            let entity = NSEntityDescription.entity(forEntityName: "Networks", in: self.backgroundContext)
            
            for network in self.networkList {
                if self.doesNetworkExistInCoreData(network: network) {
                } else {
                    let newNetwork = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                    newNetwork.setValue(network.id, forKey: "id")
                    newNetwork.setValue(network.companyName, forKey: "companyName")
                    newNetwork.setValue(network.city, forKey: "city")
                    newNetwork.setValue(network.country, forKey: "country")
                    newNetwork.setValue(network.latitude, forKey: "latitude")
                    newNetwork.setValue(network.longitude, forKey: "longitude")
                    self.saveData()
                }
            }
        }
    }
    
    func doesNetworkExistInCoreData(network: Network) -> Bool {
        var entitiesCount = 0
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Networks")
        let predicate = NSPredicate(format: "id == %@", network.id)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.includesSubentities = false
            
        do {
            entitiesCount = try self.backgroundContext.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }
    
    func saveData() {
        do {
            try self.backgroundContext.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func loadMapPoints() {
        let annotations = self.networkList.map { network -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: network.latitude, longitude: network.longitude)
            return annotation
        }
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: - tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkTableViewCell") as! NetworkTableViewCell
        cell.companyNameLabel.text = self.networkList[indexPath.row].companyName
        cell.cityLabel.text = self.networkList[indexPath.row].city
        cell.countryLabel.text = self.networkList[indexPath.row].country
        return cell
    }
    
    // MARK: - custom cell methods
    
    func registerTableViewCell() {
        let networkCell = UINib(nibName: "NetworkTableViewCell", bundle: nil)
        self.tableView.register(networkCell, forCellReuseIdentifier: "NetworkTableViewCell")
    }
}
