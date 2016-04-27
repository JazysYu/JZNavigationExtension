Pod::Spec.new do |s|
  s.name         = "JZNavigationExtension"
  s.version      = "1.4.5"
  s.summary      = "Integrates some convenient functions and open some hide property for UINavigationController."
  s.description  = "JZNavigationExtension integrates some convenient features for UINavigationController and easy to use."
  s.homepage     = "https://github.com/JazysYu/JZNavigationExtension"
  s.social_media_url   = "http://weibo.com/JazysYu"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "JazysYu" => "https://github.com/JazysYu" }
  s.platform = :ios, "7.0"
  s.source = { :git => "https://github.com/JazysYu/JZNavigationExtension.git", :tag => s.version }
  s.requires_arc = true
  s.source_files = "JZNavigationExtension/**/*.{h,m}"
end
