class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def to_json
    "#{self.class.name}Serializer".safe_constantize.new(self).serialized_json
  end
end
