FactoryBot.define do
  # factory :book do
  #   title { 'The Lord of the Comic' }
  #   genre { 'Comedy' }
  #   publication_date { '1977' }
  #   deleted_at { nil }
  #   association :author
  # end

  factory :book do
    sequence(:title) { |n| "#{n}" }
    sequence(:genre) { |n| "#{n}" }
    sequence(:publication_date) { |n| "#{n}" }
    deleted_at { nil }
    association :author
  end
end
