require 'millionaire'

class Sample
  include Millionaire::Csv

  column :name
  column :address
  column :phone
  column :email
end
