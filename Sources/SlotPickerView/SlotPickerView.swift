// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol SlotPickerViewDelegate: AnyObject {
    func slotPickerViewDidPickSlot(_ slotPickerView: SlotPickerView)
}

public class SlotItemData: Identifiable {
    public var startIndex: Int
    public var endIndex: Int
    public var id: UUID
    
    public var length: Int {
        return (endIndex - startIndex) + 1
    }
    
    public init(startIndex: Int, endIndex: Int) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.id = UUID()
    }
    
    public func collides(with other: SlotItemData) -> Bool {
        let c1 = (other.startIndex >= startIndex && other.startIndex <= endIndex)
        let c2 = other.endIndex <= endIndex && startIndex <= other.endIndex
        return c1 || c2
    }
}

public class SlotPickerView: UIView {
    public var slotCount: Int = 0
    public private(set) var pickedSlots: [SlotItemData] = []
    public var delegate: SlotPickerViewDelegate?
    
    private var currentIndex: Int?
    private var startIndex: Int?
    private var pickingSlot: SlotItemData?
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard slotCount > 0, currentIndex == nil, pickingSlot == nil,
        let location = touches.first?.location(in: self) else { return }
        let slotWidth = frame.size.width / CGFloat(slotCount)
        let index = Int(location.x / slotWidth)
        currentIndex = index
        startIndex = index
        pickingSlot = SlotItemData(
            startIndex: min(startIndex!, currentIndex!),
            endIndex: max(startIndex!, currentIndex!))
        
        // remove collisions
        var removeIndicies = [Int]()
        for (i, slot) in pickedSlots.enumerated() {
            if slot.collides(with: pickingSlot!) {
                removeIndicies.append(i)
            }
        }
        removeIndicies.reversed().forEach({ pickedSlots.remove(at: $0) })
        
        pickedSlots.append(pickingSlot!)
        delegate?.slotPickerViewDidPickSlot(self)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard slotCount > 0, currentIndex != nil, pickingSlot != nil,
        let location = touches.first?.location(in: self) else { return }
        let slotWidth = frame.size.width / CGFloat(slotCount)
        let index = Int(location.x / slotWidth)
        
        guard index != currentIndex else { return }
        currentIndex = index
        
        pickingSlot!.startIndex = min(startIndex!, currentIndex!)
        pickingSlot!.endIndex = max(startIndex!, currentIndex!)
        
        // remove collisions
        var removeIndicies = [Int]()
        for (i, slot) in pickedSlots.enumerated() {
            if slot.id == pickedSlots.last?.id { continue }
            if slot.collides(with: pickedSlots.last!) {
                removeIndicies.append(i)
            }
        }
        removeIndicies.reversed().forEach({ pickedSlots.remove(at: $0) })
        delegate?.slotPickerViewDidPickSlot(self)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickingSlot = nil
        startIndex = nil
        currentIndex = nil
        delegate?.slotPickerViewDidPickSlot(self)
    }
}
