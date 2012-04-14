require 'active_model'

class CsvUniqnessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << 'already exists' if record.class.where(attribute => value).count > 1
  end
end
