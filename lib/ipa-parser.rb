require "ipa-parser/version"
require 'cfpropertylist'
require 'zip'

module IpaParser
  class IpaFile

    MAPPED_INFO_KEYS = {
      name:                'CFBundleName',
      display_name:        'CFBundleDisplayName',
      identifier:          'CFBundleIdentifier',
      supported_platforms: 'CFBundleSupportedPlatforms',
      min_os_version:      'MinimumOSVersion',
      is_iphone:           'LSRequiresIPhoneOS',
      version:             'CFBundleVersion'
    }

    MAPPED_INFO_KEYS.each do |key, orig_key|
      define_method key do
        info[orig_key]
      end 
    end

    def initialize(ipa_file)
      @ipa_file = Zip::File.open(ipa_file)
      @ipa_file.each do |entry|
        if entry.name.match(/(.)*\.app\/Info.plist/)
          @plist_path = entry.name
          @plist_bin = entry.get_input_stream.read
        end
      end
      @plist = CFPropertyList::List.new(:data => @plist_bin)
    end

    def info
      CFPropertyList.native_types(@plist.value)
    end
  end
end
