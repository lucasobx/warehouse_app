require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    it 'nome é obrigatório' do
      supplier = Supplier.create!(corporate_name: 'Samsung Eletronicos LTDA', brand_name: 'Samsung',
                                  registration_number: '4789855698', full_address: 'Av Nacoes Unidas, 1000',
                                  city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
      pm = ProductModel.new(name: '', weight: 8000, width: 70, height: 45, depth: 10,
                            sku: 'TV32-SAMSU-XPT090', supplier: supplier)

      expect(pm.valid?).to eq false
    end

    it 'sku é obrigatório' do
      supplier = Supplier.create!(corporate_name: 'Samsung Eletronicos LTDA', brand_name: 'Samsung',
                                  registration_number: '4789855698', full_address: 'Av Nacoes Unidas, 1000',
                                  city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
      pm = ProductModel.new(name: 'TV32', weight: 8000, width: 70, height: 45, depth: 10,
                            sku: '', supplier: supplier)

      expect(pm.valid?).to eq false
    end
  end
end
