class DocumentTemplate < ApplicationRecord
  enum :doc_kind,    { operating_agreement: 0, contract: 1, disclosure: 2, invoice: 3, other: 4 }, prefix: true
  enum :authored_by, { fora: 0, profile: 1 }, prefix: true

  validates :legal_disclaimer, presence: true
end
