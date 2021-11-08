# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

stephen =
  Author.create(
    first_name: 'Stephen',
    last_name: 'King',
    date_of_birth: Date.parse('1947-09-21'),
    deleted_at: nil,
  )
lee =
  Author.create(
    first_name: 'Lee',
    last_name: 'Child',
    date_of_birth: Date.parse('1954-10-29'),
    deleted_at: nil,
  )
rolling =
  Author.create(
    first_name: 'J.K',
    last_name: 'Rolling',
    date_of_birth: Date.parse('1976-10-11'),
    deleted_at: nil,
  )

Book.create(
  title: 'The Shining',
  author: stephen,
  publication_date: 1977,
  genre: 'Horror',
  deleted_at: nil,
)
Book.create(
  title: 'Carrie',
  author: stephen,
  publication_date: 1974,
  genre: 'Horror',
  deleted_at: nil,
)
Book.create(
  title: 'It',
  author: stephen,
  publication_date: 1986,
  genre: 'Horror',
  deleted_at: nil,
)
Book.create(
  title: 'Green mile',
  author: stephen,
  publication_date: 1996,
  genre: 'Mystery',
  deleted_at: nil,
)
Book.create(
  title: 'Killing Floor',
  author: lee,
  publication_date: 1997,
  genre: 'Thriller',
  deleted_at: nil,
)
Book.create(
  title: 'Die Trying',
  author: lee,
  publication_date: 1998,
  genre: 'Thriller',
  deleted_at: nil,
)
Book.create(
  title: 'Harry Potter and Chamber of Secret',
  author: rolling,
  publication_date: 1999,
  genre: 'Harry_Potter',
  deleted_at: nil,
)
Book.create(
  title: 'Harry Potter and Wizard`s stone',
  author: rolling,
  publication_date: 1996,
  genre: 'Harry_Potter',
  deleted_at: nil,
)
Book.create(
  title: 'Harry Potter is God-God',
  author: rolling,
  publication_date: 2001,
  genre: 'Harry_Potter',
  deleted_at: nil,
)
