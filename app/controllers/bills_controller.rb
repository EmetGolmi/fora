class BillsController < ApplicationController
  def show
    @bill = CivicBill.find_by(id: params[:id])
    render file: "public/404.html", status: :not_found, layout: false if @bill.nil?
  end
end
