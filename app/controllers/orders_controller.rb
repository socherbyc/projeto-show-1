class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :new_complete]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
    @date_last_close_billing = Setting.date_last_close_billing
  end

  def issue
    @older_closed_order = Order.where('date <= ?', Setting.date_last_close_billing).order('date asc').first
    @newer_closed_order = Order.where('date <= ?', Setting.date_last_close_billing).order('date desc').first
    @products = Product.all
  end

  def issue_show
    @results = IssueShowService.new(params).get_results

    pdf_file = WickedPdf.new.pdf_from_string render_to_string { render pdf: 'orders/issue_show' }
    IssueShowEmailMailer.notify("admin@example.com", pdf_file).deliver_later!

    respond_to do |format|
      format.html
      format.pdf { render pdf: 'orders/issue_show' }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.date = DateTime.current

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def new_complete
    @order = Order.new
  end

  def close_billing
    Setting.date_last_close_billing = DateTime.now
    respond_to do |format|
      format.html { redirect_to orders_path, notice: 'Faturamento fechado.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:number, :client_id)
    end
end
