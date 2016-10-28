require 'cagnut_snpeff/functions/snp_annotation'

module CagnutSnpeff
  class Base
    def snp_annotation dirs, previous_job_id, input = nil
      opts = { input: input, dirs: dirs }
      snp_annotation = CagnutSnpeff::SnpAnnotation.new opts
      snp_annotation.run previous_job_id
    end
  end
end
