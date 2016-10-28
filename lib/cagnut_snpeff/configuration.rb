require 'singleton'

module CagnutSnpeff
  class Configuration
    include Singleton
    attr_accessor :annotation_params

    class << self
      def load config, tools_config
        instance.load config, tools_config
      end
    end

    def load config, tools_config
      @config = config
      @tools_config = tools_config
      attributes.each do |name, value|
        send "#{name}=", value if respond_to? "#{name}="
      end
    end

    def attributes
      {
        annotation_params: annotation_params_setup
      }
    end

    private

    def annotation_params_setup
      {
        'java' => add_java_params,
        'params' => add_annotation_options
      }
    end

    def add_java_params verbose=false
      return if @tools_config['annotation'].blank?
      array =  @tools_config['annotation']['java'].dup
      array << "-verbose:sizes" if verbose
      array << "-jar #{@config['tools']['snpeff']}"
    end

    def add_annotation_options
      return if @tools_config['annotation'].blank?
      array =  @tools_config['annotation']['params'].dup
      array << @config['refs']['snpeff']['db']
      array << snpeff_config_tag if snpeff_config_tag
      array.uniq
    end

    def snpeff_config_tag
      config = @config['refs']['snpeff']['config']
      config.nil? ? nil : "-c #{config}"
    end
  end
end
