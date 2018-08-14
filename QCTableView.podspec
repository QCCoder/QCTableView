#
#  Be sure to run `pod spec lint QCHttpTool.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "QCTableView"
  s.version      = "1.0.0"
  s.summary      = "Lib of QC."
  s.description  = <<-DESC
                    Lib of QCTableView.
                   DESC

  s.homepage     = "https://github.com/QCCoder"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "qiancheng" => "596896692@qq.com" }
  s.source       = { :git => "https://github.com/QCCoder/QCTableView.git", :tag => "#{s.version}" }
  s.platform     = :ios, "8.0"

  s.source_files = 'QCTableView/QCTableView/**/*'
  s.public_header_files = 'QCTableView/QCTableView/**/*.h'
  s.resources = 'QCTableView/QCTableView/QCTableView.bundle'
  s.dependency 'MJRefresh'
  s.dependency 'DZNEmptyDataSet'
end
