Pod::Spec.new do |spec|
  spec.name = "SwiftCoAP"
  spec.version = "0.0.1"
  spec.license = { type: "MIT" }
  spec.homepage = "https://github.com/kierangraham/SwiftCoAP"
  spec.authors = { "Wojtek Kordylewski" => "stuffrabbit@yahoo.de", "Kieran Graham" => "me@kierangraham.com" }
  spec.summary = "CoAP implementation in Swift."
  spec.source  = { git: "https://github.com/kierangraham/SwiftCoAP.git", tag: spec.version }

  spec.ios.deployment_target = '8.0'

  spec.source_files = 'SwiftCoAP_Library/*.swift'
  spec.requires_arc = true

  spec.dependency "CocoaAsyncSocket"
end
