class UserImport < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_one_attached :spreadsheet
  enum :status, { pending: 0, processing: 1, completed: 2, failed: 3 }, default: :pending
  validates :spreadsheet, presence: true
  validate :spreadsheet_format
  after_update_commit :broadcast_progress

  def progress_percentage
    return 0 if total_rows.zero?
    ((processed_rows.to_f / total_rows) * 100).round.clamp(0, 100)
  end

  private
    def spreadsheet_format
      return unless spreadsheet.attached?
      extension = File.extname(spreadsheet.filename.to_s).downcase
      allowed_types = %w[text/csv application/csv application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet]
      errors.add(:spreadsheet, "must be a CSV or XLSX file") unless extension.in?(%w[.csv .xlsx])
      errors.add(:spreadsheet, "has an unsupported content type") unless spreadsheet.blob.content_type.in?(allowed_types)
      errors.add(:spreadsheet, "must be smaller than 10 MB") if spreadsheet.blob.byte_size > 10.megabytes
    end

    def broadcast_progress
      broadcast_replace_later_to("user_import_#{id}", target: ActionView::RecordIdentifier.dom_id(self), partial: "admin/user_imports/import", locals: { user_import: self })
    end
end
