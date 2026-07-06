//
//  BaseViewModelType.swift
//  Nearby
//
//  Created by soomin on 7/2/26.
//

public protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output
    
    var output: Output { get }
    func action(_ trigger: Input)
}
