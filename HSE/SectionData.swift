//
//  Section.swift
//  HSE
//
//  Created by Сергей Мирошниченко on 18.11.2021.
//

struct SectionData {
    let title: String
    let data : [String]

    var numberOfItems: Int {
        return data.count
    }

    subscript(index: Int) -> String {
        return data[index]
    }
    
    init(title: String, data: String...) {
        self.title = title
        self.data  = data
    }
}
