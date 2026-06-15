// Generates og-image.png (1200×630) for Quanta's social cards. Run: swift make_og.swift
import AppKit

let W = 1200.0, H = 630.0
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(W), pixelsHigh: Int(H),
    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
    colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
let gctx = NSGraphicsContext(bitmapImageRep: rep)!
NSGraphicsContext.current = gctx
let cg = gctx.cgContext

// Background gradient
let c1 = NSColor(srgbRed: 0.20, green: 0.10, blue: 0.55, alpha: 1).cgColor
let c2 = NSColor(srgbRed: 0.49, green: 0.36, blue: 1.0, alpha: 1).cgColor
let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [c1, c2] as CFArray, locations: [0, 1])!
cg.drawLinearGradient(grad, start: CGPoint(x: 0, y: H), end: CGPoint(x: W, y: 0), options: [])

// Atom mark on the left
let center = CGPoint(x: 300, y: H/2)
let rx = 180.0, ry = 70.0
for a in [0.0, 60.0, 120.0] {
    cg.saveGState()
    cg.translateBy(x: center.x, y: center.y); cg.rotate(by: a * .pi/180)
    cg.setStrokeColor(NSColor.white.withAlphaComponent(0.95).cgColor); cg.setLineWidth(12)
    cg.strokeEllipse(in: CGRect(x: -rx, y: -ry, width: 2*rx, height: 2*ry))
    cg.restoreGState()
}
cg.setShadow(offset: .zero, blur: 40, color: NSColor.white.withAlphaComponent(0.9).cgColor)
cg.setFillColor(NSColor.white.cgColor)
let nr = 38.0
cg.fillEllipse(in: CGRect(x: center.x-nr, y: center.y-nr, width: 2*nr, height: 2*nr))
cg.setShadow(offset: .zero, blur: 0, color: nil)

// Text on the right
func draw(_ s: String, font: NSFont, color: NSColor, x: CGFloat, y: CGFloat) {
    let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
    NSAttributedString(string: s, attributes: attrs).draw(at: NSPoint(x: x, y: y))
}
// NOTE: AppKit origin is bottom-left.
draw("Quanta", font: .systemFont(ofSize: 96, weight: .bold), color: .white, x: 540, y: 360)
draw("Private AI chat for iPhone", font: .systemFont(ofSize: 44, weight: .medium),
     color: NSColor.white.withAlphaComponent(0.95), x: 542, y: 290)
draw("Open models · vision · voice · 100% on-device", font: .systemFont(ofSize: 30, weight: .regular),
     color: NSColor.white.withAlphaComponent(0.8), x: 542, y: 235)

NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: "og-image.png"))
print("Wrote og-image.png")
