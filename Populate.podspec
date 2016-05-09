Pod::Spec.new do |s|
  s.name             = "Populate"
  s.version          = "1.0"
  s.summary          = "Populate your views with NSFetchedResultsController-like behaviour. 100% Swift, type-safe protocol-orientated design."
  s.homepage         = "https://github.com/shaps80/Populate"
  s.license          = 'MIT'
  s.author           = { "Shaps Mohsenin" => "shapsuk@me.com" }
  s.source           = { :git => "https://github.com/shaps80/Populate.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/shaps'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*.{h,m,swift}'
end
