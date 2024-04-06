class WarehousesController < ApplicationController
  def show
    @warehouse = Warehouse.find(params[:id])
  end

  def new
    @warehouse = Warehouse.new
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)
    if @warehouse.save
      redirect_to root_path, notice: "Galpão cadastrado com sucesso."
    else
      flash.now[:notice] = 'Galpão não cadastrado.'
      render 'new', status: 422
    end
  end

  private
  def warehouse_params
    params.require(:warehouse).permit(:name, :code, :city, :area, :address, :cep, :description)
  end
end