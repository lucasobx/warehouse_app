require 'rails_helper'

describe 'User creates an account' do
  it 'successfully' do
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    fill_in 'Nome', with: 'Maria'
    fill_in 'E-mail', with: 'maria@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar Conta'

    expect(page).to have_content 'Boas Vindas! Você realizou seu registro com sucesso.'
    expect(page).to have_content 'maria@email.com'
    expect(page).to have_link 'Sair'
    user = User.last
    expect(user.name).to eq 'Maria'
  end
end