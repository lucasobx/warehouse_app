require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
    andre = User.create!(name: 'Andre', email: 'andre@email.com', password: '12345678')
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: '12345678')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Av do Aeroporto, 1000', cep: '15000-000', description: 'Perto do Aeroporto')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '43447216000102',
                                email: 'contato@acme.com', full_address: 'Av das Palmas, 100', city: 'Bauru', state: 'SP')
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    login_as(andre)
    patch(order_path(order.id), params: { order: { supplier_id: 3}})

    expect(response).to redirect_to(root_path)
  end
end