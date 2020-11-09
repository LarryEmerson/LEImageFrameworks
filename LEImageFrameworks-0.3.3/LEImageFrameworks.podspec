Pod::Spec.new do |s|
  s.name = "LEImageFrameworks"
  s.version = "0.3.3"
  s.summary = "\u56FE\u7247\u7F13\u5B58\uFF0C\u6EDA\u52A8\u5E7F\u544A\uFF0C\u5355\u5F20\u56FE\u7247\u9009\u62E9\uFF0C\u56FE\u7247\u5207\u5272\uFF0C\u670B\u53CB\u5708\u56FE\u7247\u9009\u62E9\u5668\u5C01\u88C5\uFF0C\u670B\u53CB\u5708\u56FE\u7247\u67E5\u770B\u5668\u5C01\u88C5"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"LarryEmerson"=>"larryemerson@163.com"}
  s.homepage = "https://github.com/LarryEmerson/LEImageFrameworks"
  s.source = { :path => '.' }

  s.ios.deployment_target    = '7.0'
  s.ios.vendored_framework   = 'ios/LEImageFrameworks.framework'
end
