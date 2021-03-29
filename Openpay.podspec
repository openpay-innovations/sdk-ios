Pod::Spec.new do |spec|
  spec.name          = "Openpay"
  spec.version       = ENV['LIB_VERSION'] || '1.0.0' # fallback to major version
  spec.summary       = "Openpay iOS SDK"
  spec.description   = <<-DESC
    The Openpay iOS SDK provides drop in UI Components for a smooth Openpay integration.
  DESC
  spec.homepage      = "https://github.com/openpay-innovations/sdk-ios"
  spec.license       = "Apache License, Version 2.0"
  spec.author        = "Openpay"
  spec.platform      = :ios, "13.0"
  spec.ios.deployment_target  = "13.0"
  spec.source        = { :git => "https://github.com/openpay-innovations/sdk-ios", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/Openpay/**/*.swift"
  spec.swift_version = "5.3"
  spec.framework     = "UIKit"
  spec.ios.resource_bundle = { 'Openpay' => 'Sources/Openpay/Resources/**' }
  spec.resource_bundles = { 'Openpay' => 'Sources/Openpay/Resources/**'}
end
