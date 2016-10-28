module CagnutSnpeff
  module CheckTools
    def check_tool tools_path, ref=nil
      super if defined?(super)
      check_snpeff tools['snpeff'], refs['snpeff']['db'], refs['snpeff']['config'] if @java
    end

      def check_snpeff path, db_version, config_path
        check_tool_ver 'snpEff' do
          `#{@java} -jar #{path} -version 2>&1` if path
        end

        if db_version.nil?
          @check_completed = false
          puts "\tNot Set Snpeff DB in config.yml"
        else
          puts "\tSnpeff DB: #{db_version}"
        end

        if config_path
          path = File.exist?(config_path) ? config_path : 'Not Found' if config_path
          puts "\tSnpeff config file: #{path}"
        else
          puts "\tSnpeff config Not Found"
        end
      end
  end
end

CagnutSnpeff.config::Checks::Tools.prepend CagnutSnpeff::CheckTools
