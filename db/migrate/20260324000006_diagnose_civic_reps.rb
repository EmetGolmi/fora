class DiagnoseCivicReps < ActiveRecord::Migration[8.1]
  def up
    reps = CivicRepresentative.all
    Rails.logger.info "[FORA DIAG] CivicRepresentative count: #{reps.count}"
    reps.each do |r|
      Rails.logger.info "[FORA DIAG] id=#{r.id} name=#{r.name.inspect} external_ids=#{r.external_ids.inspect}"
    end

    finance = OfficialFinanceSummary.all
    Rails.logger.info "[FORA DIAG] OfficialFinanceSummary count: #{finance.count}"
  end
  def down; end
end
