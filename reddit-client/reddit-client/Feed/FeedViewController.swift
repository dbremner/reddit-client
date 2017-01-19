//
//  FeedViewController.swift
//  reddit-client
//
//  Created by Pablo Romero on 1/18/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import CoreData

class FeedViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        self.clearsSelectionOnViewWillAppear = true
  
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.fetchedResultsController.sections?.count ?? 0
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
        
        let link = self.fetchedResultsController.object(at: indexPath)
        
        cell.update(withLink: link)
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let link = self.fetchedResultsController.object(at: indexPath)
        return LinkCell.neededHeight(forLink: link)
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Link> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Link> = Link.fetchRequest()
        
//        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sort", ascending: true)]
       
        let context = DataHelper.sharedInstance.viewContext()
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        _fetchedResultsController = fetchedResultsController
        
        do {
        
            try _fetchedResultsController!.performFetch()
        
        } catch {
       
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Link>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView.beginUpdates()
    
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
            
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        
        default:
            return
        
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
       
        switch type {
        
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        
        case .update:
            let link = anObject as! Link
            let cell = tableView.cellForRow(at: indexPath!) as! LinkCell
            cell.update(withLink: link)
            
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.tableView.endUpdates()
    
    }

}
