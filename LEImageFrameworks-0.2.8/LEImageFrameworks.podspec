Pod::Spec.new do |s|
  s.name = "LEImageFrameworks"
  s.version = "0.2.8"
  s.summary = "\u{56fe}\u{7247}\u{7f13}\u{5b58}\u{ff0c}\u{6eda}\u{52a8}\u{5e7f}\u{544a}\u{ff0c}\u{5355}\u{5f20}\u{56fe}\u{7247}\u{9009}\u{62e9}\u{ff0c}\u{56fe}\u{7247}\u{5207}\u{5272}\u{ff0c}\u{670b}\u{53cb}\u{5708}\u{56fe}\u{7247}\u{9009}\u{62e9}\u{5668}\u{5c01}\u{88c5}\u{ff0c}\u{670b}\u{53cb}\u{5708}\u{56fe}\u{7247}\u{67e5}\u{770b}\u{5668}\u{5c01}\u{88c5}"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"LarryEmerson"=>"larryemerson@163.com"}
  s.homepage = "https://github.com/LarryEmerson/LEImageFrameworks"
  s.source = { :path => '.' }

  s.ios.deployment_target    = '7.0'
  s.ios.vendored_framework   = 'ios/LEImageFrameworks.framework'
end
