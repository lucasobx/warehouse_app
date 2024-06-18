require 'rails_helper'

describe 'User views their own orders' do
  it 'and must be authenticated' do
    visit root_path
    click_on 'Meus Pedidos'

    expect(current_path).to eq new_user_session_path
  end

  it 'and does not see other orders' do
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    carla = User.create!(name: 'Carla', email: 'carla@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    
    f_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                            estimated_delivery_date: 1.day.from_now, status: 'pending')
    s_order = Order.create!(user: carla, warehouse: warehouse, supplier: supplier,
                            estimated_delivery_date: 1.day.from_now, status: 'delivered')
    t_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                            estimated_delivery_date: 1.week.from_now, status: 'canceled')

    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'

    expect(page).to have_content f_order.code
    expect(page).to have_content 'Pendente'
    expect(page).not_to have_content s_order.code
    expect(page).not_to have_content 'Entregue'
    expect(page).to have_content t_order.code
    expect(page).to have_content 'Cancelado'
  end

  it 'and visits an order' do
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    expect(page).to have_content 'Detalhes do Pedido'
    expect(page).to have_content order.code
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
    formatted_date = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
  end

  it 'and does not visit orders from other users' do
    andre = User.create!(name: 'Andre', email: 'andre@email.com', password: '12345678')
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(andre)
    visit order_path(order.id)

    expect(current_path).not_to eq order_path(order.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este pedido.'
  end

  it 'and sees the items in the order' do
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    product_a = ProductModel.create!(name: 'Produto A', weight: 15, width: 10, height: 20, depth: 30,
                                     supplier: supplier, sku: 'PRODUTOA')
    product_b = ProductModel.create!(name: 'Produto B', weight: 15, width: 10, height: 20, depth: 30,
                                     supplier: supplier, sku: 'PRODUTOB')
    product_c = ProductModel.create!(name: 'Produto C', weight: 15, width: 10, height: 20, depth: 30,
                                     supplier: supplier, sku: 'PRODUTOC')

    user = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    OrderItem.create!(product_model: product_a, order: order, quantity: 19)
    OrderItem.create!(product_model: product_b, order: order, quantity: 12)

    login_as user
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    expect(page).to have_content 'Itens do Pedido'
    expect(page).to have_content '19 x Produto A'
    expect(page).to have_content '12 x Produto B'
  end
end