module CagnutSnpeff
  class Util
    attr_accessor :snpeff

    def initialize
      @snpeff = CagnutSnpeff::Base.new
    end

    def snp_annotation dirs, previous_job_id, filename = nil
      snpeff.snp_annotation dirs, previous_job_id, filename
    end
  end
end
