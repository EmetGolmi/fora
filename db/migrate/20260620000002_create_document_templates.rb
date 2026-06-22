class CreateDocumentTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :document_templates do |t|
      t.string  :name,             null: false
      t.integer :doc_kind,         null: false
      t.text    :body_template,    null: false
      t.jsonb   :placeholders,     null: false, default: []
      t.text    :legal_disclaimer, null: false
      t.integer :authored_by,      null: false, default: 0
      t.integer :version,          null: false, default: 1
      # jurisdictions table does not exist yet — plain nullable column, no FK
      t.bigint  :jurisdiction_id

      t.timestamps
    end

    add_index :document_templates, :jurisdiction_id
  end
end
