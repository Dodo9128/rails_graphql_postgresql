class Book < ApplicationRecord
  belongs_to :author

  validates :title, length: { minimum: 1 }
  validates :publication_date, presence: true
  validates :genre, presence: true
  validates :author_id, presence: true
end
