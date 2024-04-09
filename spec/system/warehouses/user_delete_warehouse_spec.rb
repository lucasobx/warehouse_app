require 'rails_helper'

describe 'Usuário remove um galpão' do
  it 'com sucesso' do
    Warehouse.create!(name: 'Cuiaba', code: 'CWB', area: 10000, cep: '56000-000', city: 'Cuiabá',
                      address: 'Av dos Jacarés, 1000', description: 'Galpão no centro do país')

    visit root_path
    click_on 'Cuiaba'
    click_on 'Remover'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso.'
    expect(page).not_to have_content 'Cuiaba'
    expect(page).not_to have_content 'CWB'
  end

  it 'e não apaga outros galpões' do
    first_warehouse = Warehouse.create!(name: 'Cuiaba', code: 'CWB', area: 10000, cep: '56000-000', city: 'Cuiabá',
                                        address: 'Av dos Jacarés, 1000', description: 'Galpão no centro do país')
    second_warehouse = Warehouse.create!(name: 'Belo Horizonte', code: 'BHZ', area: 20000, cep: '46000-000', city: 'Belo Horizonte',
                                         address: 'Av Tiradentes, 20', description: 'Galpão para cargas mineiras')

    visit root_path
    click_on 'Cuiaba'
    click_on 'Remover'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso.'
    expect(page).to have_content 'Belo Horizonte'
    expect(page).not_to have_content 'Cuiaba'
  end
end