class Author < ApplicationRecord
  has_many :books

  validates :first_name, length: { minimum: 1 }
  validates :last_name, length: { minimum: 1 }
  validates :date_of_birth, length: { is: 10 }
end
