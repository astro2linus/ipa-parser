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
    end

    def info
      @ipa_file.each do |entry|
        if entry.name.match(/Payload\/(.)*\.app\/Info.plist/)
          @plist_path = entry.name
          @plist_bin = entry.get_input_stream.read
        end
      end

      plist = CFPropertyList::List.new(:data => @plist_bin)
      data = CFPropertyList.native_types(plist.value)
    end

    def icons
      matched_entries = []
      icon_file_names.each do |file_name|
        @ipa_file.each do |entry|
          if entry.name.match(/Payload\/(.)*\.app\/#{file_name}(.)*.png/)
            matched_entries << @ipa_file.read(entry.name)
          end
        end
      end
      matched_entries
    end

    # normally the last icon has the highest resolution
    # icons in the ipa file are crushed, cannot display in browsers other than Safari
    def crushed_icon
      icons.last
    end

    def icon_file_names
      begin
        # icon names may or may not include '.png', so remove .png suffix for consistence 
        info["CFBundleIcons"]["CFBundlePrimaryIcon"]["CFBundleIconFiles"].map { |f| File::basename(f, '.png' ) }
      rescue NoMethodError => e
        []
      end
    end

    def icon
      if crushed_icon
        crushed_file = Tempfile.new('crushed_icon.png')
        uncrushed_file = Tempfile.new('uncrushed_icon.png')
        begin 
          crushed_file.write(crushed_icon)
          png_bin =  File.expand_path("../../bin/pngcrush", __FILE__)
          cmd = "#{png_bin} -revert-iphone-optimizations "
          cmd << crushed_file.path + " " + uncrushed_file.path
          `#{cmd}`
          @data = uncrushed_file.read
        ensure
          crushed_file.close
          uncrushed_file.close
          crushed_file.unlink
          uncrushed_file.unlink
        end
      end
      @data
    end

  end
end
