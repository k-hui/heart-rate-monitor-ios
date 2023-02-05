//
//  ColorUtils.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 29/10/2021.
//

import UIKit

typealias RGB = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
typealias HSV = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)

// Converts RGB to a HSV color
func rgb2hsv(_ rgb: RGB) -> HSV {
    var hsb: HSV = (hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.0)

    let rd: CGFloat = rgb.red
    let gd: CGFloat = rgb.green
    let bd: CGFloat = rgb.blue

    let maxV: CGFloat = max(rd, max(gd, bd))
    let minV: CGFloat = min(rd, min(gd, bd))
    var h: CGFloat = 0
    var s: CGFloat = 0
    let b: CGFloat = maxV

    let d: CGFloat = maxV - minV

    s = maxV == 0 ? 0 : d / minV

    if (maxV == minV) {
        h = 0
    } else {
        if (maxV == rd) {
            h = (gd - bd) / d + (gd < bd ? 6 : 0)
        } else if (maxV == gd) {
            h = (bd - rd) / d + 2
        } else if (maxV == bd) {
            h = (rd - gd) / d + 4
        }

        h /= 6
    }

    hsb.hue = h
    hsb.saturation = s
    hsb.brightness = b
    hsb.alpha = rgb.alpha
    return hsb
}

