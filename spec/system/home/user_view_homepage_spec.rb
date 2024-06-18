require 'rails_helper'

describe 'User visits homepage' do
  it 'and sees the app name' do
    visit root_path

    expect(page).to have_content 'Galpões & Estoque'
    expect(page).to have_link 'Galpões & Estoque', href: root_path
  end

  it 'and sees the registered warehouses' do
    Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                      address: 'Av do Porto, 1000', cep: '20000-000', description: 'Galpão do Rio')
    Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000,
                      address: 'Av Atlantica, 50', cep: '80000-000', description: 'Perto do Aeroporto')

    visit root_path

    expect(page).not_to have_content('Não existem galpões cadastrados.')
    expect(page).to have_content 'Rio'
    expect(page).to have_content 'Código: SDU'
    expect(page).to have_content 'Cidade: Rio de Janeiro'
    expect(page).to have_content '60000 m2'

    expect(page).to have_content 'Maceio'
    expect(page).to have_content 'Código: MCZ'
    expect(page).to have_content 'Cidade: Rio de Janeiro'
    expect(page).to have_content '50000 m2'
  end

  it 'and there are no registered warehouses' do
    visit root_path
    
    expect(page).to have_content 'Não existem galpões cadastrados.'
  end
end