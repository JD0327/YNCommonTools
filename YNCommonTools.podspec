Pod::Spec.new do |s|
  s.name = 'YNCommonTools'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = '增加自定义app内部弹框以及设备静音判断'
  s.homepage = 'https://github.com/JD0327/YNCommonTools'
  s.authors = { 'GentlemanJ' => '1011001397@qq.com' }
  s.source = { :git => "https://github.com/JD0327/YNCommonTools.git", :tag => s.version}
  s.requires_arc = true

  s.dependency 'MJRefresh'

  s.ios.deployment_target = '8.0'

  s.resource     = 'YNCommonTools/Resources.bundle'
  
  s.source_files = 'YNCommonTools/YNCommonTools.h','YNCommonTools/YNCommonMethod.h'

  s.subspec 'Base' do |ss|
    ss.source_files = 'YNCommonTools/YNAppDelegate.{h,m}','YNCommonTools/YNBaseViewController.{h,m}'
    ss.public_header_files = 'YNCommonTools/YNAppDelegate.h','YNCommonTools/YNBaseViewController.h'
  end

  s.subspec 'Catetory' do |ss|
    ss.source_files = 'YNCommonTools/UIImage+YNExtension.{h,m}','YNCommonTools/NSDate+YNExtension.{h,m}','YNCommonTools/UIView+YNExtension.{h,m}'
    ss.public_header_files = 'YNCommonTools/UIImage+YNExtension.h','YNCommonTools/NSDate+YNExtension.h','YNCommonTools/UIView+YNExtension.h'
  end

  s.subspec 'Module' do |ss|

    ss.subspec 'Refresh' do |sss|
      sss.source_files = 'YNCommonTools/YNRefreshNormalFooter.{h,m}','YNCommonTools/YNRefreshNormalHeader.{h,m}','YNCommonTools/YNRefreshConfig.{h,m}'
      sss.public_header_files = 'YNCommonTools/YNRefreshNormalFooter.h','YNCommonTools/YNRefreshNormalHeader.h','YNCommonTools/YNRefreshConfig.h'
    end

    ss.subspec 'NavigationController' do |sss|
      sss.source_files = 'YNCommonTools/UIViewController+RTRootNavigationController.{h,m}','YNCommonTools/RTRootNavigationController.{h,m}'
      sss.public_header_files = 'YNCommonTools/UIViewController+RTRootNavigationController.h','YNCommonTools/RTRootNavigationController.h'
    end
    
    ss.subspec 'TWTextInputView' do |sss|
      sss.source_files = 'YNCommonTools/TWTextInputView.{h,m}'
      sss.public_header_files = 'YNCommonTools/TWTextInputView.h'
    end

    ss.subspec 'WSDatePickerView' do |sss|
      sss.source_files = 'YNCommonTools/WSDatePickerView.{h,m}'
      sss.public_header_files = 'YNCommonTools/WSDatePickerView.h'
      sss.dependency 'YNCommonTools/Catetory'
    end

    ss.subspec 'YNRBDMuteSwitch' do |sss|
      sss.source_files = 'YNCommonTools/YNRBDMuteSwitch.{h,m}'
      sss.public_header_files = 'YNCommonTools/YNRBDMuteSwitch.h'
    end

    ss.subspec 'YNBannerView' do |sss|
      sss.source_files = 'YNCommonTools/YNBannerView.{h,m}','YNCommonTools/YNBannerViewMaker.{h,m}','YNCommonTools/YNBannerShareManager.{h,m}'
      sss.public_header_files = 'YNCommonTools/YNBannerView.h','YNCommonTools/YNBannerViewMaker.h','YNCommonTools/YNBannerShareManager.h'
      sss.dependency 'YNCommonTools/Module/YNRBDMuteSwitch'
    end

  end

end
