

Pod::Spec.new do |s|

  s.name         = "SKMoviePlayer"
  s.version      = "0.0.1"
  s.summary      = "SKMoviePlayer提供一个简单的视频播放器"

  s.description  = <<-DESC
                SKMoviePlayer视频播放器，提供简单的功能：播放、暂停、下载、全屏观看，拖拽进度。能满足基本的需求，如果需要定制功能，自行开发。
                   DESC

  s.homepage     = "https://github.com/wly314/SKMoviePlayer"


  s.license      = "MIT"

  s.author             = { "Leou" => "783459987@qq.com" }

  s.source       = { :git => "https://github.com/wly314/SKMoviePlayer.git", :commit => "725c1da19f9c35e18166c8a7195b691d6c7f520b" }

  s.source_files  = "SKMoviePlayer", "SKMoviePlayer/**/*.{h,m}"
  s.exclude_files = "SKMoviePlayer/SKImages"

  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"

  s.requires_arc = true

end
