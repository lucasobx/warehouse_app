require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'gera um número de série' do
    it 'ao criar um StockProduct' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '1234748596',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, status: :delivered,
                            estimated_delivery_date: 1.week.from_now)
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5, height: 70, width: 75, depth: 80,
                                     sku: 'CGMER-XPTO-888', supplier: supplier)


      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

      expect(stock_product.serial_number.length).to eq 20
    end

    it 'e não é modificado' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      other_warehouse = Warehouse.create!(name: 'Guarulhos', code: 'GRU', address: 'Endereço', cep: '15000-000',
                                          city: 'Guarulhos', area: 1000, description: 'Alguma descrição')              
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '1234748596',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, status: :delivered,
                            estimated_delivery_date: 1.week.from_now)
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5, height: 70, width: 75, depth: 80,
                                     sku: 'CGMER-XPTO-888', supplier: supplier)
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      original_serial_number = stock_product.serial_number

      stock_product.update!(warehouse: other_warehouse)

      expect(stock_product.serial_number).to eq original_serial_number
    end
  end

  describe '#available?' do
    it 'true se não tiver destino' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '1234748596',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, status: :delivered,
                            estimated_delivery_date: 1.week.from_now)
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5, height: 70, width: 75, depth: 80,
                                     sku: 'CGMER-XPTO-888', supplier: supplier)

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)

      expect(stock_product.available?).to eq true     
    end

    it 'false se tiver destino' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                    city: 'Rio', area: 1000, description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '1234748596',
                                  full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, status: :delivered,
                            estimated_delivery_date: 1.week.from_now)
      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5, height: 70, width: 75, depth: 80,
                                     sku: 'CGMER-XPTO-888', supplier: supplier)

      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      stock_product.create_stock_product_destination!(recipient: 'Joao', address: 'Rua do Joao')

      expect(stock_product.available?).to eq false
    end
  end
end
