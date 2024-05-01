require 'rails_helper'

describe 'Usuário busca por um pedido' do
  it 'a partir do menu' do
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')

    login_as(user)
    visit root_path

    within 'header nav' do
      expect(page).to have_field 'Buscar Pedido'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'e deve estar autenticado' do
    visit root_path

    
    within 'header nav' do
      expect(page).not_to have_field 'Buscar Pedido'
      expect(page).not_to have_button 'Buscar'
    end
  end

  it 'e encontra um pedido' do
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Galpão Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                      address: 'Av Atlantica, 50', cep: '80000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'Spark Industries LTDA', brand_name: 'Spark', registration_number: '3256398745',
                                full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@spark.com')
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'

    expect(page).to have_content "Resultados da Busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content 'Galpão Destino: MCZ - Galpão Maceio'
    expect(page).to have_content 'Fornecedor: Spark Industries LTDA'
  end

  it 'e encontra múltiplos pedidos' do
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    f_warehouse = Warehouse.create!(name: 'Galpão Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                                    address: 'Av Atlantica, 50', cep: '80000-000', description: 'Perto do Aeroporto')
    s_warehouse = Warehouse.create!(name: 'Aeroporto Rio', code: 'SDU', city: 'Rio de Janeiro', area: 50_000,
                                    address: 'Av do Porto, 50', cep: '25000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'Spark Industries LTDA', brand_name: 'Spark', registration_number: '3256398745',
                                full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@spark.com')

    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('MCZ12345')                           
    f_order = Order.create!(user: user, warehouse: f_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('MCZ98765') 
    s_order = Order.create!(user: user, warehouse: f_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('SDU00000')
    t_order = Order.create!(user: user, warehouse: s_warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: 'MCZ'
    click_on 'Buscar'

    expect(page).to have_content 'MCZ12345'
    expect(page).to have_content 'MCZ98765'
    expect(page).to have_content 'Galpão Destino: MCZ - Galpão Maceio'
    expect(page).not_to have_content 'SDU00000'
    expect(page).not_to have_content 'Galpão Destino: SDU - Aeroporto Rio'
  end
end