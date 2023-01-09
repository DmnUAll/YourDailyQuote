import UIKit

extension UIView {

    func toAutolayout() {
        self .translatesAutoresizingMaskIntoConstraints = false
    }

    func addShadows() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
}
