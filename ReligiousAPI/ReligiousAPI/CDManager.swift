//
//  CDManager.swift
//  ReligiousAPI
//
//  Created by ADMIN on 13/12/24.
//

import Foundation
import CoreData
import UIKit

class CDManager{
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    func readData() -> [QuoteModel]{
        var quotes: [QuoteModel] = []
        let managedContext = self.delegate?.persistentContainer.viewContext
        let fetchRes = NSFetchRequest<NSFetchRequestResult>(entityName: "Quote")
        do{
            let dataArr = try managedContext?.fetch(fetchRes)
            for d in dataArr as! [NSManagedObject]{
                let quote = d.value(forKey: "quote") as! String
                let religion = d.value(forKey: "religion") as! String
                let source = d.value(forKey: "source") as! String
                let id = d.value(forKey: "id") as! Int64
                quotes.append(QuoteModel(id: id, religion: religion, quote: quote, source: source))
            }
        } catch let err as NSError {
            print(err)
        }
        return quotes
    }
    func addData(quoteData: QuoteModel){
        guard let managedContext = self.delegate?.persistentContainer.viewContext else { return }
        guard let quoteEntity = NSEntityDescription.entity(forEntityName: "Quote", in: managedContext) else {return}
        let quote = NSManagedObject(entity: quoteEntity, insertInto: managedContext)
        quote.setValue(quoteData.id, forKey: "id")
        quote.setValue(quoteData.quote, forKey: "quote")
        quote.setValue(quoteData.religion, forKey: "religion")
        quote.setValue(quoteData.source, forKey: "source")
        do {
            try managedContext.save()
            print("quote Saved successfully!")
        } catch let error as NSError{
            debugPrint(error)
        }
    }
    func deleteFromCD(quote: QuoteModel){
        guard let managedContext = self.delegate?.persistentContainer.viewContext else { return }
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Quote")
        fetchReq.predicate = NSPredicate(format: "id = %d", quote.id)
        
        do {
            let fetchRes = try managedContext.fetch(fetchReq)
            let objToDelete = fetchRes[0] as! NSManagedObject
            managedContext.delete(objToDelete)
            
            try managedContext.save()
            print("Quote has been deleted")
        }catch let error as NSError{
            debugPrint(error)
        }
    }
    
    func updateFromCD(quote: QuoteModel){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
        let managedContext = delegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Quote")
        print("Inside Update")
        fetchReq.predicate = NSPredicate(format: "id = %d", quote.id)
        do {
            let fetchRes = try managedContext.fetch(fetchReq)
            let objToUpdate = fetchRes[0] as! NSManagedObject
            objToUpdate.setValue(quote.quote, forKey: "quote")
            objToUpdate.setValue(quote.religion, forKey: "religion")
            objToUpdate.setValue(quote.source, forKey: "source")
            
            print(objToUpdate.value(forKey: "quote"))
            print(objToUpdate.value(forKey: "religion"))
            print(objToUpdate.value(forKey: "source"))
            try managedContext.save()
            print("Quote Updated!")
        } catch let error as NSError{
            debugPrint(error)
        }
    }
}
