class BackfillPhillyBillStages < ActiveRecord::Migration[8.1]
  def up
    CivicBill.where(source: "philly_legistar").find_each do |bill|
      correct_stage = CivicBill.classify_stage(bill.status.to_s)
      bill.update_columns(bill_stage: correct_stage) if bill.bill_stage != correct_stage
    end
  end
  def down; end
end
