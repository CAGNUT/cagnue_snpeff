module CagnutSnpeff
  class SnpAnnotation
    extend Forwardable

    def_delegators :'Cagnut::Configuration.base', :sample_name, :jobs_dir, :java_path,
                   :ref_fasta, :prefix_name, :dodebug
    def_delegators :'CagnutSnpeff.config', :annotation_params

    def initialize opts = {}
      @order = sprintf '%02i', opts[:order]
      @input = opts[:input].nil? ? "#{opts[:dirs][:input]}/#{sample_name}.vcf" : opts[:input]
      @output = "#{opts[:dirs][:output]}/#{sample_name}_snpeff.vcf"
      @job_name = "#{prefix_name}_snpEff_#{sample_name}"
    end

    def run previous_job_id = nil
      puts "Submitting snpAnnotation #{sample_name} Jobs"
      script_name = generate_script
      ::Cagnut::JobManage.submit script_name, @job_name, cluster_options(previous_job_id)
      @job_name
    end

    def cluster_options previous_job_id = nil
      {
        previous_job_id: previous_job_id,
        adjust_memory: ['h_stack=256M', 'h_vmem=8G'],
        tools: ['snpeff', 'annotation']
      }
    end

    def annotation_options
      array = annotation_params['params'].dup
      array << "#{@input} > #{@output}"
      array.uniq
    end

    def modified_java_array
      array = annotation_params['java'].dup
      array.unshift(java_path).uniq
    end

    def params_combination_hash
      @params_combination_hash ||= {
        'java' => modified_java_array,
        'params' => annotation_options
      }
    end

    def generate_script
      script_name = "#{@order}_snpeff_snp_annotation"
      file = File.join jobs_dir, "#{script_name}.sh"
      File.open(file, 'w') do |f|
        f.puts <<-BASH.strip_heredoc
          #!/bin/bash

          cd "#{jobs_dir}/../"
          echo "#{script_name} is starting at $(date +%Y%m%d%H%M%S)" >> "#{jobs_dir}/finished_jobs"

          #{params_combination_hash['java'].join("\s")} \\
            #{params_combination_hash['params'].join(" \\\n            ")} \\
            #{::Cagnut::JobManage.run_local}

          EXITSTATUS=$?

          #force error when missing output
          if [ ! -s "#{@output}" ]; then exit 100;fi;
          if [ $(grep -cv "^#" "#{@output}") -eq "0" ]
          then
            echo "No variants!"
            exit 100;
          fi

          if [ $EXITSTATUS -eq 1 ];then
            echo "Error in Java"
            exit 100
          fi
          echo "#{script_name} is finished at $(date +%Y%m%d%H%M%S)" >> "#{jobs_dir}/finished_jobs"

        BASH
      end
      File.chmod(0700, file)
      script_name
    end
  end
end
