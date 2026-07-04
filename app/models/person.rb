class Person < ApplicationRecord
  has_many :follows, as: :followable, dependent: :destroy
end
