require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe 'valid?' do
    context 'presence' do
      #não precisa usar .create pois apenas com .new já é possível verificar 'valid?'
      it 'falso quando name está vazio' do
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                  city: 'Rio', area: 1000, description: 'Alguma descrição')
        
        expect(warehouse.valid?).to eq false
      end

      it 'falso quando code está vazio' do
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Endereço', cep: '25000-000',
                                  city: 'Rio', area: 1000, description: 'Alguma descrição')
        
        expect(warehouse.valid?).to eq false
      end

      it 'falso quando address está vazio' do
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: '', cep: '25000-000',
                                  city: 'Rio', area: 1000, description: 'Alguma descrição')
        
        expect(warehouse.valid?).to eq false
      end

      it 'falso quando cep está vazio' do
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '',
                                  city: 'Rio', area: 1000, description: 'Alguma descrição')
        
        expect(warehouse.valid?).to eq false
      end

      it 'falso quando city está vazio' do
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                  city: '', area: 1000, description: 'Alguma descrição')
        
        expect(warehouse.valid?).to eq false
      end

      it 'falso quando area está vazio' do
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                  city: 'Rio', area: '', description: 'Alguma descrição')
        
        expect(warehouse.valid?).to eq false
      end

      it 'falso quando description está vazio' do
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                  city: 'Rio', area: 1000, description: '')
        
        expect(warehouse.valid?).to eq false
      end
    end

    it 'falso quando code está em uso' do
      #precisa usar .create no primeiro pois é necessário armazená-lo no db para fazer a comparação
      first_warehouse = Warehouse.create!(name: 'Rio', code: 'RIO', address: 'Endereço', cep: '25000-000',
                                          city: 'Rio', area: 1000, description: 'Alguma descrição')

      second_warehouse = Warehouse.new(name: 'Niteroi', code: 'RIO', address: 'Avenida', cep: '35000-000',
                                       city: 'Niteroi', area: 1500, description: 'Outra descrição')

      expect(second_warehouse.valid?).to eq false
    end
  end

  describe '#full_description' do
    it 'exibe o nome e o código' do
      w = Warehouse.new(name: 'Galpão Cuiabá', code: 'CBA')

      result = w.full_description

      expect(result).to eq 'CBA - Galpão Cuiabá'
    end
  end
end
