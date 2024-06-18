require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#description' do
    it 'displays the name and the email' do
      u = User.new(name: 'Julia Almeida', email: 'julia@email.com')

      result = u.description

      expect(result).to eq 'Julia Almeida - julia@email.com'
    end
  end
end
