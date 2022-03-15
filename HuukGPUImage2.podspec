Pod::Spec.new do |s|
    s.name     = 'HuukGPUImage2'
    s.module_name   = 'HuukGPUImage2'
    s.version  = '6.3.10'
    s.license  = 'BSD'
    s.summary  = 'An open source iOS framework for GPU-based image and video processing.'
    s.homepage = 'https://github.com/HuukSocial/GPUImage2'
    s.author   = { 'Brad Larson' => 'contact@sunsetlakesoftware.com' }
    s.source   = { :git => 'https://github.com/HuukSocial/GPUImage2.git', :tag => s.version }

    s.source_files = 'framework/Source/**/*.{swift,h,m}'
    s.resources = ['framework/Source/Operations/Shaders/*.{fsh}']
    s.requires_arc = true
    s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES',
                   'OTHER_SWIFT_FLAGS' => "$(inherited) -DGLES",
                   'VALIDATE_WORKSPACE_SKIPPED_SDK_FRAMEWORKS' => "OpenGLES" }

    s.ios.deployment_target = '10.0'
    s.ios.exclude_files = 'framework/Source/Mac', 'framework/Source/Linux', 'framework/Source/Operations/Shaders/ConvertedShaders_GL.swift'
    s.frameworks   = ['OpenGLES', 'CoreMedia', 'QuartzCore', 'AVFoundation']
    s.swift_version = '4.0'
end

