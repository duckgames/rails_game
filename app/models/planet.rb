class Planet < ApplicationRecord
  belongs_to :empire, optional: true
end
