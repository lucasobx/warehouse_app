require 'rails_helper'

describe 'Usuário edita pedido' do
  it 'e deve estar autenticado' do
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    visit edit_order_path(order.id)

    expect(current_path). to eq new_user_session_path
  end

  it 'com sucesso' do
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    Supplier.create!(corporate_name: 'Spark Industries LTDA', brand_name: 'Spark', registration_number: '3256398745',
                     full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@spark.com')
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: '12/12/2043'
    select 'Spark Industries LTDA', from: 'Fornecedor'
    click_on 'Gravar'

    expect(page).to have_content 'Pedido atualizado com sucesso.'
    expect(page).to have_content 'Fornecedor: Spark Industries LTDA'
    expect(page).to have_content 'Data Prevista de Entrega: 12/12/2043'
  end

  it 'caso seja o responsável' do
    andre = User.create!(name: 'Andre', email: 'andre@email.com', password: '12345678')
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(andre)
    visit edit_order_path(order.id)

    expect(current_path). to eq root_path
  end
end