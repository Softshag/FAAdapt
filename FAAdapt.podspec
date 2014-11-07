Pod::Spec.new do |spec|
spec.name             = 'FAAdapt'
spec.version          = '0.0.1'
spec.license          =  :type => 'MIT'
spec.homepage         = 'https://github.com/Softshag/FAAdapt'
spec.authors          = 'Rasmus Kildevæld' => 'rasmus@softshag.dk'
spec.summary          = 'Object mapper for objective-c'
spec.source           =  :git => 'https://github.com/Softshag/FAAdapt.git', :tag => 'v0.0.1'
spec.source_files     = 'FAAdapt/**/*{.h,m}'
spec.requires_arc     = true
end