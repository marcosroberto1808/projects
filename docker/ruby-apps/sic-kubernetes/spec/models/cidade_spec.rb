require 'rails_helper'

RSpec.describe Cidade, type: :model do
  it "has a valid" do
    record = Cidade.new
    record.nome = 'Fortaleza'
    record.uf = 'CE'
    expect(record).to be_valid
  end
end
