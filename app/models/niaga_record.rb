class NiagaRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :niagahost
end
