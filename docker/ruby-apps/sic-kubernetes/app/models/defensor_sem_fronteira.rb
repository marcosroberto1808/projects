class DefensorSemFronteira < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
	  		 :authentication_keys => [:pessoa_fisica_cpf, :ativo]
end
