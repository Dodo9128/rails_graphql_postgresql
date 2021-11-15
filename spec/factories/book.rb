FactoryBot.define do
  # factory :book do
  #   title { 'The Lord of the Comic' }
  #   genre { 'Comedy' }
  #   publication_date { '1977' }
  #   deleted_at { nil }
  #   association :author
  # end

  factory :book do
    sequence(:title) { |n| "This is Testbook #{n}" }
    sequence(:genre) { 'Horror' }
    sequence(:publication_date) { 1984 }
    deleted_at { nil }
    association :author
  end
end
