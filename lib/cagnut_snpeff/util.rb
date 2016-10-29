module CagnutSnpeff
  class Util
    attr_accessor :snpeff

    def initialize
      @snpeff = CagnutSnpeff::Base.new
    end

    def snp_annotation dirs, order=1, previous_job_id=nil, filename=nil
      job_name = snpeff.snp_annotation dirs, order, previous_job_id, filename
      [job_name, order]
    end
  end
end
