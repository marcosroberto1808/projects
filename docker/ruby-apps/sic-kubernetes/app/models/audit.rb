class Audit < ActiveRecord::Base
  self.table_name = "public.audits"
  has_many :andamentos
end
