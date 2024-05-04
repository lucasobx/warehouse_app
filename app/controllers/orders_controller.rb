class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order_and_check_user, only: [:show, :edit, :update, :delivered, :canceled]

  def index
    @orders = current_user.orders
  end
  
  def show; end

  def new
    @order = Order.new
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

  def create
    @order = Order.new(params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date))
    @order.user = current_user
    if @order.save
      redirect_to @order, notice: 'Pedido registrado com sucesso.'
    else
      @warehouses = Warehouse.all
      @suppliers = Supplier.all
      flash.now[:notice] = 'Não foi possível registrar o pedido.'
      render 'new', status: 422
    end
  end

  def edit
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

  def update
    order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
    @order.update(order_params)
    redirect_to @order, notice: 'Pedido atualizado com sucesso.'
  end

  def search
    @code = params["query"]
    @orders = Order.where("code LIKE ?", "%#{@code}%")
  end

  def delivered
    @order.delivered!

    @order.order_items.each do |item| #criar um método no model ao invés de deixar no controller
      item.quantity.times do
        StockProduct.create!(order: @order, product_model: item.product_model, warehouse: @order.warehouse)
      end
    end
    
    redirect_to @order
  end

  def canceled
    @order.canceled!
    redirect_to @order
  end
  
  private

  def set_order_and_check_user
    @order = Order.find(params[:id])
    if @order.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a este pedido.'
    end
  end
end