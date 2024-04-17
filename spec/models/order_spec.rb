require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '1234748596',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier,
                        estimated_delivery_date: '2022-10-01')
      
      expect(order.valid?).to be true
    end
  end

  describe 'gera um código aleatório' do
    it 'ao criar um novo pedido' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '1234748596',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier,
                        estimated_delivery_date: '2022-10-01')

      order.save!
      result = order.code

      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end

    it 'e o código é único' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '1234748596',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                                  estimated_delivery_date: '2022-10-01')
      second_order = Order.new(user: user, warehouse: warehouse, supplier: supplier,
                               estimated_delivery_date: '2022-11-05')

      second_order.save!

      expect(second_order.code).not_to eq first_order.code
    end
  end
end
