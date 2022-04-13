//
//  ViewController.swift
//  MyPetClassifier
//
//  Created by Nicolas Dolinkue on 13/04/2022.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let imagepicker = UIImagePickerController()
    

    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagepicker.delegate = self
        // con esto llamamos a la camara para que la pueda usar el usuario
        imagepicker.sourceType = .camera
        imagepicker.allowsEditing = false
        
        
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
      if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
          
          // para usar coreML, convertimas la imagen que eligio en CIImage
          guard let ciimage = CIImage(image: userPickedImage) else{
              fatalError()
          }
          
          detect(image: ciimage)
          
          
        }
        
        imagepicker.dismiss(animated: true)
        
    }
    
    
    func detect (image: CIImage) {
        
        // cargamos el modelo de CoreML en esta constante
        guard let model = try? VNCoreMLModel(for: MyPetClassifier().model) else {
            fatalError()
        }
        //aca consultamos al coreML, y pedimos que clasifique la imagen que le pasamos
        let request = VNCoreMLRequest(model: model) { (request, error) in
            let results = request.results?.first as? VNClassificationObservation
            
            self.navigationItem.title = results?.identifier
                
            
            
           
        }
        // aca pasamos la imagen que seleciono
        let handler = VNImageRequestHandler(ciImage: image)
        // hacemos la perform de la request para saber que es la imagen
        try! handler.perform([request])
    }
    
    
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagepicker, animated: true)
        
        
    }
    
}

