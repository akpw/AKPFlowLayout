Pod::Spec.new do |spec|
  spec.name = "AKPFlowLayout"
  spec.version = "0.1.2"
  spec.summary = "A custom UICollectionView layout with configurable global header and pinnable, stretchable section headers"
  spec.homepage = "https://github.com/akpw/AKPFlowLayout"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Arseniy Kuznetsov" => 'k.arseniy@gmail.com' }

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/akpw/AKPFlowLayout.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "AKPFlowLayout/**/*.{h,swift}"
end
