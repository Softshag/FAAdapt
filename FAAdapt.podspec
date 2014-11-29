#
#  Be sure to run `pod spec lint FAAdapt.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

	# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
	#
	#  These will help people to find your library, and whilst it
	#  can feel like a chore to fill in it's definitely to your advantage. The
	#  summary should be tweet-length, and the description more in depth.
	#

	s.name         	= "FAAdapt"
	s.version      	= "0.0.5"
	s.summary      	= "Object mapper for objective-c"

	s.description  	= <<-DESC
					A longer description of FAAdapt in Markdown format.

					* Think: Why did you write this? What is the focus? What does it do?
					* CocoaPods will be using this to generate tags, and improve search results.
					* Try to keep it short, snappy and to the point.
					* Finally, don't worry about the indent, CocoaPods strips it!
					DESC

	s.homepage		= "https://github.com/Softshag/FAAdapt"

	s.license 		= { :type => "MIT", :file => "LICENSE" }

	s.author    	= { "Softshag & Me" => "admin@softshag.dk" }

	s.source       	= { :git => "https://github.com/Softshag/FAAdapt.git", :tag => "v#{s.version}" }

	s.ios.deployment_target = "6.0"
	s.osx.deployment_target = "10.7"

	s.requires_arc = true

	s.default_subspec = 'Core'

	s.subspec 'Core' do |cs|
		cs.dependency "RKValueTransformers", "~> 1.1.0"
		s.source_files = "Pod/Classes/Categories/*.{h,m}", "Pod/Classes/*.{h,m}", "Pod/Classes/Adaptors/*.{h,m}"
	end

	s.subspec 'CoreData' do |cdcs|
		cdcs.frameworks = 'CoreData'
		cdcs.source_files = "Pod/Classes/CoreData/*.{h,m}"
	end

end