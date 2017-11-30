Pod::Spec.new do |s|
  s.name         = "JZNavigationExtension"
  s.version      = "2.1"
  s.summary      = "Integrates some convenient functions and open some hide property for UINavigationController."
  s.description  = "JZNavigationExtension integrates some convenient features for UINavigationController and easy to use."
  s.homepage     = "https://github.com/JazysYu/JZNavigationExtension"
  s.social_media_url   = "https://weibo.com/JazysYu"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "JazysYu" => "https://github.com/JazysYu" }
  s.platform = :ios, "7.0"
  s.source = { :git => "https://github.com/JazysYu/JZNavigationExtension.git", :tag => s.version }
  s.requires_arc = true
  s.source_files = "JZNavigationExtension/**/*.{h,m}"
end
