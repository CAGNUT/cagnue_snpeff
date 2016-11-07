require "cagnut_snpeff/version"

module CagnutSnpeff
  class << self
    def config
      @config ||= begin
        CagnutSnpeff::Configuration.load(Cagnut::Configuration.config, Cagnut::Configuration.params['snpeff'])
        CagnutSnpeff::Configuration.instance
      end
    end
  end
end

require 'cagnut_snpeff/configuration'
require 'cagnut_snpeff/check_tools'
require 'cagnut_snpeff/base'
require 'cagnut_snpeff/util'
