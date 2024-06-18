require 'rails_helper'

describe 'User views the stock' do
  it 'on the warehouse screen' do
    user = User.create!(name: 'André', email: 'andre@email.com', password: '12345678')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                          address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                          description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletronicos LTDA', brand_name: 'Samsung',
                                registration_number: '4789855698', full_address: 'Av Nacoes Unidas, 1000',
                                city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    produto_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                                      sku: 'TV32-SAMSU-XPT090', supplier: supplier)
    produto_soundbar = ProductModel.create!(name: 'SoundBar 7.1', weight: 3000, width: 80, height: 15, depth: 20,
                                            sku: 'SOU71-SAMSU-N77', supplier: supplier)
    produto_notebook = ProductModel.create!(name: 'Notebook i5 16GB RAM', weight: 2000, width: 40, height: 9, depth: 20,
                                            sku: 'NOTEI5-SAMSU-TLI99', supplier: supplier)

    3.times { StockProduct.create!(order: order, warehouse: w, product_model: produto_tv) }
    2.times { StockProduct.create!(order: order, warehouse: w, product_model: produto_notebook) }

    login_as user
    visit root_path
    click_on 'Aeroporto SP'

    within 'section#stock_products' do
      expect(page).to have_content 'Itens em Estoque'
      expect(page).to have_content '3 x TV32-SAMSU-XPT090'
      expect(page).to have_content '2 x NOTEI5-SAMSU-TLI99'
      expect(page).not_to have_content 'SOU71-SAMSU-N77'
    end
  end

  it 'and removes an item' do
    user = User.create!(name: 'André', email: 'andre@email.com', password: '12345678')
    w = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                          address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                          description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'Samsung Eletronicos LTDA', brand_name: 'Samsung',
                                registration_number: '4789855698', full_address: 'Av Nacoes Unidas, 1000',
                                city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')
    order = Order.create!(user: user, supplier: supplier, warehouse: w, estimated_delivery_date: 1.day.from_now)
    produto_tv = ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10,
                                      sku: 'TV32-SAMSU-XPT090', supplier: supplier)
    2.times { StockProduct.create!(order: order, warehouse: w, product_model: produto_tv) }

    login_as user
    visit root_path
    click_on 'Aeroporto SP'
    select 'TV32-SAMSU-XPT090', from: 'Item para Saída'
    fill_in 'Destinatário', with: 'Maria Ferreira'
    fill_in 'Endereço Destino', with: 'Rua das Palmeiras, 100 - Campinas - São Paulo'
    click_on 'Confirmar Retirada'

    expect(current_path).to eq warehouse_path(w.id)
    expect(page).to have_content 'Item retirado com sucesso'
    expect(page).to have_content '1 x TV32-SAMSU-XPT090'
  end
end