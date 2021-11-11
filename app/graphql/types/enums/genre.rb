module Types
  module Enums
    class Genre < Types::BaseEnum
      description 'All available genres'

      value('Horror', 'super scary book')
      value('Thriller', 'super exciting book')
      value('Mystery', 'super interesting book')
      value('Harry_Potter', 'super Harry Potter')
      value('Comedy', 'super funny comedy')
      value('Romance', 'super lovely romance')
      value('Programming', 'super power coding')
    end
  end
end
