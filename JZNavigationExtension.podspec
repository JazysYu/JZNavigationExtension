
Pod::Spec.new do |s|
  s.name         = "JZNavigationExtension"
  s.version      = "1.0"
  s.summary      = "The "UINavigationController+JZExtension" category integrates some convenient functions and open some hide property for your UINavigationController."
  s.description  = "The "UINavigationController+JZExtension" category integrates some convenient functions and open some hide property for your UINavigationController. Just pod in 2 files and no need for any setups."
  s.homepage     = "https://github.com/JazysYu/JZNavigationExtension"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license = { :type => "MIT", :file => "LICENSE" }
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author = { "JazysYu" => "https://github.com/JazysYu" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform = :ios, "7.0"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source = { :git => "https://github.com/JazysYu/JZNavigationExtension.git", :tag => "1.0" }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "JZNavigationExtension/*.{h,m}"
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
end
