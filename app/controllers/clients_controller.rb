class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy, :orders_index]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Client was successfully updated.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          OrderDetail.joins(:order).where(orders: { client_id: @client.id }).destroy_all
          Order.where(client_id: @client.id).destroy_all
          @client.destroy
        end

        format.html { redirect_to clients_url, notice: 'Client was successfully destroyed.' }
        format.json { head :no_content }
      rescue
        format.html { redirect_to clients_url, notice: 'Error. :p' }
        format.json { head :no_content }
      end
    end
  end

  def orders_index
    @orders = @client.orders
    @orders_totals = Hash[OrderDetail.where(order_number: @orders).group(:order_number).pluck(:order_number, "SUM(amount * price)")]
  end

  def orders_show
    @order = Order.where(client_id: params[:id]).find(params[:number])
    @order_details = OrderDetail.where(order_number: @order.number)
    @total = @order_details.sum("amount * price")
  end

  def orders_new
    @order = Order.new
  end

  def orders_create
    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          @order = Order.new(order_params)
          @order.client_id = params[:id]

          unless @order.save
            raise ''
          end

          if params.require(:order).has_key?(:products_ids_amount)
            products_prices = Hash[Product.pluck("id", "price")]

            products_ids_amount = params.require(:order).require(:products_ids_amount) \
              .split(",").map { |s| s.split "=" }
      
            order_details = products_ids_amount.map do |(product_id, amount)|
              OrderDetail.new({
                amount: amount,
                price: products_prices[product_id.to_i],
                order_number: @order.number,
                product_id: product_id
              })
            end
      
            OrderDetail.import order_details
          end
        end

        url = client_orders_show_path(id: @order.client_id, number: @order.number)
        format.html { redirect_to url, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      rescue
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.preload(:address).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :password, :password_confirmation, :is_admin)
    end

    def order_params
      params.require(:order).permit(:number)
    end
end
