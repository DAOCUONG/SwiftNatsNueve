
Pod::Spec.new do |s|
    s.name              = "SwiftNatsNueve"
    s.version           = "5.0.0"
    s.swift_versions    = "5.0"
    s.summary           = "A Swift client for the NATS messaging system."
    s.description       = <<-DESC
        Swift 5.0 client for NATS, the cloud native messaging system. https://nats.io
                            DESC
    s.homepage          = "https://github.com/mrsnow-git/SwiftNatsNueve"
    s.license           = { :type => "MIT", :file => "LICENSE" }
    s.author            = { "mrsnow" => "denis@mrsnow.info" }
    s.social_media_url  = "https://instagram.com/chocosnow"
    s.platform          = :ios, "10.0"
    s.source            = { :git => "https://github.com/mrsnow-git/SwiftNatsNueve.git", :tag => s.version.to_s }
    s.source_files      = "Sources", "Sources/**/*.{h,m}"
    s.requires_arc      = true
end
