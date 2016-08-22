
Pod::Spec.new do |s|

  s.name         = "SKMoviePlayer"
  s.version      = "0.0.6"
  s.summary      = "SKMoviePlayer一个在完善中的播放器－基于AVPlayer"

  s.description  = <<-DESC
SKMoviePlayer一个在完善中的播放器－基于AVPlayer
必须是addSubview添加播放器SKMoviePlayer。
                   DESC

  s.homepage     = "https://wly314.github.io"
  s.license      = "MIT"

  s.author             = { "Leou" => "wly314sdx@qq.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/wly314/SKMoviePlayer.git", :tag => "0.0.6" }
  
  s.source_files  = "SKMoviePlayer", "*.{h,m}"
  s.resources    = 'SKMoviePlayer/SKImages/*.{png,jpg}'
  
  s.requires_arc = true

end
