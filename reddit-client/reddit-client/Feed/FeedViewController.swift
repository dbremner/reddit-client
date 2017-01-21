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

    @IBOutlet var loadMoreView: LoadMoreView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "reddit"
        
        self.setupTableView()
        self.requestFirstPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = true
        super.viewWillAppear(animated)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.requestFirstPage()
    }
    
    // MARK: - Data
    
    func requestFirstPage() {
        
        self.loadMoreView.setLoadingMode(true)
        
        RedditAPI.sharedInstance.top { (error: Error?) in
         
            self.loadMoreView.setLoadingMode(false)
            self.refreshTableViewFooter()
            
            if let refreshControl = self.refreshControl {
                refreshControl.endRefreshing()
            }
            
            if let error = error {
                UIAlertController.presentAlert(withError: error,
                                               overViewController: self)
            }
        }
    }
    
    func requestNextPage() {
        
        self.loadMoreView.setLoadingMode(true)
        self.refreshControl?.isEnabled = false
        
        RedditAPI.sharedInstance.nextPage { (error: Error?) in
       
            self.loadMoreView.setLoadingMode(false)
            self.refreshControl?.isEnabled = true
            
            if let error = error {
                UIAlertController.presentAlert(withError: error,
                                               overViewController: self)
            }
        }
    }
    
    
     // MARK: - Navigation
    
    func showDatilsViewController(forLink link: Link) {
       
        let contentType: LinkContentType = LinkContentType(rawValue: link.contentType)!
        
        switch contentType {
        case .unknown, .embeddedVideo, .link:
            self.performSegue(withIdentifier: "showLinkDetails", sender: link.url)
        case .image:
            self.performSegue(withIdentifier: "showImageDetails", sender: link.url)
            
        }
        
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if segue.identifier == "showLinkDetails" ||
           segue.identifier == "showImageDetails" {
            
            let vc = segue.destination as! DetailsViewController
            let urlString = sender as! String
            
            let url = URL(string: urlString)!
            vc.currentURL = url
        }
     }

  
    // MARK: - Table view
    
    func setupTableView() {
        
        self.loadMoreView.loadHandler = {
            self.requestNextPage()
        }
        
        self.refreshTableViewFooter()
        
        self.refreshControl?.addTarget(self,
                                       action: #selector(FeedViewController.handleRefresh(refreshControl:)),
                                       for: UIControlEvents.valueChanged)
    }
    
    func refreshTableViewFooter() {
        
        let context = DataHelper.sharedInstance.viewContext()
        if Link.isEmpty(context: context) {
            self.tableView.tableFooterView = nil
        } else {
            self.tableView.tableFooterView = self.loadMoreView
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell",
                                                 for: indexPath) as! LinkCell
        let link = self.fetchedResultsController.object(at: indexPath)
        cell.update(withLink: link)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        let link = self.fetchedResultsController.object(at: indexPath)
        return LinkCell.neededHeight(forLink: link)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = self.fetchedResultsController.object(at: indexPath)
        self.showDatilsViewController(forLink: link)
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Link> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Link> = Link.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sortValue", ascending: true)]
       
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
            if let cell = tableView.cellForRow(at: indexPath!) as? LinkCell {
                cell.update(withLink: link)
            }
            
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    // MARK: - Restoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        
        // Encode current selected link
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let link = self.fetchedResultsController.object(at: indexPath)
            coder.encode(link.identifier)
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        if let linkIdentifier = coder.decodeObject() as? String {
            let context = DataHelper.sharedInstance.viewContext()
            if let link = Link.find(withIdentifier: linkIdentifier,
                                    context: context) {
                if let indexPath = self.fetchedResultsController.indexPath(forObject: link) {
                    self.tableView.selectRow(at: indexPath,
                                             animated: false,
                                             scrollPosition: .middle)
                }
            }
        }
    }
}
