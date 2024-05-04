require 'rails_helper'

describe 'Usuário informa novo status de pedido' do
  it 'e pedido foi entregue' do
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    Supplier.create!(corporate_name: 'Spark Industries LTDA', brand_name: 'Spark', registration_number: '3256398745',
                     full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@spark.com')

    product = ProductModel.create!(supplier: supplier, name: 'Cadeira Gamer', weight: 5, height: 100, width: 70,
                                   depth: 75, sku: 'CAD-GAMER-1234')
                    
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                          estimated_delivery_date: 1.day.from_now, status: :pending)

    OrderItem.create!(order: order, product_model: product, quantity: 5)

    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como ENTREGUE'

    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Status do Pedido: Entregue'
    expect(page).not_to have_button 'Marcar como CANCELADO'
    expect(page).not_to have_button 'Marcar como ENTREGUE'
    expect(StockProduct.count).to eq 5
    estoque = StockProduct.where(product_model: product, warehouse: warehouse).count
    expect(estoque).to eq 5
  end

  it 'e pedido foi cancelado' do
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')

    product = ProductModel.create!(supplier: supplier, name: 'Cadeira Gamer', weight: 5, height: 100, width: 70,
                                   depth: 75, sku: 'CAD-GAMER-1234')
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                          estimated_delivery_date: 1.day.from_now, status: :pending)
    OrderItem.create!(order: order, product_model: product, quantity: 5)

    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como CANCELADO'

    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Status do Pedido: Cancelado'  
    expect(StockProduct.count).to eq 0
  end
end