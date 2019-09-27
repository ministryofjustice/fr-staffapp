module Forms
  class Accuracy < ::FormObject

    def self.permitted_attributes
      {
        correct: Boolean,
        incorrect_reason: String,
        incorrect_reason_category: Array
      }
    end

    define_attributes

    validates :correct, inclusion: { in: [true, false] }
    validates :incorrect_reason, presence: true, length: { maximum: 500 },
                                 if: proc { |a| a.correct? == false }

    private

    def persist!
      @object.update(fields_to_update)
    end

    def fields_to_update
      self.incorrect_reason = nil if correct
      { correct: correct, incorrect_reason: incorrect_reason }
    end
  end
end
