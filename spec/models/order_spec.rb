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
                        estimated_delivery_date: '10/10/2050')
      
      expect(order.valid?).to be true
    end

    it 'data estimada de entrega deve ser obrigatória' do
      order = Order.new(estimated_delivery_date: '')

      order.valid?
      expect(order.errors.include? :estimated_delivery_date).to be true
    end

    it 'data estimada de entrega não deve ser passada' do
      order = Order.new(estimated_delivery_date: 1.day.ago)

      order.valid?

      expect(order.errors.include? :estimated_delivery_date).to be true
      expect(order.errors[:estimated_delivery_date]).to include "deve ser futura."
    end

    it 'data estimada de entrega não deve ser igual a hoje' do
      order = Order.new(estimated_delivery_date: Date.today)

      order.valid?

      expect(order.errors.include? :estimated_delivery_date).to be true
      expect(order.errors[:estimated_delivery_date]).to include "deve ser futura."
    end

    it 'data estimada de entrega deve ser igual ou maior que amanhã' do
      order = Order.new(estimated_delivery_date: 1.day.from_now)

      order.valid?

      expect(order.errors.include? :estimated_delivery_date).to be false
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
                        estimated_delivery_date: '10/10/2050')

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
                                  estimated_delivery_date: '10/10/2050')
      second_order = Order.new(user: user, warehouse: warehouse, supplier: supplier,
                               estimated_delivery_date: '10/10/2050')

      second_order.save!

      expect(second_order.code).not_to eq first_order.code
    end

    it 'e não deve ser modificado' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '1234748596',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                            estimated_delivery_date: 1.week.from_now)
      original_code = order.code

      order.update!(estimated_delivery_date: 1.month.from_now)

      expect(order.code).to eq original_code
    end
  end
end
