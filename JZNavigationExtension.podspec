Pod::Spec.new do |s|
  s.name         = "JZNavigationExtension"
  s.version      = "1.3.0"
  s.summary      = "Integrates some convenient functions and open some hide property for UINavigationController."
  s.description  = "The 'UINavigationController+JZExtension' category integrates some convenient functions for your UINavigationController. Just pod in 3 files and no need for any setups."
  s.homepage     = "https://github.com/JazysYu/JZNavigationExtension"
  s.social_media_url   = "http://weibo.com/JazysYu"
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license = { :type => "MIT", :file => "LICENSE" }
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author = { "JazysYu" => "https://github.com/JazysYu" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform = :ios, "7.0"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source = { :git => "https://github.com/JazysYu/JZNavigationExtension.git", :tag => s.version }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "JZNavigationExtension"
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
end
