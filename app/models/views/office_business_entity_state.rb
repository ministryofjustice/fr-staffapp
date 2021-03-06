module Views
  class OfficeBusinessEntityState
    def initialize(office, jurisdiction)
      @office = office
      @jurisdiction = jurisdiction
      @business_entity = BusinessEntity.current_for(office, jurisdiction)
      @office_jurisdiction = OfficeJurisdiction.find_by(office: office, jurisdiction: jurisdiction)
    end

    def jurisdiction_id
      @jurisdiction.id
    end

    def jurisdiction_name
      @jurisdiction.name
    end

    def business_entity_id
      @business_entity&.id
    end

    def business_entity_code
      @business_entity&.be_code
    end

    def business_entity_sop_code
      @business_entity&.sop_code
    end

    def business_entity_name
      @business_entity&.name
    end

    def status
      if can_be_deleted?
        'delete'
      elsif can_be_updated?
        'edit'
      elsif can_be_added?
        'add'
      end
    end

    def sequence
      lookup_state
    end

    private

    def can_be_updated?
      @office_jurisdiction && @business_entity
    end

    def can_be_deleted?
      @office_jurisdiction.nil? && @business_entity
    end

    def can_be_added?
      @business_entity.nil?
    end

    def lookup_state
      { 'delete' => 0,
        'edit' => 1,
        'add' => 2 }[status]
    end

  end
end
