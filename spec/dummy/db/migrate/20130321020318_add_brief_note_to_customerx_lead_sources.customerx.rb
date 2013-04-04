# This migration comes from customerx (originally 20130121025235)
class AddBriefNoteToCustomerxLeadSources < ActiveRecord::Migration
  def change
    add_column :customerx_lead_sources, :brief_note, :string
  end
end
