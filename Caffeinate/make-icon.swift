import AppKit

let S = 1024.0
let canvas = NSImage(size: NSSize(width: S, height: S))
canvas.lockFocus()

// White ground
NSColor.white.setFill()
NSRect(x: 0, y: 0, width: S, height: S).fill()

// Grey circle (systemGray5 light)
NSColor(calibratedRed: 0xE5/255.0, green: 0xE5/255.0, blue: 0xEA/255.0, alpha: 1).setFill()
let d = S * 0.72
NSBezierPath(ovalIn: NSRect(x: (S - d)/2, y: (S - d)/2, width: d, height: d)).fill()

// SF Symbol cup.and.saucer.fill, grey, configured to a large point size first
let cfg = NSImage.SymbolConfiguration(pointSize: 460, weight: .regular)
let symbol = NSImage(systemSymbolName: "cup.and.saucer.fill", accessibilityDescription: nil)!
    .withSymbolConfiguration(cfg)!
let gs = symbol.size
let target = d * 0.52
let scale = min(target / gs.width, target / gs.height)
let w = gs.width * scale, h = gs.height * scale
let dst = NSRect(x: (S - w)/2, y: (S - h)/2, width: w, height: h)

let tinted = NSImage(size: symbol.size)
tinted.lockFocus()
symbol.draw(at: .zero, from: .zero, operation: .sourceOver, fraction: 1)
NSColor(calibratedRed: 0x8A/255.0, green: 0x8A/255.0, blue: 0x8E/255.0, alpha: 1).set()
NSRect(origin: .zero, size: symbol.size).fill(using: .sourceAtop)
tinted.unlockFocus()

tinted.draw(in: dst, from: .zero, operation: .sourceOver, fraction: 1)

canvas.unlockFocus()

let tiff = canvas.tiffRepresentation!
let bmp = NSBitmapImageRep(data: tiff)!
let png = bmp.representation(using: .png, properties: [:])!
try! png.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
print("ok")
