//
//  ViewController.swift
//  SlotPickerView
//
//  Created by Cem Olcay on 8/13/23.
//

import UIKit

class SlotView: UIView {
    var isStart: Bool = false
    var isEnd: Bool = false
    
    var isSelected: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    var selectedLayer = CALayer()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .darkGray
        selectedLayer.backgroundColor = UIColor.darkGray.cgColor
        layer.addSublayer(selectedLayer)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectedLayer.backgroundColor = isSelected ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        
        if isStart {
            selectedLayer.frame = CGRect(
                x: frame.width - (frame.width / 2.0),
                y: (frame.height / 4.0),
                width: frame.width / 2.0,
                height: (frame.height / 2.0))
        } else if isEnd {
            selectedLayer.frame = CGRect(
                x: 0,
                y: (frame.height / 4.0),
                width: frame.width / 2.0,
                height: (frame.height / 2.0))
        } else {
            selectedLayer.frame = CGRect(
                x: 0,
                y: (frame.height / 4.0),
                width: frame.width,
                height: (frame.height / 2.0))
        }
    }
}

class ViewController: UIViewController, SlotPickerViewDelegate {
    let slotPicker = SlotPickerView()
    let slotDisplay = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(slotPicker)
        slotPicker.delegate = self
        slotPicker.translatesAutoresizingMaskIntoConstraints = false
        slotPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        slotPicker.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        slotPicker.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        slotPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        slotPicker.addSubview(slotDisplay)
        slotDisplay.axis = .horizontal
        slotDisplay.spacing = 0
        slotDisplay.alignment = .fill
        slotDisplay.distribution = .fillEqually
        slotDisplay.translatesAutoresizingMaskIntoConstraints = false
        slotPicker.leftAnchor.constraint(equalTo: slotDisplay.leftAnchor).isActive = true
        slotPicker.rightAnchor.constraint(equalTo: slotDisplay.rightAnchor).isActive = true
        slotPicker.topAnchor.constraint(equalTo: slotDisplay.topAnchor).isActive = true
        slotPicker.bottomAnchor.constraint(equalTo: slotDisplay.bottomAnchor).isActive = true
        
        slotPicker.slotCount = 10
        for i in 0..<slotPicker.slotCount {
            let view = SlotView()
            view.tag = i
            //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(tap:))))
            slotDisplay.addArrangedSubview(view)
        }
    }
    
    func slotPickerViewDidPickSlot(_ slotPickerView: SlotPickerView) {
        slotDisplay.arrangedSubviews.compactMap({ $0 as? SlotView }).forEach({ $0.isSelected = false })
        for slot in slotPickerView.pickedSlots {
            for i in slot.startIndex...slot.endIndex {
                if slotDisplay.arrangedSubviews.indices.contains(i),
                   let slotView = slotDisplay.arrangedSubviews[i] as? SlotView {
                    slotView.isStart = i == slot.startIndex && i != slot.endIndex
                    slotView.isEnd = i == slot.endIndex && i != slot.startIndex
                    slotView.isSelected = true
                } else {
                    print(i, slot.endIndex)
                }
            }
        }
    }
    
    @IBAction func didTap(tap: UITapGestureRecognizer) {
        print("tap \(tap.view!.tag)")
    }
}
