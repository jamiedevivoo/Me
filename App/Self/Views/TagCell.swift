
import UIKit
import SnapKit

class TagCell: UICollectionViewCell {
    static let reuseId = "TagCellReuseId"
    
    var button: UIButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboards are quicker, easier, more seductive. Not stronger then Code.")
    }
    
    func configure(tag: Tag) {
        button = TagButton(tag)
        guard !button.isDescendant(of: self) else {
            return
        }
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
