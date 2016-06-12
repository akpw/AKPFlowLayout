Pod::Spec.new do |spec|
  spec.name = "AKPFlowLayout"
  spec.version = "0.1.0"
  spec.summary = "Global pinnable, stretchable section headers for UICollectionViewFlowLayout"
  spec.homepage = "https://github.com/akpw/AKPFlowLayout"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Arseniy Kuznetsov" => 'k.arseniy@gmail.com' }

  spec.platform = :ios, "9.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/akpw/AKPFlowLayout.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "AKPFlowLayout/**/*.{h,swift}"
end
