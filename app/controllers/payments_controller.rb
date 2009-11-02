class PaymentsController < ApplicationController

  # GET /payments/1
  # GET /payments/1.xml
  def show
    @payment = Payment.find(params[:payment_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end
end
