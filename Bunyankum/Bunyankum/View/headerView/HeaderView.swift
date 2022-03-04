//
//  HeaderView.swift
//  Aroad
//
//  Created by YoussefRomany on 3/19/20.
//  Copyright © 2020 HardTask. All rights reserved.
//

import UIKit
import IBAnimatable


protocol SearchDelegation: NSObjectProtocol {
    func getSearchResultFor(kay: String)
}

protocol productShowDelegation: NSObjectProtocol {
        func changeShape()
}

protocol ShowPanoramaDelegation: NSObjectProtocol {
        func showPanorama()
}

protocol CloseSocketDelegation: NSObjectProtocol {
        func close()
}

class HeaderView: UIView {

    //MARK:- IBOutlet
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet var menuView: UIView!
    @IBOutlet var searchView: UIView!
//    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var containerView: AnimatableView!
    @IBOutlet var stackView: UIStackView!
    
    /// variables
    var parent: UIViewController!
    var title: String = ""
    var isFromRoot = false
    weak var delegat: SearchDelegation?
    weak var closeDelegata: CloseSocketDelegation?
    var isFromPAyment = false
    var isTable = true
    weak var delegatShowType: productShowDelegation?
    weak var delegatShowPanorama: ShowPanoramaDelegation?
    var isFromSocket = false
    var isFromCart = false
    
    //MARK:-  init view
    public static func initView(fromController controller: UIViewController, andView view: UIView, andTitle title: String = "", isFromRoot: Bool) -> HeaderView{
        
         let popup = Bundle.main.loadNibNamed("HeaderView", owner: controller, options: nil)?.last as! HeaderView
            popup.parent = controller
            popup.headerLabel.text = title
            popup.isFromRoot = isFromRoot
            popup.initView()
            popup.backView.isHidden = isFromRoot
            popup.frame = view.bounds
        
//        if User.shared.CartCount == 0{
//            popup.redView.isHidden = true
//        }else{
//            popup.redView.isHidden = false
//            popup.cartNumberLabel.text = "\(User.shared.CartCount)"
//        }
         
         mainQueue {
             popup.headerLabel.font = UIFont(name:  localizedSitringFor(key: "boldFont"), size: iphoneXFactor*16)
         }
         view.addSubview(popup)

         return popup

    }

    // MARK:- IBAction
    @IBAction func backAction(_ sender: Any) {
        if isFromCart{
//
//            let main = UIStoryboard(name: "Main", bundle: nil)
//            let vc = main.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
//            vc.isFromCart = true
//            UIApplication.getTopMostViewController()?.present(vc, animated: false, completion: nil)
        }else{
        if isFromSocket{
            closeDelegata?.close()
        }
        if isFromPAyment{
            pushToView(withId: "TabBarViewController")
        }else{
            parent.navigationController?.popViewController(animated: true)
            parent.dismiss(animated: true, completion: nil)
        }
        }
    }
    
    @IBAction func showSideMenuAction(_ sender: Any) {
    }
    
    @IBAction func catTypeAction(_ sender: Any) {
        delegatShowType?.changeShape()
    }
    


    @IBAction func searchAction(_ sender: Any) {
        goNavigation(controllerId: "SearchViewController", controller: parent)

    }
    
    @IBAction func addAddressAction(_ sender: Any) {
        goNavigation(controllerId: "AddAddressViewController", controller: parent)
    }
}



// MARK: - helpers
extension HeaderView{
    
    func refreshShape(){
        mainQueue {
            let typeImage = self.isTable ? "boxes_icon" : "list"
            print("cellIstable", self.isTable)
 //           self.catTypeImageView.image = UIImage(named: typeImage)

        }
    }
    
    func refreshCartNumber(){

    }
    
    func initView(){
        refreshCartNumber()
        mainQueue {
            self.stackView.semanticContentAttribute = .forceLeftToRight

//            self.searchBar.setTextField(color: UIColor.white)
//            self.searchBar.setImage(UIImage(), for: .search, state: .normal)
//            self.searchBar.delegate = self // self.parent as? UISearchBarDelegate
//            self.backView.isHidden = self.isFromRoot
//        }
        }
    }
    
    /// show side menu
   
}



// MARK: - UISearchBarDelegate
extension HeaderView: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("dwedwedwedwe")
        if searchBar.text != ""{
            delegat?.getSearchResultFor(kay: searchBar.text ?? "")
//        searchBar.text = ""
//        searchBar.isHidden = true
//        navigationController?.pushViewController(vc, animated: true)
        }
        }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("wedwedewdwedewdwcdcscsdcscs")
        if searchBar.text != ""{
            delegat?.getSearchResultFor(kay: searchBar.text ?? "")
//        searchBar.text = ""
//        searchBar.isHidden = true
//        navigationController?.pushViewController(vc, animated: true)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        searchBar.text = ""
        searchBar.isHidden = true
    }
}



extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}
