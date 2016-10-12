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
      info_plist = @ipa_file.glob('*\/Info.plist').first || @ipa_file.glob('Payload\/*\.app\/Info.plist').first
      if info_plist
        @plist_path = info_plist.name
        @plist_bin = info_plist.get_input_stream.read
        @plist = CFPropertyList::List.new(:data => @plist_bin)
      else
        raise "Cannot find Info.plist file"
      end
    end

    def info
      CFPropertyList.native_types(@plist.value)
    end
  end
end

