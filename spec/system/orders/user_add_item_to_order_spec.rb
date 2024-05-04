require 'rails_helper'

describe 'Usuário adiciona itens ao pedido' do
  it 'com sucesso' do
    user = User.create!(name: 'Joao Almeida', email: 'user@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30,
                                     supplier: supplier, sku: 'PRODUTOA')
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20, depth: 30,
                                     supplier: supplier, sku: 'PRODUTOB')       

    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    select 'Produto A', from: 'Produto'
    fill_in 'Quantidade', with: '8'
    click_on 'Gravar'

    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content '8 x Produto A'
  end

  it 'e não vê produtos de outro fornecedor' do
    user = User.create!(name: 'Joao Almeida', email: 'user@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')

    supplier_a = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                  email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    supplier_b = Supplier.create!(corporate_name: 'Spark Industries LTDA', brand_name: 'Spark', registration_number: '3256398745',
                                  full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@spark.com')

    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier_a, estimated_delivery_date: 1.day.from_now)

    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30,
                                     supplier: supplier_a, sku: 'PRODUTOA')
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20, depth: 30,
                                     supplier: supplier_b, sku: 'PRODUTOB')

    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    expect(page).to have_content 'Produto A'
    expect(page).not_to have_content 'Produto B'
  end
end