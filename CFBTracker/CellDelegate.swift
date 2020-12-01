//
//  CellDelegate.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/20/20.
//  terrywangce@gmail.com
//

import Foundation

// Short and simple delegate class to get access to cell
protocol CellDelegate : class{
    func didPressButton(cell: ScheduleTableViewCell)
}
