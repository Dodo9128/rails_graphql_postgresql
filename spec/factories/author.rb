FactoryBot.define do
  # factory :author do
  #   first_name { 'C. K.' }
  #   last_name { 'Louis' }
  #   date_of_birth { '1942-02-13' }
  #   deleted_at { nil }
  # end

  # factory :author do
  #   sequence(:first_name) { |n| "#{n} C. K." }
  #   sequence(:last_name) { |n| "#{n} Louis" }
  #   sequence(:date_of_birth) { |n| "#{n} 1942-02-13" }
  #   deleted_at { nil }
  # end

  factory :author do
    sequence(:first_name) { |n| "#{n}" }
    sequence(:last_name) { |n| "#{n}" }
    sequence(:date_of_birth) { |n| "#{n}" }
    deleted_at { nil }
    # books { nil }
  end
end

# def user_without_book_maker()
#   user_props = {
#     first_name: 'C. K.',
#     last_name: 'Louis',
#     date_of_birth: '1999-09-19',
#     deleted_at: nil,
#   }
#   FactoryBot.create(:author, user_props)
# end

# def user_with_book_maker()
#   user_props = {
#     first_name: 'J. K.',
#     last_name: 'Tiger',
#     date_of_birth: '2009-03-14',
#     deleted_at: nil,
#   }

# FactoryBot.create(:author, user_props) do |user|
#   FactoryBot.create_list(
#     :book,
#     1,
#     title: 'Drunken Tiger',
#     genre: 'Hiphop',
#     publication_date: '2006',
#     deleted_at: nil,
#     association: :author,
#   )
# end

# FactoryBot.create(:author, user_props) do |user|
#   FactoryBot.create(
#     :book,
#     title: 'Drunken Tiger',
#     genre: 'Hiphop',
#     publication_date: '2006',
#     deleted_at: nil,
#     association: user,
#   )
# end

# end
