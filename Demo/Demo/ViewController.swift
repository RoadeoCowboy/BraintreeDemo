//
//  ViewController.swift
//  Demo
//
//  Created by Chen, David on 3/31/16.
//  Copyright © 2016 Chen, David. All rights reserved.
//

import UIKit
import Braintree
import Moltin

class ViewController: UIViewController, BTDropInViewControllerDelegate {

    var braintreeClient: BTAPIClient?
    
//      let clientToken = "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiIwYTA4Y2IxOTU2YmQ5NjlkZDVhYTllZWNhYWVlOTcxNTc5NWYxZTQwYmYyZmZhZGRlYzEzYjcwZjdiMjBlMjVkfGNyZWF0ZWRfYXQ9MjAxNi0wNC0wN1QyMDoyNToyNC41Mzc3NDQ0MTIrMDAwMFx1MDAyNm1lcmNoYW50X2lkPWZzam40czNmMm4yNHFia2NcdTAwMjZwdWJsaWNfa2V5PTd5eTN4ODQ1a3hyZ2hqbmIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZnNqbjRzM2YybjI0cWJrYy9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbImN2diJdLCJlbnZpcm9ubWVudCI6InNhbmRib3giLCJjbGllbnRBcGlVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvZnNqbjRzM2YybjI0cWJrYy9jbGllbnRfYXBpIiwiYXNzZXRzVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhdXRoVXJsIjoiaHR0cHM6Ly9hdXRoLnZlbm1vLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhbmFseXRpY3MiOnsidXJsIjoiaHR0cHM6Ly9jbGllbnQtYW5hbHl0aWNzLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb20vZnNqbjRzM2YybjI0cWJrYyJ9LCJ0aHJlZURTZWN1cmVFbmFibGVkIjpmYWxzZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiUGF5UGFsIHRlc3QiLCJjbGllbnRJZCI6bnVsbCwicHJpdmFjeVVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS9wcCIsInVzZXJBZ3JlZW1lbnRVcmwiOiJodHRwOi8vZXhhbXBsZS5jb20vdG9zIiwiYmFzZVVybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXNzZXRzVXJsIjoiaHR0cHM6Ly9jaGVja291dC5wYXlwYWwuY29tIiwiZGlyZWN0QmFzZVVybCI6bnVsbCwiYWxsb3dIdHRwIjp0cnVlLCJlbnZpcm9ubWVudE5vTmV0d29yayI6dHJ1ZSwiZW52aXJvbm1lbnQiOiJvZmZsaW5lIiwidW52ZXR0ZWRNZXJjaGFudCI6ZmFsc2UsImJyYWludHJlZUNsaWVudElkIjoibWFzdGVyY2xpZW50MyIsImJpbGxpbmdBZ3JlZW1lbnRzRW5hYmxlZCI6dHJ1ZSwibWVyY2hhbnRBY2NvdW50SWQiOiI3c21oYm43bnE4eG44c2d2IiwiY3VycmVuY3lJc29Db2RlIjoiVVNEIn0sImNvaW5iYXNlRW5hYmxlZCI6ZmFsc2UsIm1lcmNoYW50SWQiOiJmc2puNHMzZjJuMjRxYmtjIiwidmVubW8iOiJvZmYifQ=="
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Checkout Page"
        print("Ready to Go!")
        
        Moltin.sharedInstance().setPublicId("svWjeKkRtf4RQNG0v7r7YKMokkAU9kJYj4u4zVLotG")
        
        let clientTokenURL = NSURL(string: "http://localhost:8888/V.ZeroPHPServer/server.php")!
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)
//        clientTokenRequest.HTTPMethod = "POST"
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        NSURLSession.sharedSession().dataTaskWithRequest(clientTokenRequest) { (data, response, error) -> Void in
            //NSURLSession makes the server call.
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            
            self.braintreeClient = BTAPIClient(authorization: clientToken!)
            // As an example, you may wish to present our Drop-in UI at this point.
            // Continue to the next section to learn more...
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tappedMyPayButton()
            })
            
        }.resume()
        
        
    }
    
    func dropInViewController(viewController: BTDropInViewController,
        didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce)
    {
        // Send payment method nonce to your server for processing
        print("######Nonce is: \(paymentMethodNonce.nonce)")
        postNonceToServer(paymentMethodNonce.nonce)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func postNonceToServer(paymentMethodNonce: String) {
        let paymentURL = NSURL(string: "http://localhost:8888/V.ZeroPHPServer/server.php")!
        let request = NSMutableURLRequest(URL: paymentURL)
        request.HTTPBody = "payment_method_nonce=\(paymentMethodNonce)".dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
//            print("Response: \(response)")
//            var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("Body: \(strData)")
        }.resume()
    }
    
    func tappedMyPayButton() {
        
        // If you haven't already, create and retain a `BTAPIClient` instance with a
        // tokenization key OR a client token from your server.
        // Typically, you only need to do this once per session.
//         braintreeClient = BTAPIClient(authorization: clientToken)
        
        // Create a BTDropInViewController
        let dropInViewController = BTDropInViewController(APIClient: braintreeClient!)
        dropInViewController.delegate = self
        
        dropInViewController.view.tintColor = UIColor(red: 255/255.0, green: 136/255.0, blue: 51/255.0, alpha: 1.0)
        
        let paymentRequest = BTPaymentRequest()
        paymentRequest.callToActionText = "Subscribe Now"
        
        dropInViewController.paymentRequest = paymentRequest
        
        // This is where you might want to customize your view controller (see below)
        
        // The way you present your BTDropInViewController instance is up to you.
        // In this example, we wrap it in a new, modally-presented navigation controller:
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self, action: "userDidCancelPayment")
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func userDidCancelPayment() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Implement BTDropInViewControllerDelegate ...
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

