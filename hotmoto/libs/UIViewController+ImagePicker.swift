
import UIKit

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func photoCamera() {
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: "Chọn hình ảnh", message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view

        let takePhoto = UIAlertAction(title: "Từ camera", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Từ thư viện hình ảnh", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Hủy", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        //let image = info[UIImagePickerControllerEditedImage] as! UIImage
        // image is our desired image

        picker.dismiss(animated: true, completion: nil)
    }
}
